$ErrorActionPreference='Continue'
Set-Location -LiteralPath $PSScriptRoot
function Get-OSVersion {
    try { return (Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop).Version }
    catch { return [Environment]::OSVersion.Version.ToString() }
}
function Get-PeMachine([string]$Path) {
    try {
        $fs=[IO.File]::Open($Path,[IO.FileMode]::Open,[IO.FileAccess]::Read,[IO.FileShare]::ReadWrite)
        try {
            $br=New-Object IO.BinaryReader($fs)
            if($br.ReadUInt16() -ne 0x5A4D){ return 0 }
            $fs.Position=0x3C; $pe=$br.ReadInt32(); $fs.Position=$pe
            if($br.ReadUInt32() -ne 0x4550){ return 0 }
            return $br.ReadUInt16()
        } finally { $fs.Dispose() }
    } catch { return 0 }
}

Write-Host '===================================================='
Write-Host ' Java Classic Bedrock - Win8.1 Bridge status'
Write-Host '===================================================='
$osver=Get-OSVersion
Write-Host ('OS version : '+$osver)
Write-Host ('OS x64     : '+[Environment]::Is64BitOperatingSystem)
if(-not $osver.StartsWith('6.3.')){ Write-Host '[WARN] This package is intended only for Windows 8.1 (6.3).' }

$gameExe=Join-Path $PSScriptRoot 'Minecraft.Windows.exe'
if(Test-Path -LiteralPath $gameExe){
    $vi=[Diagnostics.FileVersionInfo]::GetVersionInfo($gameExe)
    $m=Get-PeMachine $gameExe
    Write-Host ('Minecraft   : FOUND, version='+$vi.FileVersion+', machine=0x'+('{0:X4}' -f $m))
    if($m -eq 0x8664){ Write-Host '[OK] Minecraft.Windows.exe is x64.' } else { Write-Host '[WARN] Minecraft.Windows.exe is not x64 or could not be parsed.' }
} else { Write-Host '[WARN] Minecraft.Windows.exe is missing beside this package.' }

$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$bridge=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'Win81JavaClassicBridge.exe'
$wanted='"'+$bridge+'"'
$existing=$null; $ver=$null
try { $p=Get-ItemProperty -LiteralPath $key -ErrorAction Stop; $existing=$p.Debugger; $ver=$p.JavaClassicWin81BridgeVersion } catch {}
Write-Host ('Expected IFEO: '+$wanted)
Write-Host ('Current IFEO : '+($(if($existing){$existing}else{'(none)'})))
Write-Host ('Marker       : '+($(if($ver){$ver}else{'(none)'})))
Write-Host ('Bridge EXE   : '+($(if(Test-Path -LiteralPath $bridge){'FOUND'}else{'MISSING'})))
if($existing -eq $wanted -and (Test-Path -LiteralPath $bridge)){
    Write-Host '[OK] Bridge is installed and ready.'
} elseif($existing -and $existing -ne $wanted){
    Write-Host '[WARN] Minecraft.Windows.exe is currently intercepted by a different IFEO Debugger.'
} else {
    Write-Host '[WARN] Bridge is not fully installed.'
}

$oldTestDlls=@(
 'api-ms-win-core-heap-l2-1-0.dll','api-ms-win-core-libraryloader-l1-2-1.dll','api-ms-win-core-synch-l1-2-1.dll',
 'api-ms-win-core-synch-ansi-l1-1-0.dll','api-ms-win-core-kernel32-legacy-l1-1-2.dll'
)
$left=@(); foreach($n in $oldTestDlls){ if(Test-Path -LiteralPath (Join-Path $PSScriptRoot $n)){ $left += $n } }
if($left.Count -eq 0){ Write-Host '[OK] No old one-by-one ApiSet test DLLs detected.' }
else { Write-Host ('[WARN] Old ApiSet test DLLs still present: '+($left -join ', ')) }

$log=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'win81_java_classic_bridge.log'
if(Test-Path -LiteralPath $log){
    Write-Host ('Log          : '+$log)
    Write-Host '--- Last 12 log lines ---'
    Get-Content -LiteralPath $log -Tail 12 -ErrorAction SilentlyContinue | ForEach-Object { Write-Host $_ }
} else { Write-Host 'Log          : not created yet.' }
Read-Host 'Press Enter to close'
