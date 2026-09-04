$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot
function Is-Admin {
    $id=[Security.Principal.WindowsIdentity]::GetCurrent()
    $p=New-Object Security.Principal.WindowsPrincipal($id)
    return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}
if(-not (Is-Admin)){
    $arg='-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'"'
    $p=Start-Process -FilePath "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -ArgumentList $arg -Wait -PassThru
    exit $p.ExitCode
}
$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$bridge=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'Win81MinecraftBridge.exe'
$wanted='"'+$bridge+'"'
$legacyBridge=Join-Path $PSScriptRoot 'Win81MinecraftBridge.exe'
$legacyWanted='"'+$legacyBridge+'"'
$existing=$null
try { $existing=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger } catch {}
if(-not $existing){
    Write-Host '[INFO] No IFEO Debugger is configured for Minecraft.Windows.exe.'
} elseif(($existing -ne $wanted) -and ($existing -ne $legacyWanted)){
    Write-Host ('[WARN] Current IFEO Debugger belongs to another tool and was left untouched: '+$existing)
} else {
    Remove-ItemProperty -LiteralPath $key -Name Debugger -Force
    Write-Host '[OK] Removed this package''s IFEO Debugger setting (current or legacy path).'
}
Write-Host '[INFO] IFEO removal is complete. To also restore WinPixEventRuntime.dll, run restore_winpix.cmd after closing Minecraft.'
exit 0
