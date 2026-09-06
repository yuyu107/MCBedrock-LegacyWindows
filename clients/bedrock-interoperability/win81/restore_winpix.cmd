@echo off
cd /d "%~dp0"
echo ====================================================
echo  Restore WinPix compatibility change
echo ====================================================
echo.
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0restore_winpix.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (echo [ERROR] Restore failed with exit code %ERR%.) else (echo [OK] Restore finished.)
pause
exit /b %ERR%
