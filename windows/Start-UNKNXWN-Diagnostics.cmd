@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Run-UNKNXWN-Diagnostics.ps1" -OutputPath "%USERPROFILE%\UNKNXWN-diagnostic.json"
if errorlevel 1 (
  echo.
  echo Diagnostics could not complete. Review the message above.
  pause
  exit /b 1
)
echo.
echo Diagnostic complete. Report saved to %USERPROFILE%\UNKNXWN-diagnostic.json
pause