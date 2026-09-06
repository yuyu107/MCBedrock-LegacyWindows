$ErrorActionPreference='Stop'
$local=Join-Path $PSScriptRoot 'shared\check_bridge.ps1'
if(-not(Test-Path -LiteralPath $local)){throw 'Universal Bridge Release payload was not found.'}
& $local -GameRoot $PSScriptRoot
