@echo off
REM ============================================
REM Calculatrice Application Startup Script
REM ============================================

echo.
echo ========================================
echo   CALCULATRICE - Application Startup
echo ========================================
echo.
echo This script will start both the backend and frontend.
echo You will need TWO command windows open.
echo.
pause

setlocal enabledelayedexpansion

REM Get the base directory
cd /d "%~dp0"

echo.
echo 1. Starting Backend (Spring Boot on port 8080)...
echo.
cd calculatrice
start "Calculatrice Backend" cmd /k "mvnw.cmd spring-boot:run"

timeout /t 5 /nobreak

echo.
echo 2. Starting Frontend (Angular on port 4200)...
echo.
cd /d "%~dp0"
cd Calculatrice_Frond_End
start "Calculatrice Frontend" cmd /k "npm install & npm start"

echo.
echo ========================================
echo   Startup Complete!
echo ========================================
echo.
echo Backend:  http://localhost:8080
echo Frontend: http://localhost:4200
echo.
echo Open your browser and go to:
echo http://localhost:4200
echo.
echo Press any key to continue...
pause
