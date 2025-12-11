# 🚀 Guide de Déploiement - Architecture Microservices Calculatrice

## 📋 Table des Matières
- [Vue d'Ensemble](#vue-densemble)
- [Prérequis](#prérequis)
- [Configuration Sécurisée](#configuration-sécurisée)
- [Déploiement](#déploiement)
- [Vérification](#vérification)
- [Gestion des Services](#gestion-des-services)
- [Dépannage](#dépannage)

---

## 🏗️ Vue d'Ensemble

Cette architecture microservices comprend :

### Services
1. **PostgreSQL Database** (Port 5432) - Base de données relationnelle
2. **Eureka Server** (Port 8761) - Service Discovery
3. **API Gateway** (Port 8080) - Point d'entrée principal
4. **Addition Service** (Port 8081) - Opérations d'addition
5. **Subtraction Service** (Port 8082) - Opérations de soustraction
6. **Multiplication Service** (Port 8083) - Opérations de multiplication
7. **Division Service** (Port 8084) - Opérations de division
8. **Modulo Service** (Port 8085) - Opérations modulo

---

## ✅ Prérequis

### Logiciels Requis
- **Docker Desktop** (Windows/Mac) ou **Docker Engine** (Linux) - Version 20.10+
- **Docker Compose** - Version 2.0+
- **Git** (optionnel)

### Vérification de l'Installation
```bash
docker --version
docker-compose --version
```

---

## 🔒 Configuration Sécurisée

### 1. Configuration des Credentials

Les credentials de la base de données sont **masqués** et gérés via des variables d'environnement.

#### Étape 1 : Créer le fichier .env
```bash
# Windows
copy env.template .env

# Linux/Mac
cp env.template .env
```

#### Étape 2 : Éditer le fichier .env
Ouvrez le fichier `.env` et modifiez les valeurs si nécessaire :

```env
# PostgreSQL Database Configuration
POSTGRES_DB=calculatrice_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=root  # ⚠️ Changez ce mot de passe en production!

# Database Connection URL
DATABASE_URL=jdbc:postgresql://postgres-db:5432/calculatrice_db

# Application Ports
EUREKA_PORT=8761
GATEWAY_PORT=8080
ADDITION_PORT=8081
SUBTRACTION_PORT=8082
MULTIPLICATION_PORT=8083
DIVISION_PORT=8084
MODULO_PORT=8085
```

#### ⚠️ IMPORTANT - Sécurité
- Le fichier `.env` est **automatiquement ignoré** par Git (`.gitignore`)
- **Ne jamais commiter** le fichier `.env` dans le dépôt
- Utiliser des mots de passe forts en production
- Le fichier `env.template` est un modèle sans credentials réels

---

## 🚀 Déploiement

### Option 1 : Déploiement Complet (Recommandé)

#### Windows
```bash
deploy.bat
```
Sélectionnez l'option **1** (Full Deployment)

#### Linux/Mac
```bash
chmod +x deploy.sh
./deploy.sh
```
Sélectionnez l'option **1** (Full Deployment)

### Option 2 : Docker Compose Manuel

```bash
# Construire et démarrer tous les services
docker-compose up -d --build

# Voir les logs en temps réel
docker-compose logs -f

# Voir le statut des services
docker-compose ps
```

---

## ✅ Vérification

### 1. Vérification Automatique

#### Windows
```bash
health-check.bat
```

#### Linux/Mac
```bash
chmod +x health-check.sh
./health-check.sh
```

### 2. Vérification Manuelle

#### Accéder aux Services
- **Eureka Dashboard** : http://localhost:8761
- **API Gateway** : http://localhost:8080
- **Services individuels** : http://localhost:8081-8085

#### Test de Calcul via Gateway
```bash
# Addition : 10 + 5
curl "http://localhost:8080/api/calculatrice/add?a=10&b=5"

# Soustraction : 20 - 8
curl "http://localhost:8080/api/calculatrice/subtract?a=20&b=8"

# Multiplication : 5 * 4
curl "http://localhost:8080/api/calculatrice/multiply?a=5&b=4"

# Division : 100 / 5
curl "http://localhost:8080/api/calculatrice/divide?a=100&b=5"

# Modulo : 17 % 5
curl "http://localhost:8080/api/calculatrice/modulo?a=17&b=5"
```

#### Vérifier PostgreSQL
```bash
# Connexion à PostgreSQL
docker exec -it calculatrice-postgres psql -U postgres -d calculatrice_db

# Dans psql, exécuter :
\dt                                    # Lister les tables
SELECT * FROM calculation_history;     # Voir l'historique
\q                                     # Quitter
```

---

## 🔧 Gestion des Services

### Arrêter les Services

#### Windows
```bash
stop-services.bat
```

#### Linux/Mac
```bash
./stop-services.sh
```

#### Docker Compose
```bash
docker-compose down
```

### Redémarrer un Service Spécifique
```bash
# Redémarrer l'API Gateway
docker-compose restart calculatrice-gateway

# Redémarrer un service de calcul
docker-compose restart addition-service
```

### Voir les Logs

```bash
# Tous les services
docker-compose logs -f

# Service spécifique
docker-compose logs -f calculatrice-gateway
docker-compose logs -f postgres-db

# Dernières 100 lignes
docker-compose logs --tail=100
```

### Reconstruire un Service
```bash
# Reconstruire et redémarrer un service
docker-compose up -d --build addition-service
```

---

## 🛠️ Dépannage

### Problème 1 : Docker n'est pas démarré
**Erreur** : `Cannot connect to the Docker daemon`

**Solution** :
- Windows : Démarrer Docker Desktop
- Linux : `sudo systemctl start docker`

### Problème 2 : Port déjà utilisé
**Erreur** : `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Solution** :
```bash
# Voir les processus utilisant le port 8080
netstat -ano | findstr :8080    # Windows
lsof -i :8080                   # Linux/Mac

# Modifier le port dans .env
GATEWAY_PORT=8090
```

### Problème 3 : Service ne démarre pas
**Solution** :
```bash
# Voir les logs détaillés
docker-compose logs [service-name]

# Redémarrer le service
docker-compose restart [service-name]

# Reconstruire complètement
docker-compose down
docker-compose up -d --build
```

### Problème 4 : Base de données non accessible
**Solution** :
```bash
# Vérifier que PostgreSQL est démarré
docker-compose ps postgres-db

# Vérifier les logs
docker-compose logs postgres-db

# Recréer le volume (⚠️ supprime les données)
docker-compose down -v
docker-compose up -d
```

### Problème 5 : Mémoire insuffisante
**Solution** :
```bash
# Nettoyer les ressources Docker
docker system prune -a
docker volume prune

# Augmenter la mémoire Docker Desktop (Windows/Mac)
# Settings → Resources → Memory → Augmenter à 4GB minimum
```

---

## 📊 Architecture des Données

### Schéma de la Base de Données

```sql
-- Table : calculation_history
CREATE TABLE calculation_history (
    id BIGSERIAL PRIMARY KEY,
    operation_type VARCHAR(50) NOT NULL,
    operand1 DECIMAL(20, 10) NOT NULL,
    operand2 DECIMAL(20, 10) NOT NULL,
    result DECIMAL(20, 10) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    service_name VARCHAR(100),
    user_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Sauvegarde de la Base de Données

```bash
# Exporter la base de données
docker exec calculatrice-postgres pg_dump -U postgres calculatrice_db > backup.sql

# Restaurer la base de données
docker exec -i calculatrice-postgres psql -U postgres calculatrice_db < backup.sql
```

---

## 🔄 Workflow CI/CD (Future)

### Structure pour GitHub Actions / GitLab CI

```yaml
# .github/workflows/deploy.yml
name: Deploy Microservices

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and Deploy
        run: |
          docker-compose build
          docker-compose up -d
```

---

## 📝 Commandes Utiles

### Surveillance
```bash
# Surveiller l'utilisation des ressources
docker stats

# Voir les conteneurs actifs
docker ps

# Inspecter un service
docker inspect calculatrice-gateway
```

### Maintenance
```bash
# Nettoyer les images inutilisées
docker image prune -a

# Nettoyer les volumes inutilisés
docker volume prune

# Nettoyer tout le système
docker system prune -a --volumes
```

---

## 📞 Support

Pour toute question ou problème :
1. Vérifier les logs : `docker-compose logs`
2. Consulter la documentation Docker : https://docs.docker.com
3. Vérifier les issues GitHub du projet

---

## 📄 Licence

Ce projet est sous licence MIT.

---

**Dernière mise à jour** : Décembre 2025
**Version** : 1.0.0

