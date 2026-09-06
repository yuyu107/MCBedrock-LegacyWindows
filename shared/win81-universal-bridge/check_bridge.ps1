param([string]$GameRoot='')
$ErrorActionPreference='SilentlyContinue'
$shared=Join-Path $env:ProgramData 'MCBedrock-LegacyWindows\Win81UniversalBridge'
$exe=Join-Path $shared 'Win81UniversalBridge.exe'
$wanted='"'+$exe+'"'
$ifeo='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
Write-Host '===================================================='
Write-Host ' MCBedrock Win8.1 Universal Bridge Status'
Write-Host '===================================================='
$dbg=$null;try{$dbg=(Get-ItemProperty -LiteralPath $ifeo -Name Debugger -ErrorAction Stop).Debugger}catch{}
Write-Host ('IFEO Debugger: '+$dbg)
if($dbg -eq $wanted){Write-Host '[OK] Universal Bridge owns IFEO.'}else{Write-Host '[WARN] Universal Bridge is not the active IFEO Debugger.'}
if(Test-Path -LiteralPath $exe){$ver=((& $exe --version 2>&1)|Out-String).Trim();Write-Host ('Shared EXE self-version: '+$ver)}else{Write-Host '[ERROR] Shared Win81UniversalBridge.exe is missing.'}
$rootKey='HKLM:\SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge'
try{$rv=(Get-ItemProperty -LiteralPath $rootKey -Name BridgeVersion -ErrorAction Stop).BridgeVersion;Write-Host ('Registry BridgeVersion: '+$rv)}catch{Write-Host 'Registry BridgeVersion: (missing)'}
$targets=$rootKey+'\Targets';$items=@(Get-ChildItem -LiteralPath $targets -ErrorAction SilentlyContinue)
Write-Host '';Write-Host '--- Registered targets ---'
if($items.Count -eq 0){Write-Host '[INFO] No registered targets.'}else{foreach($k in $items){$v=Get-ItemProperty -LiteralPath $k.PSPath;Write-Host ('['+$v.Mode+'] '+$v.Path+'  ('+$v.RegisteredBy+')')}}
if($GameRoot){
  try{$current=[IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetFullPath($GameRoot)) 'Minecraft.Windows.exe'));$found=$false;foreach($k in $items){$v=Get-ItemProperty -LiteralPath $k.PSPath;if([String]::Equals([IO.Path]::GetFullPath($v.Path),$current,[StringComparison]::OrdinalIgnoreCase)){$found=$true;Write-Host ('[CURRENT] '+$v.Mode+' -> '+$v.Path)}};if(-not $found){Write-Host ('[CURRENT] Not registered: '+$current)}}catch{}
}
$log=Join-Path $shared 'win81_universal_bridge.log';Write-Host '';Write-Host '--- Current log tail ---';if(Test-Path -LiteralPath $log){Get-Content -LiteralPath $log -Tail 80}else{Write-Host '[INFO] No Universal Bridge launch log exists yet.'}
