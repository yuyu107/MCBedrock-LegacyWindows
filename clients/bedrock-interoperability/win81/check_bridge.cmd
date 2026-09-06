@echo off
cd /d "%~dp0"
echo ====================================================
echo  MCBedrock Win8.1 Bridge Status
echo ====================================================
echo.
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0check_bridge.ps1"
echo.
pause
