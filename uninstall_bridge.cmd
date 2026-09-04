@echo off
cd /d "%~dp0"
echo ====================================================
echo  Uninstall MCBedrock Win8.1 Bridge v2.0
echo ====================================================
echo.
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall_bridge.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (echo [ERROR] Uninstall failed with exit code %ERR%.) else (echo [OK] Uninstall finished.)
pause
exit /b %ERR%
