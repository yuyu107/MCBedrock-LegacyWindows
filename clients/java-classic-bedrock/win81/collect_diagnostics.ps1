$ErrorActionPreference='Continue'
Set-Location -LiteralPath $PSScriptRoot
function Get-OSVersion {
    try { return (Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop).Version }
    catch { return [Environment]::OSVersion.Version.ToString() }
}
$stamp=Get-Date -Format 'yyyyMMdd_HHmmss'
$tmp=Join-Path $env:TEMP ('Win81_JavaClassic_Bridge_Diagnostics_'+$stamp)
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
$report=Join-Path $tmp 'diagnostic.txt'
$lines=New-Object Collections.Generic.List[string]
$lines.Add('Minecraft Java Classic Bedrock - Win8.1 Launcher Bridge diagnostic')
$lines.Add('Generated: '+(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$lines.Add('Package: v1.0.0-RC1')
$lines.Add('')
$lines.Add('OS version: '+(Get-OSVersion))
$lines.Add('OS x64: '+[Environment]::Is64BitOperatingSystem)
$lines.Add('PowerShell x64: '+[Environment]::Is64BitProcess)
$lines.Add('')
$gameExe=Join-Path $PSScriptRoot 'Minecraft.Windows.exe'
$lines.Add('Minecraft path: '+$gameExe)
if(Test-Path -LiteralPath $gameExe){
    $vi=[Diagnostics.FileVersionInfo]::GetVersionInfo($gameExe)
    $lines.Add('Minecraft file version: '+$vi.FileVersion)
    $lines.Add('Minecraft file size: '+(Get-Item -LiteralPath $gameExe).Length)
} else { $lines.Add('Minecraft: MISSING') }
$lines.Add('')
$key='HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Minecraft.Windows.exe'
$existing=$null; $marker=$null
try { $p=Get-ItemProperty -LiteralPath $key -ErrorAction Stop; $existing=$p.Debugger; $marker=$p.JavaClassicWin81BridgeVersion } catch {}
$lines.Add('IFEO Debugger: '+($(if($existing){$existing}else{'(none)'})))
$lines.Add('Bridge marker: '+($(if($marker){$marker}else{'(none)'})))
$bridge=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'Win81JavaClassicBridge.exe'
$lines.Add('Bridge EXE exists: '+(Test-Path -LiteralPath $bridge))
$lines.Add('')
$oldTestDlls=@(
 'api-ms-win-core-heap-l2-1-0.dll','api-ms-win-core-libraryloader-l1-2-1.dll','api-ms-win-core-synch-l1-2-1.dll',
 'api-ms-win-core-synch-ansi-l1-1-0.dll','api-ms-win-core-kernel32-legacy-l1-1-2.dll'
)
foreach($n in $oldTestDlls){ $lines.Add(('Old test DLL '+$n+': '+(Test-Path -LiteralPath (Join-Path $PSScriptRoot $n)))) }
$pix=Join-Path $PSScriptRoot 'WinPixEventRuntime.dll'
$lines.Add('WinPixEventRuntime.dll exists: '+(Test-Path -LiteralPath $pix))
$lines.Add('')
$lines.Add('Recent Application Error / WER events mentioning Minecraft or Bridge:')
try {
    $events=Get-WinEvent -FilterHashtable @{LogName='Application';StartTime=(Get-Date).AddHours(-2)} -ErrorAction Stop |
      Where-Object { $_.Id -in 1000,1001 -and ($_.Message -match 'Minecraft\.Windows\.exe|Win81JavaClassicBridge') } |
      Select-Object -First 10
    if($events.Count -eq 0){ $lines.Add('(none found)') }
    foreach($e in $events){
        $lines.Add('---')
        $lines.Add('Time: '+$e.TimeCreated+' Provider: '+$e.ProviderName+' Id: '+$e.Id)
        $msg=($e.Message -replace "`r",'')
        foreach($m in ($msg -split "`n")){ if($m.Trim().Length -gt 0){ $lines.Add($m) } }
    }
} catch { $lines.Add('(event query unavailable: '+$_.Exception.Message+')') }
[IO.File]::WriteAllLines($report,$lines,[Text.Encoding]::UTF8)
$log=Join-Path (Join-Path $PSScriptRoot 'bridge_files') 'win81_java_classic_bridge.log'
if(Test-Path -LiteralPath $log){ Copy-Item -LiteralPath $log -Destination (Join-Path $tmp 'win81_java_classic_bridge.log') -Force }
$readme=Join-Path $tmp 'README.txt'
[IO.File]::WriteAllText($readme,"This diagnostic package does not intentionally collect launcher argument contents. The Bridge log records only argument counts, target paths, compatibility-map actions and exit/error status.`r`n",[Text.Encoding]::UTF8)
$zip=Join-Path $PSScriptRoot ('Win81_JavaClassic_Bridge_Diagnostics_'+$stamp+'.zip')
try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    if(Test-Path -LiteralPath $zip){ Remove-Item -LiteralPath $zip -Force }
    [IO.Compression.ZipFile]::CreateFromDirectory($tmp,$zip,[IO.Compression.CompressionLevel]::Optimal,$false)
    Write-Host ('[OK] Diagnostic package created: '+$zip)
} catch {
    Write-Host ('[WARN] Could not create ZIP: '+$_.Exception.Message)
    Write-Host ('[INFO] Diagnostic files remain here: '+$tmp)
}
try { Remove-Item -LiteralPath $tmp -Recurse -Force } catch {}
Read-Host 'Press Enter to close'
