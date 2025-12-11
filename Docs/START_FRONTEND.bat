@echo off
REM ============================================
REM Calculatrice Frontend Startup
REM Start Angular Dev Server (Port 4200)
REM ============================================

title Calculatrice Frontend Server
cd /d "%~dp0Calculatrice_Frond_End"

echo.
echo ========================================
echo  Calculatrice Frontend Startup
echo ========================================
echo.
echo First time: Installing npm packages...
echo.

if not exist node_modules (
    echo Installing dependencies (this takes 1-2 minutes)...
    call npm install
)

echo.
echo Starting Angular dev server on port 4200...
echo.
echo Website will be available at:
echo http://localhost:4200
echo.
echo Press Ctrl+C to stop the server.
echo.

call npm start

pause
