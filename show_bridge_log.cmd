@echo off
cd /d "%~dp0"
echo ====================================================
echo  MCBedrock Win8.1 Bridge Log
echo ====================================================
echo.
if not exist "bridge_files\win81_launcher_bridge.log" (
  echo [INFO] No bridge log exists yet.
) else (
  type "bridge_files\win81_launcher_bridge.log"
)
echo.
pause
