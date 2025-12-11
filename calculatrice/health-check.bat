@echo off
REM ========================================
REM Health Check Script - Windows
REM ========================================

SETLOCAL ENABLEDELAYEDEXPANSION

echo.
echo ========================================
echo Services Health Check
echo ========================================
echo.

REM Function to check service health
set "services=eureka-server:8761 calculatrice-gateway:8080 addition-service:8081 subtraction-service:8082 multiplication-service:8083 division-service:8084 modulo-service:8085"

for %%s in (%services%) do (
    for /f "tokens=1,2 delims=:" %%a in ("%%s") do (
        set "service=%%a"
        set "port=%%b"
        
        echo Checking !service! on port !port!...
        
        curl -s -f -o nul http://localhost:!port!/actuator/health
        if !errorlevel! equ 0 (
            echo [OK] !service! is healthy
        ) else (
            echo [ERROR] !service! is not responding
        )
        echo.
    )
)

echo ========================================
echo Docker Container Status
echo ========================================
docker-compose ps
echo.

echo ========================================
echo PostgreSQL Status
echo ========================================
docker exec calculatrice-postgres pg_isready -U postgres
echo.

pause
ENDLOCAL

