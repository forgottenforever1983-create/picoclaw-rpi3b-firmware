@echo off
echo ========================================
echo Download Package for Build Machine
echo ========================================
echo.

set OUTPUT_DIR=%USERPROFILE%\Downloads\picoclaw-rpi3b-firmware

echo Creating portable package at:
echo   %OUTPUT_DIR%
echo.

REM Create output directory
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

REM Copy all files
xcopy /E /Y /Q "%~dp0*.*" "%OUTPUT_DIR%\"

echo.
echo Package ready at: %OUTPUT_DIR%
echo.
echo Copy this folder to a Raspberry Pi 4/5 or Debian arm64 VM
echo Then run:
echo   cd picoclaw-rpi3b-firmware
echo   chmod +x build.sh
echo   sudo ./build.sh
echo.

pause