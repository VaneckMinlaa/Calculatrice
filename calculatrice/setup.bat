@echo off
REM ========================================
REM Initial Setup Script - Windows
REM ========================================

SETLOCAL ENABLEDELAYEDEXPANSION

echo.
echo ========================================
echo Calculatrice Microservices - Setup
echo ========================================
echo.

REM Step 1: Check Docker
echo [1/5] Checking Docker installation...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker is not installed or not in PATH!
    echo Please install Docker Desktop from: https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo [OK] Docker is installed
echo.

REM Step 2: Create .env file
echo [2/5] Setting up environment configuration...
if exist ".env" (
    echo [WARNING] .env file already exists
    set /p overwrite="Do you want to overwrite it? (yes/no): "
    if /i "!overwrite!"=="yes" (
        copy /Y env.template .env
        echo [OK] .env file recreated
    ) else (
        echo [OK] Keeping existing .env file
    )
) else (
    copy env.template .env
    echo [OK] .env file created from template
)
echo.

REM Step 3: Make scripts executable (Windows doesn't need chmod)
echo [3/5] Preparing deployment scripts...
echo [OK] Scripts are ready
echo.

REM Step 4: Pull base images
echo [4/5] Pulling Docker base images...
echo This may take several minutes...
docker pull postgres:15-alpine
docker pull maven:3.9.5-eclipse-temurin-17
docker pull eclipse-temurin:17-jre-alpine
echo [OK] Base images pulled
echo.

REM Step 5: Display next steps
echo [5/5] Setup completed successfully!
echo.
echo ========================================
echo Next Steps:
echo ========================================
echo.
echo 1. Edit the .env file if needed:
echo    - Update POSTGRES_PASSWORD for production
echo    - Adjust ports if conflicts exist
echo.
echo 2. Deploy the application:
echo    - Run: deploy.bat
echo    - Select option 1 (Full Deployment)
echo.
echo 3. Verify the deployment:
echo    - Run: health-check.bat
echo    - Or visit: http://localhost:8761
echo.
echo ========================================
echo Configuration Summary:
echo ========================================
type .env
echo ========================================
echo.

pause
ENDLOCAL

