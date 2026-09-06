$ErrorActionPreference='Stop'
$local=Join-Path $PSScriptRoot 'shared\unregister_target.ps1'
if(-not(Test-Path -LiteralPath $local)){throw 'Universal Bridge Release payload was not found.'}
& $local -GameRoot $PSScriptRoot
exit $LASTEXITCODE
