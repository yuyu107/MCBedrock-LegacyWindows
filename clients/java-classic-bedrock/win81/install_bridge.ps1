$ErrorActionPreference='Stop'
$local=Join-Path $PSScriptRoot 'shared\register_target.ps1'
$localPayload=Join-Path $PSScriptRoot 'shared'
if(-not(Test-Path -LiteralPath $local)){throw 'Universal Bridge Release payload was not found. Extract the complete Release package beside Minecraft.Windows.exe.'}
& $local -Mode 'java-classic' -GameRoot $PSScriptRoot -PayloadRoot $localPayload
exit $LASTEXITCODE
