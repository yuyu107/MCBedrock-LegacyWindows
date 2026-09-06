@echo off
setlocal
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0check_bridge.ps1"
set "RC=%ERRORLEVEL%"
endlocal & exit /b %RC%
