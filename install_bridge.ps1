$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot

function Is-Admin {
    $id=[Security.Principal.WindowsIdentity]::GetCurrent()
    $p=New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if(-not [Environment]::Is64BitOperatingSystem){ throw 'This bridge requires 64-bit Windows.' }
if(-not [Environment]::Is64BitProcess){ throw 'Please run the installer with 64-bit PowerShell.' }

if(-not (Is-Admin)){
    $arg='-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'"'
    $p=Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -ArgumentList $arg -Wait -PassThru
    exit $p.ExitCode
}

$gameExe=Join-Path $PSScriptRoot 'Minecraft.Windows.exe'
if(-not (Test-Path -LiteralPath $gameExe)){ throw 'Put this package beside Minecraft.Windows.exe before installing.' }

$bridgeDir=Join-Path $PSScriptRoot 'bridge_files'
$srcApiSet=Join-Path $bridgeDir 'Win81ApiSetLauncher.cs'
$srcMain=Join-Path $bridgeDir 'Win81MinecraftBridgeMain.cs'
$bridge=Join-Path $bridgeDir 'Win81MinecraftBridge.exe'
$shim=Join-Path $bridgeDir 'W81KERN.dll'
if(-not (Test-Path -LiteralPath $srcApiSet)){ throw 'bridge_files\Win81ApiSetLauncher.cs is missing.' }
if(-not (Test-Path -LiteralPath $srcMain)){ throw 'bridge_files\Win81MinecraftBridgeMain.cs is missing.' }
if(-not (Test-Path -LiteralPath $shim)){ throw 'bridge_files\W81KERN.dll is missing.' }

$netease=Join-Path $PSScriptRoot 'netease.data'
$restore=Join-Path $PSScriptRoot 'netease.data.win81restore'
$builtinHash='45D14225441C9ACDA2FC0E852255C6DA40B55415C4D51CA94163103B57D3BD90'
if(Test-Path -LiteralPath $restore){
    Copy-Item -LiteralPath $restore -Destination $netease -Force
    Write-Host '[OK] Restored the original launcher-login netease.data saved by the built-in-login test build.'
} elseif(Test-Path -LiteralPath $netease){
    $h=(Get-FileHash -LiteralPath $netease -Algorithm SHA256).Hash.ToUpperInvariant()
    if($h -eq $builtinHash){
        throw 'netease.data is still the built-in-login variant. Restore this game version''s original netease.data first, then run the installer again.'
    }
} else {
    throw 'netease.data is missing. Restore the original game file before installing launcher-login mode.'
}

Write-Host '[INFO] Compiling Win8.1 launcher bridge v2.0.1 Release...'
if(Test-Path -LiteralPath $bridge){ Remove-Item -LiteralPath $bridge -Force }
$sourceApiSet=[IO.File]::ReadAllText($srcApiSet,[Text.Encoding]::UTF8)
$sourceMain=[IO.File]::ReadAllText($srcMain,[Text.Encoding]::UTF8)
$provider=New-Object Microsoft.CSharp.CSharpCodeProvider
$cp=New-Object System.CodeDom.Compiler.CompilerParameters
$cp.GenerateExecutable=$true
$cp.GenerateInMemory=$false
$cp.IncludeDebugInformation=$false
$cp.OutputAssembly=$bridge
$cp.CompilerOptions='/platform:x64 /optimize+ /target:exe'
[void]$cp.ReferencedAssemblies.Add('System.dll')
$result=$provider.CompileAssemblyFromSource($cp,@($sourceApiSet,$sourceMain))
if($result.Errors.Count -gt 0){
    foreach($e in $result.Errors){ Write-Host ('[CS] '+$e.ToString()) }
    throw ('Bridge compilation failed with '+$result.Errors.Count+' compiler error(s).')
}
if(-not (Test-Path -LiteralPath $bridge)){ throw 'Bridge compiler reported success but Win81MinecraftBridge.exe was not created.' }
Write-Host '[OK] Win81MinecraftBridge.exe compiled.'

$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$wanted='"'+$bridge+'"'
$legacyBridge=Join-Path $PSScriptRoot 'Win81MinecraftBridge.exe'
$legacyWanted='"'+$legacyBridge+'"'
$existing=$null
try { $existing=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger } catch {}
if($existing){
    if($existing -eq $wanted){
        Write-Host '[OK] Existing IFEO already points to the v2.0.1 bridge path.'
    } elseif($existing -eq $legacyWanted){
        Write-Host ('[MIGRATE] Found v1.9.x/v2.0 legacy IFEO path: '+$existing)
        Write-Host ('[MIGRATE] Updating it to: '+$wanted)
    } else {
        throw ('An existing IFEO Debugger belonging to another tool is configured for Minecraft.Windows.exe: '+$existing+' . It was NOT overwritten.')
    }
}
if(-not (Test-Path -LiteralPath $key)){ New-Item -Path $key -Force | Out-Null }
New-ItemProperty -LiteralPath $key -Name Debugger -PropertyType String -Value $wanted -Force | Out-Null
$verify=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger
if($verify -ne $wanted){ throw ('IFEO verification failed. Current value: '+$verify) }
Write-Host ('[OK] IFEO Debugger now points to: '+$bridge)

$log=Join-Path $bridgeDir 'win81_launcher_bridge.log'
if(Test-Path -LiteralPath $log){ Remove-Item -LiteralPath $log -Force -ErrorAction SilentlyContinue }

Write-Host '[OK] Win8.1 launcher bridge installed.'
Write-Host '[INFO] Open FeverGamesLauncher normally, sign in by QR / phone / email, then click Start Game.'
Write-Host '[INFO] The bridge does not print or save launcher authentication argument contents.'
Write-Host '[INFO] The setting is machine-wide for the image name Minecraft.Windows.exe while installed.'
exit 0
