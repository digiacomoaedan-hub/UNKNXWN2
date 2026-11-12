@echo off
setlocal
cd /d "%~dp0"
set /p PROJECT_NAME=Enter project or episode name:
if "%PROJECT_NAME%"=="" set PROJECT_NAME=Untitled Episode
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0New-UNKNXWNProject.ps1" -ProjectName "%PROJECT_NAME%"
if errorlevel 1 (
  echo.
  echo Project creation failed. Review the message above.
  pause
  exit /b 1
)
echo.
pause