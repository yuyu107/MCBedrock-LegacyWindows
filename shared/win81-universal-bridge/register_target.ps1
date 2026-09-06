param(
    [Parameter(Mandatory=$true)][ValidateSet('java-classic','bedrock-interop','interop')][string]$Mode,
    [Parameter(Mandatory=$true)][string]$GameRoot,
    [Parameter(Mandatory=$true)][string]$PayloadRoot
)
$ErrorActionPreference='Stop'
$ExpectedBridgeVersion='MCBedrock Win8.1 Universal Bridge coexistence test v0.4.3'
$CoreVersion='0.4.3'

if($Mode -eq 'interop'){
    Write-Host "[MIGRATE] Legacy mode 'interop' is being normalized to 'bedrock-interop'."
    $Mode='bedrock-interop'
}

trap {
    Write-Host ''
    Write-Host ('[ERROR] '+$_.Exception.Message) -ForegroundColor Red
    Write-Host ''
    Read-Host 'Press Enter to close this administrator PowerShell window'
    exit 1
}

function Is-Admin {
    $id=[Security.Principal.WindowsIdentity]::GetCurrent()
    $p=New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Hash-Path([string]$p) {
    $n=[IO.Path]::GetFullPath($p).TrimEnd('\').ToLowerInvariant()
    $sha=[Security.Cryptography.SHA256]::Create()
    try { $h=$sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($n)) } finally { $sha.Dispose() }
    return (($h|ForEach-Object{$_.ToString('x2')}) -join '')
}

$GameRoot=[IO.Path]::GetFullPath($GameRoot)
$PayloadRoot=[IO.Path]::GetFullPath($PayloadRoot)

if(-not [Environment]::Is64BitOperatingSystem){throw 'Requires Windows 8.1 x64.'}
if(-not [Environment]::Is64BitProcess){throw 'Run with 64-bit PowerShell.'}
$os=(Get-WmiObject Win32_OperatingSystem).Version
if(-not $os.StartsWith('6.3.')){throw ('Only Windows 8.1 (6.3) is supported. Detected: '+$os)}

if(-not(Is-Admin)){
    $arg='-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'" -Mode '+$Mode+' -GameRoot "'+$GameRoot+'" -PayloadRoot "'+$PayloadRoot+'"'
    $p=Start-Process "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -ArgumentList $arg -Wait -PassThru
    exit $p.ExitCode
}

$game=Join-Path $GameRoot 'Minecraft.Windows.exe'
if(-not(Test-Path -LiteralPath $game)){throw ('Minecraft.Windows.exe was not found in: '+$GameRoot)}
$game=[IO.Path]::GetFullPath($game)

$src=Join-Path $PayloadRoot 'Win81UniversalBridge.cs'
$shimSrc=Join-Path $PayloadRoot 'W81KERN.dll'
if(-not(Test-Path -LiteralPath $src)){throw ('Win81UniversalBridge.cs is missing from payload: '+$PayloadRoot)}
if(-not(Test-Path -LiteralPath $shimSrc)){throw ('W81KERN.dll is missing from payload: '+$PayloadRoot)}

$shared=Join-Path $env:ProgramData 'MCBedrock-LegacyWindows\Win81UniversalBridge'
New-Item -ItemType Directory -Path $shared -Force|Out-Null
$srcDst=Join-Path $shared 'Win81UniversalBridge.cs'
$shimDst=Join-Path $shared 'W81KERN.dll'
Copy-Item -LiteralPath $src -Destination $srcDst -Force
Copy-Item -LiteralPath $shimSrc -Destination $shimDst -Force

$exe=Join-Path $shared 'Win81UniversalBridge.exe'
$newExe=Join-Path $shared ('Win81UniversalBridge.v'+$CoreVersion+'.new.exe')
$prevExe=Join-Path $shared 'Win81UniversalBridge.previous.exe'
if(Test-Path -LiteralPath $newExe){Remove-Item -LiteralPath $newExe -Force}

Write-Host ('[INFO] Compiling Universal Bridge Core '+$CoreVersion+' to a temporary executable...')
$provider=New-Object Microsoft.CSharp.CSharpCodeProvider
$cp=New-Object System.CodeDom.Compiler.CompilerParameters
$cp.GenerateExecutable=$true
$cp.GenerateInMemory=$false
$cp.IncludeDebugInformation=$false
$cp.OutputAssembly=$newExe
$cp.CompilerOptions='/platform:x64 /optimize+ /target:exe'
[void]$cp.ReferencedAssemblies.Add('System.dll')
$source=[IO.File]::ReadAllText($srcDst,[Text.Encoding]::UTF8)
$r=$provider.CompileAssemblyFromSource($cp,@($source))
if($r.Errors.Count -gt 0){
    foreach($e in $r.Errors){Write-Host ('[CS] '+$e.ToString())}
    throw ('Universal Bridge compilation failed with '+$r.Errors.Count+' compiler error(s).')
}
if(-not(Test-Path -LiteralPath $newExe)){throw 'Compiler reported success but temporary Universal Bridge was not created.'}

$versionText=((& $newExe --version 2>&1)|Out-String).Trim()
Write-Host ('[VERIFY] Newly compiled bridge: '+$versionText)
if($versionText -ne $ExpectedBridgeVersion){throw ('New bridge version self-check failed. Output: '+$versionText)}

$running=@(Get-Process -Name 'Win81UniversalBridge' -ErrorAction SilentlyContinue)
if($running.Count -gt 0){
    Write-Host '[ERROR] A Universal Bridge process is still running:'
    foreach($p in $running){Write-Host ('        PID '+$p.Id)}
    throw 'Close every Minecraft instance that uses Universal Bridge (or reboot), then install again. No running process was terminated.'
}

if(Test-Path -LiteralPath $prevExe){Remove-Item -LiteralPath $prevExe -Force -ErrorAction SilentlyContinue}
$hadOld=Test-Path -LiteralPath $exe
if($hadOld){Move-Item -LiteralPath $exe -Destination $prevExe -Force}
try { Move-Item -LiteralPath $newExe -Destination $exe -Force }
catch {
    if($hadOld -and (Test-Path -LiteralPath $prevExe) -and -not(Test-Path -LiteralPath $exe)){Move-Item -LiteralPath $prevExe -Destination $exe -Force}
    throw
}

$installedVersion=((& $exe --version 2>&1)|Out-String).Trim()
Write-Host ('[VERIFY] Installed shared bridge: '+$installedVersion)
if($installedVersion -ne $ExpectedBridgeVersion){throw ('Installed bridge version self-check failed. Output: '+$installedVersion)}

$ifeo='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$wanted='"'+$exe+'"'
$existing=$null
try{$existing=(Get-ItemProperty -LiteralPath $ifeo -Name Debugger -ErrorAction Stop).Debugger}catch{}
if($existing -and $existing -ne $wanted){
    $trimmed=$existing.Trim('"')
    $leaf=[IO.Path]::GetFileName($trimmed)
    if($leaf -ne 'Win81JavaClassicBridge.exe' -and $leaf -ne 'Win81MinecraftBridge.exe' -and $leaf -ne 'Win81UniversalBridge.exe'){
        throw ('Another tool owns the Minecraft.Windows.exe IFEO Debugger: '+$existing)
    }
    Write-Host ('[MIGRATE] Replacing known MCBedrock-LegacyWindows bridge IFEO: '+$existing)
}
if(-not(Test-Path -LiteralPath $ifeo)){New-Item -Path $ifeo -Force|Out-Null}
New-ItemProperty -LiteralPath $ifeo -Name Debugger -PropertyType String -Value $wanted -Force|Out-Null
$verifyDebugger=(Get-ItemProperty -LiteralPath $ifeo -Name Debugger -ErrorAction Stop).Debugger
if($verifyDebugger -ne $wanted){throw ('IFEO verification failed. Current value: '+$verifyDebugger)}
Write-Host ('[VERIFY] IFEO Debugger: '+$verifyDebugger)

$hash=Hash-Path $game
$rootKey='HKLM:\SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge'
$targetsRoot=$rootKey+'\Targets'
$tk=$targetsRoot+'\'+$hash
New-Item -Path $tk -Force|Out-Null
New-ItemProperty -LiteralPath $tk -Name Path -PropertyType String -Value $game -Force|Out-Null
New-ItemProperty -LiteralPath $tk -Name Mode -PropertyType String -Value $Mode -Force|Out-Null
New-ItemProperty -LiteralPath $tk -Name RegisteredBy -PropertyType String -Value ('universal-core-'+$CoreVersion) -Force|Out-Null
if(-not(Test-Path -LiteralPath $rootKey)){New-Item -Path $rootKey -Force|Out-Null}
New-ItemProperty -LiteralPath $rootKey -Name BridgeVersion -PropertyType String -Value $CoreVersion -Force|Out-Null

Write-Host ('[OK] Universal Bridge Core '+$CoreVersion+' installed and verified.')
Write-Host ('[OK] Registered target: '+$game)
Write-Host ('[OK] Mode: '+$Mode)
Write-Host ''
Write-Host '--- All registered targets ---'
$items=@(Get-ChildItem -LiteralPath $targetsRoot -ErrorAction SilentlyContinue)
if($items.Count -eq 0){Write-Host '[INFO] No registered targets.'}
else { foreach($k in $items){$v=Get-ItemProperty -LiteralPath $k.PSPath;Write-Host ('['+$v.Mode+'] '+$v.Path)} }

Write-Host ''
Read-Host 'Installation finished. Press Enter to close this administrator PowerShell window'
