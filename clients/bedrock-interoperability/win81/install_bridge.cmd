@echo off
cd /d "%~dp0"
echo ====================================================
echo  MCBedrock Win8.1 Launcher-Login Bridge v2.0.1 Release
echo ====================================================
echo.
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_bridge.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (echo [ERROR] Install failed with exit code %ERR%.) else (echo [OK] Installation finished.)
pause
exit /b %ERR%
