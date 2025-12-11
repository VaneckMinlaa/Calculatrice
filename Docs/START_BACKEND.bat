@echo off
REM ============================================
REM Calculatrice Backend Startup
REM Start Backend Server (Port 8080)
REM ============================================

title Calculatrice Backend Server
cd /d "%~dp0calculatrice"

echo.
echo ========================================
echo  Calculatrice Backend Startup
echo ========================================
echo.
echo Starting Spring Boot on port 8080...
echo.
echo Website will be available at:
echo http://localhost:8080/api/calculatrice/health
echo.
echo Press Ctrl+C to stop the server.
echo.

mvnw.cmd spring-boot:run

pause
