@echo off
REM ========================================
REM Stop All Microservices - Windows
REM ========================================

echo.
echo ========================================
echo Stopping All Calculatrice Services
echo ========================================
echo.

docker-compose down

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] All services stopped successfully!
    echo.
) else (
    echo.
    echo [ERROR] Failed to stop services!
    echo.
)

pause

