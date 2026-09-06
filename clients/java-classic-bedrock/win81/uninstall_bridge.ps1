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
$bridge=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'Win81JavaClassicBridge.exe'
$wanted='"'+$bridge+'"'
$existing=$null
try { $existing=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger } catch {}
if(-not $existing){
    Write-Host '[INFO] No IFEO Debugger is configured for Minecraft.Windows.exe.'
} elseif($existing -eq $wanted){
    Remove-ItemProperty -LiteralPath $key -Name Debugger -Force
    Remove-ItemProperty -LiteralPath $key -Name JavaClassicWin81BridgeVersion -Force -ErrorAction SilentlyContinue
    Write-Host '[OK] Java Classic Win8.1 Bridge IFEO entry removed.'
    try {
        $item=Get-Item -LiteralPath $key -ErrorAction Stop
        if($item.Property.Count -eq 0 -and $item.SubKeyCount -eq 0){ Remove-Item -LiteralPath $key -Force }
    } catch {}
} else {
    Write-Host ('[WARN] A different IFEO Debugger is configured and was left untouched: '+$existing)
}
Write-Host '[INFO] Minecraft.Windows.exe and Java Classic launcher files were never modified by this Bridge.'
Read-Host 'Press Enter to close'
