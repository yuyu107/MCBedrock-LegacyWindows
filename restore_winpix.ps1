$ErrorActionPreference='Stop'
Set-Location -LiteralPath $PSScriptRoot
$pix=Join-Path $PSScriptRoot 'WinPixEventRuntime.dll'
if(-not (Test-Path -LiteralPath $pix)){ Write-Host '[INFO] WinPixEventRuntime.dll not found.'; exit 0 }
$current=[IO.File]::ReadAllBytes($pix)
$ascii=[Text.Encoding]::ASCII.GetString($current)
if($ascii.IndexOf('W81KERN.dll',[StringComparison]::Ordinal) -lt 0){ Write-Host '[INFO] WinPixEventRuntime.dll is not patched.'; exit 0 }

function Find-One([byte[]]$data,[string]$text){
    $n=[Text.Encoding]::ASCII.GetBytes($text); $hits=New-Object System.Collections.ArrayList
    for($i=0;$i -le $data.Length-$n.Length;$i++){
        $ok=$true; for($j=0;$j -lt $n.Length;$j++){ if($data[$i+$j]-ne $n[$j]){$ok=$false;break} }
        if($ok){ [void]$hits.Add($i) }
    }
    if($hits.Count -eq 1){ return [int]$hits[0] }
    return -1
}
function Bytes-Equal([byte[]]$a,[byte[]]$b){
    if($a.Length -ne $b.Length){ return $false }
    for($i=0;$i -lt $a.Length;$i++){ if($a[$i]-ne $b[$i]){ return $false } }
    return $true
}

$matches=@()
Get-ChildItem -LiteralPath $PSScriptRoot -Filter 'WinPixEventRuntime.dll.win81bak_*' -File | ForEach-Object {
    try {
        $orig=[IO.File]::ReadAllBytes($_.FullName)
        $pos=Find-One $orig 'KERNEL32.dll'
        if($pos -ge 0){
            $sim=New-Object byte[] $orig.Length
            [Array]::Copy($orig,$sim,$orig.Length)
            $r=[Text.Encoding]::ASCII.GetBytes('W81KERN.dll')
            for($j=0;$j -lt $r.Length;$j++){ $sim[$pos+$j]=$r[$j] }
            $sim[$pos+$r.Length]=0
            if(Bytes-Equal $sim $current){ $matches += $_.FullName }
        }
    } catch {}
}
if($matches.Count -ne 1){
    Write-Host ('[ERROR] Could not identify exactly one matching WinPix backup for the current patched file. Matching backups: '+$matches.Count)
    Write-Host '[INFO] No file was changed. Use the game repair/re-extract function if you need a completely original WinPixEventRuntime.dll.'
    exit 2
}
Copy-Item -LiteralPath $matches[0] -Destination $pix -Force
Write-Host ('[OK] Restored WinPixEventRuntime.dll from: '+[IO.Path]::GetFileName($matches[0]))
$shim=Join-Path $PSScriptRoot 'W81KERN.dll'
if(Test-Path -LiteralPath $shim){
    try { Remove-Item -LiteralPath $shim -Force; Write-Host '[OK] Removed game-directory W81KERN.dll.' }
    catch { Write-Host '[WARN] W81KERN.dll could not be removed (it may still be in use). Reboot and delete it later if desired.' }
}
exit 0
