@echo off
set "LOG=%ProgramData%\MCBedrock-LegacyWindows\Win81UniversalBridge\win81_universal_bridge.log"
echo ====================================================
echo  MCBedrock Win8.1 Universal Bridge Log
echo ====================================================
echo.
if not exist "%LOG%" (
  echo [INFO] No Universal Bridge log exists yet.
) else (
  type "%LOG%"
)
echo.
pause
