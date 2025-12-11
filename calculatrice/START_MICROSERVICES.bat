@echo off
REM Start Microservices Architecture for Calculatrice
REM This script opens each microservice in a separate command window

REM Set JAVA_HOME to JDK 17 (required for compilation)
set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.4"
set "PATH=%JAVA_HOME%\bin;%PATH%"

echo.
echo ========================================
echo Calculatrice Microservices Startup
echo ========================================
echo.
echo JAVA_HOME is set to: %JAVA_HOME%
echo.

REM Check if Maven Wrapper exists
if not exist "mvnw.cmd" (
    echo ERROR: mvnw.cmd not found!
    echo Please run this script from the calculatrice project root directory.
    pause
    exit /b 1
)

REM Build all modules first
echo Building all modules...
call mvnw clean package -DskipTests
if %errorlevel% neq 0 (
    echo Build failed! Check your Maven setup.
    pause
    exit /b 1
)

echo.
echo All modules built successfully!
echo.
echo Starting microservices in separate windows...
echo.

REM Start Eureka Server FIRST (Port 8761)
echo Starting Eureka Server (Port 8761)...
start "Eureka Server" cmd /k "cd Calaculatrice-eureka-service && ..\mvnw spring-boot:run"

REM Wait for Eureka to start (important!)
echo Waiting for Eureka to start...
timeout /t 15 /nobreak

REM Start API Gateway (Port 8080)
echo Starting API Gateway (Port 8080)...
start "Calculatrice Gateway" cmd /k "cd calculatrice-gateway && ..\mvnw spring-boot:run"

REM Wait a bit for gateway to start
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
echo Eureka Server:      http://localhost:8761
echo API Gateway:        http://localhost:8080
echo Addition Service:   http://localhost:8081
echo Subtraction Service: http://localhost:8082
echo Multiplication Service: http://localhost:8083
echo Division Service:   http://localhost:8084
echo Modulo Service:     http://localhost:8085
echo.
echo IMPORTANT: PostgreSQL doit etre installe et en cours d'execution
echo            avec la base de donnees 'calculatrice_db'
echo.
echo Si PostgreSQL n'est pas installe:
echo   1. Lancez init-postgres.bat pour installer la base
echo   2. Ou utilisez start-all.bat qui verifie PostgreSQL automatiquement
echo.
echo Each service is running in its own window.
echo Close any window to stop that service.
echo.
pause
