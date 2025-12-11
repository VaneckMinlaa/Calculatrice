@echo off
REM ========================================
REM Automated Deployment Script for Windows
REM Calculatrice Microservices Architecture
REM ========================================

SETLOCAL ENABLEDELAYEDEXPANSION

echo.
echo ========================================
echo Calculatrice Microservices Deployment
echo ========================================
echo.

REM Check if Docker is running
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not running! Please start Docker Desktop first.
    pause
    exit /b 1
)

echo [OK] Docker is running
echo.

REM Check if .env file exists
if not exist ".env" (
    echo [WARNING] .env file not found!
    echo [INFO] Creating .env from template...
    
    if exist "env.template" (
        copy env.template .env
        echo [OK] .env file created from template
        echo [ACTION REQUIRED] Please edit .env file with your credentials before continuing
        pause
    ) else (
        echo [ERROR] env.template not found! Cannot create .env file.
        pause
        exit /b 1
    )
)

echo [OK] .env file exists
echo.

REM Display menu
echo Select deployment option:
echo.
echo 1. Full Deployment (Stop + Clean + Build + Start)
echo 2. Quick Start (Start existing containers)
echo 3. Stop All Services
echo 4. View Logs
echo 5. Clean Everything (Remove containers, images, volumes)
echo 6. Build Only (No start)
echo 7. Exit
echo.

set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto full_deploy
if "%choice%"=="2" goto quick_start
if "%choice%"=="3" goto stop_services
if "%choice%"=="4" goto view_logs
if "%choice%"=="5" goto clean_all
if "%choice%"=="6" goto build_only
if "%choice%"=="7" goto end
goto invalid_choice

:full_deploy
echo.
echo ========================================
echo Full Deployment Started
echo ========================================
echo.

REM Stop existing containers
echo [1/5] Stopping existing containers...
docker-compose down
echo.

REM Clean old images
echo [2/5] Removing old images...
docker-compose down --rmi local
echo.

REM Build all services
echo [3/5] Building all services...
docker-compose build --no-cache
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)
echo.

REM Start all services
echo [4/5] Starting all services...
docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start services!
    pause
    exit /b 1
)
echo.

REM Wait for services to be ready
echo [5/5] Waiting for services to start...
timeout /t 30 /nobreak
echo.

REM Check service status
echo ========================================
echo Service Status
echo ========================================
docker-compose ps
echo.

REM Display access URLs
echo ========================================
echo Services are now available at:
echo ========================================
echo Eureka Dashboard:    http://localhost:8761
echo API Gateway:         http://localhost:8080
echo Addition Service:    http://localhost:8081
echo Subtraction Service: http://localhost:8082
echo Multiplication:      http://localhost:8083
echo Division Service:    http://localhost:8084
echo Modulo Service:      http://localhost:8085
echo PostgreSQL:          localhost:5432
echo ========================================
echo.
echo [SUCCESS] Deployment completed successfully!
echo.
echo Useful commands:
echo - View logs: docker-compose logs -f
echo - Stop services: docker-compose down
echo - Restart service: docker-compose restart [service-name]
echo.
pause
goto end

:quick_start
echo.
echo ========================================
echo Quick Start
echo ========================================
echo.

docker-compose up -d
if %errorlevel% neq 0 (
    echo [ERROR] Failed to start services!
    pause
    exit /b 1
)

echo [SUCCESS] Services started!
docker-compose ps
echo.
pause
goto end

:stop_services
echo.
echo ========================================
echo Stopping All Services
echo ========================================
echo.

docker-compose down
echo [SUCCESS] All services stopped!
echo.
pause
goto end

:view_logs
echo.
echo ========================================
echo Viewing Logs (Press Ctrl+C to exit)
echo ========================================
echo.

docker-compose logs -f
goto end

:clean_all
echo.
echo ========================================
echo Clean Everything
echo ========================================
echo [WARNING] This will remove all containers, images, and volumes!
echo.

set /p confirm="Are you sure? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo [CANCELLED] Operation cancelled.
    pause
    goto end
)

echo.
echo Cleaning...
docker-compose down -v --rmi all
docker system prune -f
echo [SUCCESS] Everything cleaned!
echo.
pause
goto end

:build_only
echo.
echo ========================================
echo Building All Services
echo ========================================
echo.

docker-compose build --no-cache
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    pause
    exit /b 1
)

echo [SUCCESS] Build completed!
echo.
pause
goto end

:invalid_choice
echo.
echo [ERROR] Invalid choice! Please select 1-7.
echo.
pause
goto end

:end
ENDLOCAL

