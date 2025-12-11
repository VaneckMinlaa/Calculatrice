@echo off
REM ========================================
REM Complete Startup Script for Calculatrice
REM ========================================
REM This script starts PostgreSQL and all microservices
REM ========================================

setlocal enabledelayedexpansion

REM Set JAVA_HOME to JDK 17 (required for compilation)
set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.4"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ========================================
echo Calculatrice Complete Startup
echo ========================================
echo.
echo JAVA_HOME is set to: %JAVA_HOME%
echo.

REM ========================================
REM Step 1: Check PostgreSQL (Optional)
REM ========================================
echo [1/5] Checking PostgreSQL...
set "POSTGRES_AVAILABLE=0"

where psql >nul 2>&1
if %errorlevel% equ 0 (
    REM PostgreSQL is in PATH, check if service is running
    sc query postgresql-x64-15 2>nul | find "RUNNING" >nul 2>&1
    if %errorlevel% equ 0 (
        set "POSTGRES_AVAILABLE=1"
        echo PostgreSQL is running!
    ) else (
        echo PostgreSQL is installed but service is not running.
        echo Attempting to start...
        net start postgresql-x64-15 2>nul
        if %errorlevel% equ 0 (
            set "POSTGRES_AVAILABLE=1"
            echo PostgreSQL started successfully!
            timeout /t 5 /nobreak
        ) else (
            echo WARNING: Could not start PostgreSQL service.
        )
    )
) else (
    echo WARNING: PostgreSQL is not installed or not in PATH!
)

if "%POSTGRES_AVAILABLE%"=="0" (
    echo.
    echo ==========================================
    echo WARNING: PostgreSQL n'est pas disponible
    echo ==========================================
    echo.
    echo Les services vont demarrer SANS base de donnees.
    echo Certaines fonctionnalites peuvent ne pas fonctionner.
    echo.
    echo Pour installer PostgreSQL:
    echo   1. Telechargez: https://www.postgresql.org/download/windows/
    echo   2. Installez avec mot de passe: root
    echo   3. Lancez: init-postgres.bat
    echo.
    set /p "CONTINUE=Continuer sans PostgreSQL? (o/n): "
    if /i not "!CONTINUE!"=="o" (
        echo Demarrage annule.
        pause
        exit /b 0
    )
)
echo.

REM ========================================
REM Step 2: Verify Database (if PostgreSQL available)
REM ========================================
if "%POSTGRES_AVAILABLE%"=="1" (
    echo [2/5] Verifying database...
    set "PGPASSWORD=root"
    psql -U postgres -h localhost -p 5432 -lqt 2>nul | find "calculatrice_db" >nul 2>&1
    if %errorlevel% neq 0 (
        echo Database not found! Do you want to create it now?
        set /p "CREATE_DB=Create database? (o/n): "
        if /i "!CREATE_DB!"=="o" (
            call init-postgres.bat
            if %errorlevel% neq 0 (
                echo WARNING: Database initialization failed!
                echo Services will start without database.
            )
        )
    ) else (
        echo Database 'calculatrice_db' is ready!
    )
    set "PGPASSWORD="
) else (
    echo [2/5] Skipping database verification (PostgreSQL not available)
)
echo.

REM ========================================
REM Step 3: Set Environment Variables
REM ========================================
echo [3/5] Setting environment variables...
set "SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/calculatrice_db"
set "SPRING_DATASOURCE_USERNAME=postgres"
set "SPRING_DATASOURCE_PASSWORD=root"
set "EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://localhost:8761/eureka/"
set "EUREKA_CLIENT_ENABLED=true"

echo Environment variables configured!
echo.

REM ========================================
REM Step 4: Build All Modules
REM ========================================
echo [3/5] Building all modules...
if not exist "mvnw.cmd" (
    echo ERROR: mvnw.cmd not found!
    echo Please run this script from the calculatrice project root directory.
    pause
    exit /b 1
)

call mvnw clean package -DskipTests
if %errorlevel% neq 0 (
    echo Build failed! Check your Maven setup.
    pause
    exit /b 1
)

echo.
echo All modules built successfully!
echo.

REM ========================================
REM Step 4: Start All Services
REM ========================================
echo [4/5] Starting all microservices...
echo.

REM Start Eureka Server (Port 8761)
echo Starting Eureka Server (Port 8761)...
start "Eureka Server" cmd /k "cd Calaculatrice-eureka-service && ..\mvnw spring-boot:run"
timeout /t 15 /nobreak

REM Start API Gateway (Port 8080)
echo Starting API Gateway (Port 8080)...
start "Calculatrice Gateway" cmd /k "cd calculatrice-gateway && ..\mvnw spring-boot:run"
timeout /t 5 /nobreak

REM Start Addition Service (Port 8081)
echo Starting Addition Service (Port 8081)...
start "Addition Service" cmd /k "cd microservices\addition-service && ..\..\mvnw spring-boot:run"
timeout /t 3 /nobreak

REM Start Subtraction Service (Port 8082)
echo Starting Subtraction Service (Port 8082)...
start "Subtraction Service" cmd /k "cd microservices\subtraction-service && ..\..\mvnw spring-boot:run"
timeout /t 3 /nobreak

REM Start Multiplication Service (Port 8083)
echo Starting Multiplication Service (Port 8083)...
start "Multiplication Service" cmd /k "cd microservices\multiplication-service && ..\..\mvnw spring-boot:run"
timeout /t 3 /nobreak

REM Start Division Service (Port 8084)
echo Starting Division Service (Port 8084)...
start "Division Service" cmd /k "cd microservices\division-service && ..\..\mvnw spring-boot:run"
timeout /t 3 /nobreak

REM Start Modulo Service (Port 8085)
echo Starting Modulo Service (Port 8085)...
start "Modulo Service" cmd /k "cd microservices\modulo-service && ..\..\mvnw spring-boot:run"

echo.
echo ========================================
echo All services are starting!
echo ========================================
echo.
if "%POSTGRES_AVAILABLE%"=="1" (
    echo Database:           PostgreSQL (localhost:5432/calculatrice_db^)
) else (
    echo Database:           NOT AVAILABLE (services running without DB^)
)
echo Eureka Server:      http://localhost:8761
echo API Gateway:        http://localhost:8080
echo Addition Service:   http://localhost:8081
echo Subtraction Service: http://localhost:8082
echo Multiplication Service: http://localhost:8083
echo Division Service:   http://localhost:8084
echo Modulo Service:     http://localhost:8085
echo.
echo Each service is running in its own window.
echo Close any window to stop that service.
echo.
if "%POSTGRES_AVAILABLE%"=="0" (
    echo NOTE: Les services tournent SANS PostgreSQL.
    echo       Les operations d'ecriture en base ne fonctionneront pas.
    echo.
)
echo To stop all services, run: stop-all.bat
echo.
pause

