@echo off
REM ========================================
REM SCRIPT DE DEMARRAGE COMPLET
REM Lance PostgreSQL + Eureka + Tous les Microservices
REM SANS DOCKER - Credentials sécurisés
REM ========================================

setlocal EnableDelayedExpansion

echo.
echo ========================================
echo   CALCULATRICE - DEMARRAGE COMPLET
echo   Mode: SANS DOCKER
echo ========================================
echo.

REM ========================================
REM ETAPE 1: Charger les configurations depuis config.properties
REM ========================================
echo [1/6] Chargement des configurations securisees...

if not exist "config.properties" (
    echo ERREUR: config.properties n'existe pas!
    echo Veuillez copier config.properties.template vers config.properties
    echo et remplir vos credentials.
    pause
    exit /b 1
)

REM Charger les variables depuis config.properties
for /f "tokens=1,2 delims==" %%a in (config.properties) do (
    set "line=%%a"
    if not "!line:~0,1!"=="#" (
        if not "!line!"=="" (
            set "%%a=%%b"
        )
    )
)

echo Configuration chargee avec succes!
echo Database: %postgres.db%
echo User: %postgres.user%
echo Password: ********** (masque pour securite)
echo.

REM ========================================
REM ETAPE 2: Configurer JAVA_HOME
REM ========================================
echo [2/6] Configuration de Java...

if not defined JAVA_HOME (
    set "JAVA_HOME=C:\Program Files\Java\jdk-17"
)
set "PATH=%JAVA_HOME%\bin;%PATH%"

java -version 2>&1 | findstr "version" >nul
if %errorlevel% neq 0 (
    echo ERREUR: Java n'est pas installe ou JAVA_HOME n'est pas correct!
    pause
    exit /b 1
)

echo Java configure: %JAVA_HOME%
echo.

REM ========================================
REM ETAPE 3: Vérifier et démarrer PostgreSQL
REM ========================================
echo [3/6] Verification de PostgreSQL...

REM Vérifier si PostgreSQL est installé
if exist "%postgres.bin.path%\psql.exe" (
    echo PostgreSQL trouve: %postgres.bin.path%
    
    REM Vérifier si le service PostgreSQL est déjà démarré
    sc query postgresql-x64-15 | findstr "RUNNING" >nul
    if %errorlevel% equ 0 (
        echo PostgreSQL est deja en cours d'execution.
    ) else (
        echo Demarrage du service PostgreSQL...
        net start postgresql-x64-15 2>nul
        if %errorlevel% neq 0 (
            echo Tentative de demarrage en mode standalone...
            start "PostgreSQL Server" "%postgres.bin.path%\pg_ctl.exe" -D "%postgres.data.path%" start
            timeout /t 5 /nobreak >nul
        )
    )
    
    REM Vérifier la connexion à la base de données
    echo Verification de la connexion a la base de donnees...
    "%postgres.bin.path%\psql.exe" -h %postgres.host% -p %postgres.port% -U %postgres.user% -d postgres -c "SELECT 1;" >nul 2>&1
    
    if %errorlevel% equ 0 (
        echo Connexion PostgreSQL etablie avec succes!
        
        REM Créer la base de données si elle n'existe pas
        echo Creation de la base de donnees si necessaire...
        "%postgres.bin.path%\psql.exe" -h %postgres.host% -p %postgres.port% -U %postgres.user% -d postgres -c "SELECT 1 FROM pg_database WHERE datname='%postgres.db%';" | findstr "1 row" >nul
        
        if %errorlevel% neq 0 (
            echo Creation de la base de donnees: %postgres.db%
            "%postgres.bin.path%\psql.exe" -h %postgres.host% -p %postgres.port% -U %postgres.user% -d postgres -c "CREATE DATABASE %postgres.db%;"
            
            REM Initialiser la base de données avec le script init
            if exist "init-db.sql" (
                echo Initialisation de la base de donnees...
                "%postgres.bin.path%\psql.exe" -h %postgres.host% -p %postgres.port% -U %postgres.user% -d %postgres.db% -f init-db.sql
            )
        ) else (
            echo Base de donnees deja existante.
        )
    ) else (
        echo AVERTISSEMENT: Impossible de se connecter a PostgreSQL!
        echo Verifiez que le service est demarre et que les credentials sont corrects.
        echo Mot de passe PostgreSQL: %postgres.password%
    )
) else (
    echo AVERTISSEMENT: PostgreSQL n'est pas trouve dans: %postgres.bin.path%
    echo Veuillez installer PostgreSQL ou ajuster le chemin dans config.properties
)

echo.

REM ========================================
REM ETAPE 4: Build du projet
REM ========================================
echo [4/6] Compilation du projet...

if not exist "mvnw.cmd" (
    echo ERREUR: mvnw.cmd introuvable!
    pause
    exit /b 1
)

call mvnw clean package -DskipTests
if %errorlevel% neq 0 (
    echo ERREUR: La compilation a echoue!
    pause
    exit /b 1
)

echo Compilation reussie!
echo.

REM ========================================
REM ETAPE 5: Démarrer Eureka Server
REM ========================================
echo [5/6] Demarrage du serveur Eureka (Port %eureka.port%)...

start "Eureka Server" cmd /k "cd Calaculatrice-eureka-service && ..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%eureka.port%"

echo Attente du demarrage d'Eureka (20 secondes)...
timeout /t 20 /nobreak >nul

echo.

REM ========================================
REM ETAPE 6: Démarrer tous les microservices
REM ========================================
echo [6/6] Demarrage des microservices...

REM Définir les variables d'environnement pour Spring Boot
set SPRING_DATASOURCE_URL=%database.url%
set SPRING_DATASOURCE_USERNAME=%postgres.user%
set SPRING_DATASOURCE_PASSWORD=%postgres.password%
set EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=%eureka.url%

echo Demarrage de la Gateway (Port %service.gateway.port%)...
start "Gateway Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd calculatrice-gateway && ..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.gateway.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

timeout /t 3 /nobreak >nul

echo Demarrage du service Addition (Port %service.addition.port%)...
start "Addition Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd microservices\addition-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.addition.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

timeout /t 2 /nobreak >nul

echo Demarrage du service Subtraction (Port %service.subtraction.port%)...
start "Subtraction Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd microservices\subtraction-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.subtraction.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

timeout /t 2 /nobreak >nul

echo Demarrage du service Multiplication (Port %service.multiplication.port%)...
start "Multiplication Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd microservices\multiplication-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.multiplication.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

timeout /t 2 /nobreak >nul

echo Demarrage du service Division (Port %service.division.port%)...
start "Division Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd microservices\division-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.division.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

timeout /t 2 /nobreak >nul

echo Demarrage du service Modulo (Port %service.modulo.port%)...
start "Modulo Service" cmd /k "set SPRING_DATASOURCE_URL=%database.url% && set SPRING_DATASOURCE_USERNAME=%postgres.user% && set SPRING_DATASOURCE_PASSWORD=%postgres.password% && cd microservices\modulo-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=--spring.profiles.active=local --server.port=%service.modulo.port% --eureka.client.serviceUrl.defaultZone=%eureka.url%"

echo.
echo ========================================
echo   TOUS LES SERVICES SONT EN COURS DE DEMARRAGE!
echo ========================================
echo.
echo URLs des services:
echo.
echo   Eureka Dashboard:      http://localhost:%eureka.port%
echo   API Gateway:           http://localhost:%service.gateway.port%
echo   Addition Service:      http://localhost:%service.addition.port%
echo   Subtraction Service:   http://localhost:%service.subtraction.port%
echo   Multiplication Service: http://localhost:%service.multiplication.port%
echo   Division Service:      http://localhost:%service.division.port%
echo   Modulo Service:        http://localhost:%service.modulo.port%
echo.
echo Base de donnees PostgreSQL:
echo   Host: %postgres.host%:%postgres.port%
echo   Database: %postgres.db%
echo   User: %postgres.user%
echo.
echo Chaque service tourne dans sa propre fenetre.
echo Fermez une fenetre pour arreter le service correspondant.
echo.
echo Appuyez sur une touche pour ouvrir le dashboard Eureka...
pause >nul
start http://localhost:%eureka.port%

echo.
pause

