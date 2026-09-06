@echo off
cd /d "%~dp0"
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_bridge.ps1"
set "E=%ERRORLEVEL%"
echo.
pause
exit /b %E%
