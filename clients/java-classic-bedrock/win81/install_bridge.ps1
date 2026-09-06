$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot

function Is-Admin {
    $id=[Security.Principal.WindowsIdentity]::GetCurrent()
    $p=New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
function Get-OSVersion {
    try { return (Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop).Version }
    catch { return [Environment]::OSVersion.Version.ToString() }
}
function Get-PeMachine([string]$Path) {
    $fs=[IO.File]::Open($Path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
    try {
        $br=New-Object IO.BinaryReader($fs)
        if($br.ReadUInt16() -ne 0x5A4D){ return 0 }
        $fs.Position=0x3C; $pe=$br.ReadInt32()
        if($pe -lt 0x40 -or $pe -gt ($fs.Length-6)){ return 0 }
        $fs.Position=$pe
        if($br.ReadUInt32() -ne 0x4550){ return 0 }
        return $br.ReadUInt16()
    } finally { $fs.Dispose() }
}

if(-not [Environment]::Is64BitOperatingSystem){ throw 'This bridge requires 64-bit Windows 8.1.' }
if(-not [Environment]::Is64BitProcess){ throw 'Please run this installer with 64-bit PowerShell.' }
$osver=Get-OSVersion
if(-not $osver.StartsWith('6.3.')){ throw ('This package is only for Windows 8.1 x64 (6.3). Detected OS version: '+$osver) }

if(-not (Is-Admin)){
    $arg='-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'"'
    $p=Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -ArgumentList $arg -Wait -PassThru
    exit $p.ExitCode
}

$gameExe=Join-Path $PSScriptRoot 'Minecraft.Windows.exe'
if(-not (Test-Path -LiteralPath $gameExe)){ throw 'Minecraft.Windows.exe was not found. Extract all package files into the same directory as Minecraft.Windows.exe.' }
$machine=Get-PeMachine $gameExe
if($machine -ne 0x8664){ throw ('Minecraft.Windows.exe is not an x64 PE image. PE machine=0x'+('{0:X4}' -f $machine)) }

$vi=[Diagnostics.FileVersionInfo]::GetVersionInfo($gameExe)
Write-Host ('[INFO] Windows version: '+$osver)
Write-Host ('[INFO] Minecraft: '+$gameExe)
Write-Host ('[INFO] Minecraft file version: '+$vi.FileVersion)
if($vi.FileVersion -and $vi.FileVersion -ne '1.21.120.0'){
    Write-Host '[WARN] The verified build is 1.21.120.0. This installer does not use a version/hash whitelist, so this newer/different x64 build will still be allowed for testing.'
}

$oldTestDlls=@(
 'api-ms-win-core-heap-l2-1-0.dll',
 'api-ms-win-core-libraryloader-l1-2-1.dll',
 'api-ms-win-core-synch-l1-2-1.dll',
 'api-ms-win-core-synch-ansi-l1-1-0.dll',
 'api-ms-win-core-kernel32-legacy-l1-1-2.dll'
)
$left=@()
foreach($n in $oldTestDlls){ if(Test-Path -LiteralPath (Join-Path $PSScriptRoot $n)){ $left += $n } }
if($left.Count -gt 0){
    Write-Host '[WARN] Old one-by-one ApiSet test DLLs are still present:'
    foreach($n in $left){ Write-Host ('       '+$n) }
    Write-Host '[WARN] They are not part of this Bridge and should be moved out of the game directory for a clean test.'
}

$bridgeDir=Join-Path $PSScriptRoot 'bridge_files'
$src=Join-Path $bridgeDir 'Win81JavaClassicBridge.cs'
$bridge=Join-Path $bridgeDir 'Win81JavaClassicBridge.exe'
if(-not (Test-Path -LiteralPath $src)){ throw 'bridge_files\Win81JavaClassicBridge.cs is missing.' }

Write-Host '[INFO] Compiling Win8.1 Java Classic Launcher Bridge v1.0.0-RC1...'
if(Test-Path -LiteralPath $bridge){ Remove-Item -LiteralPath $bridge -Force }
$source=[IO.File]::ReadAllText($src,[Text.Encoding]::UTF8)
$provider=New-Object Microsoft.CSharp.CSharpCodeProvider
$cp=New-Object System.CodeDom.Compiler.CompilerParameters
$cp.GenerateExecutable=$true
$cp.GenerateInMemory=$false
$cp.IncludeDebugInformation=$false
$cp.OutputAssembly=$bridge
$cp.CompilerOptions='/platform:x64 /optimize+ /target:exe'
[void]$cp.ReferencedAssemblies.Add('System.dll')
$result=$provider.CompileAssemblyFromSource($cp,@($source))
if($result.Errors.Count -gt 0){
    foreach($e in $result.Errors){ Write-Host ('[CS] '+$e.ToString()) }
    throw ('Bridge compilation failed with '+$result.Errors.Count+' compiler error(s).')
}
if(-not (Test-Path -LiteralPath $bridge)){ throw 'Bridge compiler reported success but Win81JavaClassicBridge.exe was not created.' }
Write-Host '[OK] Win81JavaClassicBridge.exe compiled.'

$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$wanted='"'+$bridge+'"'
$existing=$null
try { $existing=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger } catch {}
if($existing -and $existing -ne $wanted){
    throw ('Another IFEO Debugger is already configured for Minecraft.Windows.exe: '+$existing+' . It was NOT overwritten. Uninstall/disable the other bridge or tool first.')
}
if(-not (Test-Path -LiteralPath $key)){ New-Item -Path $key -Force | Out-Null }
New-ItemProperty -LiteralPath $key -Name Debugger -PropertyType String -Value $wanted -Force | Out-Null
New-ItemProperty -LiteralPath $key -Name JavaClassicWin81BridgeVersion -PropertyType String -Value '1.0.0-RC1' -Force | Out-Null
$verify=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger
if($verify -ne $wanted){ throw ('IFEO verification failed. Current value: '+$verify) }

$log=Join-Path $bridgeDir 'win81_java_classic_bridge.log'
if(Test-Path -LiteralPath $log){ Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue }

Write-Host '[OK] Win8.1 Java Classic Launcher Bridge v1.0.0-RC1 installed.'
Write-Host '[INFO] Open the Java Classic launcher normally, then start its Bedrock edition.'
Write-Host '[INFO] The bridge does not modify Minecraft.Windows.exe or the Java Classic launcher.'
Write-Host '[INFO] Launcher arguments are forwarded unchanged; their contents are not written to the bridge log.'
Write-Host '[WARN] IFEO is machine-wide for the image name Minecraft.Windows.exe while installed.'
Write-Host '[INFO] check_bridge.cmd = status; collect_diagnostics.cmd = diagnostic ZIP; uninstall_bridge.cmd = remove interception.'
Read-Host 'Press Enter to close'
