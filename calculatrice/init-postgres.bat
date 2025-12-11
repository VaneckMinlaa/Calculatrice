@echo off
REM ========================================
REM PostgreSQL Database Setup Script
REM ========================================
REM This script initializes PostgreSQL database for the Calculatrice application
REM ========================================

echo.
echo ========================================
echo PostgreSQL Database Setup
echo ========================================
echo.

REM Configuration
set "POSTGRES_USER=postgres"
set "POSTGRES_PASSWORD=root"
set "POSTGRES_DB=calculatrice_db"
set "POSTGRES_PORT=5432"
set "POSTGRES_HOST=localhost"

REM Check if PostgreSQL is installed
where psql >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PostgreSQL is not installed or not in PATH!
    echo.
    echo Please install PostgreSQL from: https://www.postgresql.org/download/windows/
    echo After installation, add PostgreSQL bin directory to your PATH.
    echo Example: C:\Program Files\PostgreSQL\15\bin
    echo.
    pause
    exit /b 1
)

echo PostgreSQL found!
echo.

REM Check if PostgreSQL service is running
sc query postgresql-x64-15 | find "RUNNING" >nul 2>&1
if %errorlevel% neq 0 (
    echo PostgreSQL service is not running. Attempting to start...
    net start postgresql-x64-15
    if %errorlevel% neq 0 (
        echo WARNING: Could not start PostgreSQL service automatically.
        echo Please start it manually from Services (services.msc)
        pause
        exit /b 1
    )
)

echo PostgreSQL service is running!
echo.

REM Set PGPASSWORD environment variable for automatic authentication
set "PGPASSWORD=%POSTGRES_PASSWORD%"

echo Checking if database exists...
psql -U %POSTGRES_USER% -h %POSTGRES_HOST% -p %POSTGRES_PORT% -lqt | find "%POSTGRES_DB%" >nul 2>&1
if %errorlevel% equ 0 (
    echo Database '%POSTGRES_DB%' already exists.
    echo.
    set /p "RECREATE=Do you want to recreate it? (y/N): "
    if /i "!RECREATE!"=="y" (
        echo Dropping existing database...
        psql -U %POSTGRES_USER% -h %POSTGRES_HOST% -p %POSTGRES_PORT% -c "DROP DATABASE IF EXISTS %POSTGRES_DB%;"
        echo Creating new database...
        psql -U %POSTGRES_USER% -h %POSTGRES_HOST% -p %POSTGRES_PORT% -c "CREATE DATABASE %POSTGRES_DB%;"
    )
) else (
    echo Creating database '%POSTGRES_DB%'...
    psql -U %POSTGRES_USER% -h %POSTGRES_HOST% -p %POSTGRES_PORT% -c "CREATE DATABASE %POSTGRES_DB%;"
    if %errorlevel% neq 0 (
        echo ERROR: Failed to create database!
        pause
        exit /b 1
    )
)

echo.
echo Initializing database schema...
psql -U %POSTGRES_USER% -h %POSTGRES_HOST% -p %POSTGRES_PORT% -d %POSTGRES_DB% -f init-db.sql
if %errorlevel% neq 0 (
    echo ERROR: Failed to initialize database schema!
    pause
    exit /b 1
)

echo.
echo ========================================
echo Database setup completed successfully!
echo ========================================
echo.
echo Database Name: %POSTGRES_DB%
echo Host: %POSTGRES_HOST%
echo Port: %POSTGRES_PORT%
echo Username: %POSTGRES_USER%
echo Password: %POSTGRES_PASSWORD%
echo.
echo Connection URL: jdbc:postgresql://%POSTGRES_HOST%:%POSTGRES_PORT%/%POSTGRES_DB%
echo.

REM Clear password from environment
set "PGPASSWORD="

pause

