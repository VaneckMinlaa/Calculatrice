@echo off
REM ========================================
REM Stop All Microservices Script
REM ========================================
REM This script stops all running microservices
REM ========================================

echo.
echo ========================================
echo Stopping All Microservices
echo ========================================
echo.

REM Kill all Java processes running Spring Boot applications
echo Stopping all Java Spring Boot processes...

REM Find and kill processes by port
for %%p in (8761 8080 8081 8082 8083 8084 8085) do (
    echo Checking port %%p...
    for /f "tokens=5" %%a in ('netstat -aon ^| find ":%%p" ^| find "LISTENING"') do (
        echo Stopping process on port %%p (PID: %%a)
        taskkill /F /PID %%a >nul 2>&1
    )
)

REM Alternative: Kill all java.exe processes (use with caution)
REM taskkill /F /IM java.exe >nul 2>&1

echo.
echo ========================================
echo All services stopped!
echo ========================================
echo.
echo Note: PostgreSQL database is still running.
echo To stop PostgreSQL, run: net stop postgresql-x64-15
echo.
pause

