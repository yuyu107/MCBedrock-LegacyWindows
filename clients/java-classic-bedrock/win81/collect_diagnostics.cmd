@echo off
setlocal
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0collect_diagnostics.ps1"
set "RC=%ERRORLEVEL%"
endlocal & exit /b %RC%
