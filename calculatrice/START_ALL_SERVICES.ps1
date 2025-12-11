# ========================================
# SCRIPT POWERSHELL DE DEMARRAGE COMPLET
# Lance PostgreSQL + Eureka + Tous les Microservices
# SANS DOCKER - Credentials sécurisés
# ========================================

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================"
Write-Host "  CALCULATRICE - DEMARRAGE COMPLET"
Write-Host "  Mode: SANS DOCKER"
Write-Host "========================================"
Write-Host ""

# ========================================
# ETAPE 1: Charger les configurations
# ========================================
Write-Host "[1/6] Chargement des configurations securisees..." -ForegroundColor Cyan

if (-not (Test-Path "config.properties")) {
    Write-Host "ERREUR: config.properties n'existe pas!" -ForegroundColor Red
    Write-Host "Veuillez copier config.properties.template vers config.properties" -ForegroundColor Yellow
    Write-Host "et remplir vos credentials." -ForegroundColor Yellow
    Read-Host "Appuyez sur Entree pour quitter"
    exit 1
}

# Fonction pour lire le fichier properties
function Read-Properties {
    param($path)
    $props = @{}
    Get-Content $path | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) {
            $parts = $line.Split("=", 2)
            if ($parts.Length -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                $props[$key] = $value
            }
        }
    }
    return $props
}

$config = Read-Properties "config.properties"

Write-Host "Configuration chargee avec succes!" -ForegroundColor Green
Write-Host "Database: $($config['postgres.db'])"
Write-Host "User: $($config['postgres.user'])"
Write-Host "Password: ********** (masque pour securite)"
Write-Host ""

# ========================================
# ETAPE 2: Configurer Java
# ========================================
Write-Host "[2/6] Configuration de Java..." -ForegroundColor Cyan

if (-not $env:JAVA_HOME) {
    $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"
}
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

try {
    $javaVersion = java -version 2>&1 | Select-String "version"
    Write-Host "Java configure: $env:JAVA_HOME" -ForegroundColor Green
} catch {
    Write-Host "ERREUR: Java n'est pas installe ou JAVA_HOME incorrect!" -ForegroundColor Red
    Read-Host "Appuyez sur Entree pour quitter"
    exit 1
}
Write-Host ""

# ========================================
# ETAPE 3: Vérifier PostgreSQL
# ========================================
Write-Host "[3/6] Verification de PostgreSQL..." -ForegroundColor Cyan

$psqlPath = Join-Path $config['postgres.bin.path'] "psql.exe"
$pgCtlPath = Join-Path $config['postgres.bin.path'] "pg_ctl.exe"

if (Test-Path $psqlPath) {
    Write-Host "PostgreSQL trouve: $($config['postgres.bin.path'])" -ForegroundColor Green
    
    # Vérifier si le service est démarré
    $service = Get-Service -Name "postgresql-x64-15" -ErrorAction SilentlyContinue
    
    if ($service -and $service.Status -eq "Running") {
        Write-Host "PostgreSQL est deja en cours d'execution." -ForegroundColor Green
    } else {
        Write-Host "Demarrage du service PostgreSQL..." -ForegroundColor Yellow
        
        try {
            Start-Service -Name "postgresql-x64-15" -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 3
        } catch {
            Write-Host "Tentative de demarrage en mode standalone..." -ForegroundColor Yellow
            Start-Process -FilePath $pgCtlPath -ArgumentList "-D `"$($config['postgres.data.path'])`" start" -WindowStyle Hidden
            Start-Sleep -Seconds 5
        }
    }
    
    # Tester la connexion
    Write-Host "Test de connexion a PostgreSQL..." -ForegroundColor Cyan
    $env:PGPASSWORD = $config['postgres.password']
    
    $testQuery = "SELECT 1;"
    $result = & $psqlPath -h $config['postgres.host'] -p $config['postgres.port'] -U $config['postgres.user'] -d postgres -c $testQuery 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Connexion PostgreSQL etablie!" -ForegroundColor Green
        
        # Créer la base de données si nécessaire
        Write-Host "Verification de la base de donnees..." -ForegroundColor Cyan
        
        $checkDb = & $psqlPath -h $config['postgres.host'] -p $config['postgres.port'] -U $config['postgres.user'] -d postgres -t -c "SELECT 1 FROM pg_database WHERE datname='$($config['postgres.db'])';" 2>&1
        
        if ($checkDb -notmatch "1") {
            Write-Host "Creation de la base de donnees: $($config['postgres.db'])" -ForegroundColor Yellow
            & $psqlPath -h $config['postgres.host'] -p $config['postgres.port'] -U $config['postgres.user'] -d postgres -c "CREATE DATABASE $($config['postgres.db']);" 2>&1 | Out-Null
            
            if (Test-Path "init-db.sql") {
                Write-Host "Initialisation de la base de donnees..." -ForegroundColor Cyan
                & $psqlPath -h $config['postgres.host'] -p $config['postgres.port'] -U $config['postgres.user'] -d $config['postgres.db'] -f "init-db.sql" 2>&1 | Out-Null
            }
        } else {
            Write-Host "Base de donnees deja existante." -ForegroundColor Green
        }
    } else {
        Write-Host "AVERTISSEMENT: Impossible de se connecter a PostgreSQL!" -ForegroundColor Red
        Write-Host "Verifiez vos credentials et que le service est demarre." -ForegroundColor Yellow
    }
    
    Remove-Item Env:\PGPASSWORD
} else {
    Write-Host "AVERTISSEMENT: PostgreSQL non trouve dans: $($config['postgres.bin.path'])" -ForegroundColor Yellow
    Write-Host "Ajustez le chemin dans config.properties" -ForegroundColor Yellow
}

Write-Host ""

# ========================================
# ETAPE 4: Build du projet
# ========================================
Write-Host "[4/6] Compilation du projet..." -ForegroundColor Cyan

if (-not (Test-Path "mvnw.cmd")) {
    Write-Host "ERREUR: mvnw.cmd introuvable!" -ForegroundColor Red
    Read-Host "Appuyez sur Entree pour quitter"
    exit 1
}

.\mvnw.cmd clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERREUR: La compilation a echoue!" -ForegroundColor Red
    Read-Host "Appuyez sur Entree pour quitter"
    exit 1
}

Write-Host "Compilation reussie!" -ForegroundColor Green
Write-Host ""

# ========================================
# ETAPE 5: Démarrer Eureka
# ========================================
Write-Host "[5/6] Demarrage d'Eureka (Port $($config['eureka.port']))..." -ForegroundColor Cyan

Start-Process cmd -ArgumentList "/k cd Calaculatrice-eureka-service && ..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['eureka.port'])`""

Write-Host "Attente du demarrage d'Eureka (20 secondes)..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

Write-Host ""

# ========================================
# ETAPE 6: Démarrer les microservices
# ========================================
Write-Host "[6/6] Demarrage des microservices..." -ForegroundColor Cyan

$dbUrl = $config['database.url']
$dbUser = $config['postgres.user']
$dbPass = $config['postgres.password']
$eurekaUrl = $config['eureka.url']

# Gateway
Write-Host "Demarrage Gateway (Port $($config['service.gateway.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd calculatrice-gateway && ..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.gateway.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""
Start-Sleep -Seconds 3

# Addition
Write-Host "Demarrage Addition (Port $($config['service.addition.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd microservices\addition-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.addition.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""
Start-Sleep -Seconds 2

# Subtraction
Write-Host "Demarrage Subtraction (Port $($config['service.subtraction.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd microservices\subtraction-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.subtraction.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""
Start-Sleep -Seconds 2

# Multiplication
Write-Host "Demarrage Multiplication (Port $($config['service.multiplication.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd microservices\multiplication-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.multiplication.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""
Start-Sleep -Seconds 2

# Division
Write-Host "Demarrage Division (Port $($config['service.division.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd microservices\division-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.division.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""
Start-Sleep -Seconds 2

# Modulo
Write-Host "Demarrage Modulo (Port $($config['service.modulo.port']))..." -ForegroundColor Cyan
Start-Process cmd -ArgumentList "/k set SPRING_DATASOURCE_URL=$dbUrl && set SPRING_DATASOURCE_USERNAME=$dbUser && set SPRING_DATASOURCE_PASSWORD=$dbPass && cd microservices\modulo-service && ..\..\mvnw spring-boot:run -Dspring-boot.run.arguments=`"--spring.profiles.active=local --server.port=$($config['service.modulo.port']) --eureka.client.serviceUrl.defaultZone=$eurekaUrl`""

Write-Host ""
Write-Host "========================================"
Write-Host "  TOUS LES SERVICES DEMARRENT!"
Write-Host "========================================"
Write-Host ""
Write-Host "URLs des services:" -ForegroundColor Green
Write-Host ""
Write-Host "  Eureka Dashboard:      http://localhost:$($config['eureka.port'])" -ForegroundColor Cyan
Write-Host "  API Gateway:           http://localhost:$($config['service.gateway.port'])" -ForegroundColor Cyan
Write-Host "  Addition Service:      http://localhost:$($config['service.addition.port'])" -ForegroundColor Cyan
Write-Host "  Subtraction Service:   http://localhost:$($config['service.subtraction.port'])" -ForegroundColor Cyan
Write-Host "  Multiplication Service: http://localhost:$($config['service.multiplication.port'])" -ForegroundColor Cyan
Write-Host "  Division Service:      http://localhost:$($config['service.division.port'])" -ForegroundColor Cyan
Write-Host "  Modulo Service:        http://localhost:$($config['service.modulo.port'])" -ForegroundColor Cyan
Write-Host ""
Write-Host "Base de donnees PostgreSQL:" -ForegroundColor Green
Write-Host "  Host: $($config['postgres.host']):$($config['postgres.port'])" -ForegroundColor Cyan
Write-Host "  Database: $($config['postgres.db'])" -ForegroundColor Cyan
Write-Host "  User: $($config['postgres.user'])" -ForegroundColor Cyan
Write-Host ""

Read-Host "Appuyez sur Entree pour ouvrir Eureka Dashboard"
Start-Process "http://localhost:$($config['eureka.port'])"

