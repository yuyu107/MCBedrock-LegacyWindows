$ErrorActionPreference='SilentlyContinue'
Set-Location -LiteralPath $PSScriptRoot
$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$bridge=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'Win81MinecraftBridge.exe'
$wanted='"'+$bridge+'"'
$legacyBridge=Join-Path $PSScriptRoot 'Win81MinecraftBridge.exe'
$legacyWanted='"'+$legacyBridge+'"'
$existing=$null
try { $existing=(Get-ItemProperty -LiteralPath $key -Name Debugger -ErrorAction Stop).Debugger } catch {}
if(-not $existing){
    Write-Host '[STATUS] IFEO bridge: NOT INSTALLED'
} elseif($existing -eq $wanted){
    Write-Host '[STATUS] IFEO bridge: INSTALLED (v2.0.1 current path)'
} elseif($existing -eq $legacyWanted){
    Write-Host '[STATUS] IFEO bridge: LEGACY v1.9.x/v2.0 PATH (run install_bridge.cmd to migrate)'
    Write-Host ('[STATUS] Legacy target: '+$legacyBridge)
} else {
    Write-Host ('[STATUS] IFEO bridge: OTHER DEBUGGER CONFIGURED: '+$existing)
}
if(Test-Path -LiteralPath $bridge){ Write-Host '[STATUS] Bridge executable: present' } else { Write-Host '[STATUS] Bridge executable: missing (run install_bridge.cmd)' }
$pix=Join-Path $PSScriptRoot 'WinPixEventRuntime.dll'
if(Test-Path -LiteralPath $pix){
    $bytes=[IO.File]::ReadAllBytes($pix)
    $txt=[Text.Encoding]::ASCII.GetString($bytes)
    if($txt.IndexOf('W81KERN.dll',[StringComparison]::Ordinal) -ge 0){ Write-Host '[STATUS] WinPix compatibility: patched' }
    elseif($txt.IndexOf('SetThreadDescription',[StringComparison]::Ordinal) -ge 0){ Write-Host '[STATUS] WinPix compatibility: not patched yet (bridge will patch on first launch)' }
    else { Write-Host '[STATUS] WinPix compatibility: not required by this WinPix build' }
} else { Write-Host '[STATUS] WinPixEventRuntime.dll: not found' }
$netease=Join-Path $PSScriptRoot 'netease.data'
if(Test-Path -LiteralPath $netease){
    $builtin='45D14225441C9ACDA2FC0E852255C6DA40B55415C4D51CA94163103B57D3BD90'
    $h=(Get-FileHash -LiteralPath $netease -Algorithm SHA256).Hash.ToUpperInvariant()
    if($h -eq $builtin){ Write-Host '[STATUS] netease.data: built-in-login variant (launcher login will not work as intended)' }
    else { Write-Host '[STATUS] netease.data: launcher-login/original variant' }
}
