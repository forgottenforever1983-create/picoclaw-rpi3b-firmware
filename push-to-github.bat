@echo off
echo ========================================
echo PicoClaw RPI3B+ Firmware - Git Push
echo ========================================
echo.

REM Check for GitHub CLI
where gh >nul 2>&1
if %errorlevel% neq 0 (
  echo GitHub CLI (gh) not found.
  echo.
  echo Please install it from: https://cli.github.com
  echo Or use manual push below.
  echo.
  goto :manual
)

REM Check if already authenticated
gh auth status >nul 2>&1
if %errorlevel% neq 0 (
  echo Not authenticated with GitHub.
  echo Run: gh auth login
  echo.
  goto :manual
)

REM Create and push
echo Creating repository and pushing...
gh repo create picoclaw-rpi3b-firmware --public --source=. --push

echo.
echo Done! Check: https://github.com/YOUR_USERNAME/picoclaw-rpi3b-firmware
goto :end

:manual
echo ========================================
echo MANUAL PUSH INSTRUCTIONS
echo ========================================
echo.
echo 1. Go to: https://github.com/new
echo 2. Create repository named: picoclaw-rpi3b-firmware
echo 3. Run these commands:
echo.
echo    cd "%~dp0"
echo    git init
echo    git add .
echo    git commit -m "Initial PicoClaw RPI3B+ firmware v1.0"
echo    git remote add origin https://github.com/YOUR_USERNAME/picoclaw-rpi3b-firmware.git
echo    git push -u origin main
echo.

:end
pause