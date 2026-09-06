param([Parameter(Mandatory=$true)][string]$GameRoot)
$ErrorActionPreference='Stop'
function Is-Admin{$id=[Security.Principal.WindowsIdentity]::GetCurrent();$p=New-Object Security.Principal.WindowsPrincipal($id);return $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)}
function Hash-Path([string]$p){$n=[IO.Path]::GetFullPath($p).TrimEnd('\').ToLowerInvariant();$s=[Security.Cryptography.SHA256]::Create();try{$h=$s.ComputeHash([Text.Encoding]::UTF8.GetBytes($n))}finally{$s.Dispose()};return (($h|ForEach-Object{$_.ToString('x2')})-join '')}
$GameRoot=[IO.Path]::GetFullPath($GameRoot)
if(-not(Is-Admin)){$p=Start-Process "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Verb RunAs -ArgumentList ('-NoProfile -ExecutionPolicy Bypass -File "'+$PSCommandPath+'" -GameRoot "'+$GameRoot+'"') -Wait -PassThru;exit $p.ExitCode}
$game=[IO.Path]::GetFullPath((Join-Path $GameRoot 'Minecraft.Windows.exe'))
$hash=Hash-Path $game
$root='HKLM:\SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge\Targets'
$tk=$root+'\'+$hash
if(Test-Path -LiteralPath $tk){Remove-Item -LiteralPath $tk -Recurse -Force;Write-Host ('[OK] Unregistered: '+$game)}else{Write-Host '[INFO] This target was not registered.'}
$left=@(Get-ChildItem -LiteralPath $root -ErrorAction SilentlyContinue)
if($left.Count -eq 0){
    $shared=Join-Path $env:ProgramData 'MCBedrock-LegacyWindows\Win81UniversalBridge'
    $wanted='"'+(Join-Path $shared 'Win81UniversalBridge.exe')+'"'
    $ifeo='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
    $dbg=$null;try{$dbg=(Get-ItemProperty -LiteralPath $ifeo -Name Debugger -ErrorAction Stop).Debugger}catch{}
    if($dbg -eq $wanted){Remove-ItemProperty -LiteralPath $ifeo -Name Debugger -Force;Write-Host '[OK] No registered targets remain; Universal IFEO Debugger removed.'}
    else{Write-Host '[INFO] No registered targets remain, but IFEO belongs to another value/tool; it was not changed.'}
} else {
    Write-Host ('[INFO] '+$left.Count+' registered target(s) remain; shared IFEO is kept.')
}
Write-Host ''
Read-Host 'Uninstall finished. Press Enter to close this administrator PowerShell window'
