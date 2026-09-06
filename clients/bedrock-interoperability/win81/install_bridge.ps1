$ErrorActionPreference='Stop'
$local=Join-Path $PSScriptRoot 'shared\register_target.ps1'
$localPayload=Join-Path $PSScriptRoot 'shared'
$repo=Join-Path $PSScriptRoot '..\..\..\shared\win81-universal-bridge\register_target.ps1'
$repoPayload=Join-Path $PSScriptRoot '..\..\..\shared\win81-universal-bridge'
if(Test-Path -LiteralPath $local){$script=$local;$payload=$localPayload}elseif(Test-Path -LiteralPath $repo){$script=[IO.Path]::GetFullPath($repo);$payload=[IO.Path]::GetFullPath($repoPayload)}else{throw 'Universal Bridge payload was not found. Use the complete Release package or repository checkout.'}
& $script -Mode 'bedrock-interop' -GameRoot $PSScriptRoot -PayloadRoot $payload
exit $LASTEXITCODE
