# Guide de Déploiement - Calculatrice Microservices

## 📋 Table des Matières

1. [Prérequis](#prérequis)
2. [Configuration PostgreSQL](#configuration-postgresql)
3. [Démarrage Local](#démarrage-local)
4. [Déploiement GitLab CI/CD](#déploiement-gitlab-cicd)
5. [Déploiement Manuel](#déploiement-manuel)
6. [Rollback](#rollback)
7. [Monitoring et Maintenance](#monitoring-et-maintenance)
8. [Dépannage](#dépannage)

---

## 🔧 Prérequis

### Logiciels Requis

- **Java JDK 17** ou supérieur
- **Maven 3.8+** (ou utiliser le Maven Wrapper inclus)
- **PostgreSQL 12+**
- **Git**

### Configuration Système

#### Windows
```batch
# Vérifier Java
java -version

# Vérifier Maven
mvn -version

# Vérifier PostgreSQL
psql --version
```

#### Linux/Mac
```bash
# Vérifier Java
java -version

# Vérifier Maven
mvn -version

# Vérifier PostgreSQL
psql --version
```

---

## 🗄️ Configuration PostgreSQL

### Installation PostgreSQL

#### Windows
1. Télécharger depuis: https://www.postgresql.org/download/windows/
2. Installer avec les paramètres par défaut
3. Ajouter PostgreSQL au PATH: `C:\Program Files\PostgreSQL\15\bin`

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Configuration de la Base de Données

#### Méthode Automatique (Recommandée)

**Windows:**
```batch
cd calculatrice
init-postgres.bat
```

**Linux/Mac:**
```bash
cd calculatrice
chmod +x scripts/*.sh
./scripts/init-postgres.sh  # À créer si nécessaire
```

#### Méthode Manuelle

```bash
# Se connecter à PostgreSQL
psql -U postgres

# Créer la base de données
CREATE DATABASE calculatrice_db;

# Se connecter à la base
\c calculatrice_db

# Exécuter le script d'initialisation
\i init-db.sql

# Vérifier les tables
\dt
```

### Configuration des Identifiants

Les identifiants par défaut sont:
- **Utilisateur**: `postgres`
- **Mot de passe**: `root`
- **Base de données**: `calculatrice_db`
- **Port**: `5432`

Pour modifier ces paramètres, créer un fichier `.env`:

```properties
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/calculatrice_db
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=root
```

---

## 🚀 Démarrage Local

### Démarrage Complet (PostgreSQL + Tous les Microservices)

#### Windows
```batch
cd calculatrice
start-all.bat
```

Ce script va:
1. ✅ Vérifier et démarrer PostgreSQL
2. ✅ Vérifier/initialiser la base de données
3. ✅ Compiler tous les modules Maven
4. ✅ Démarrer tous les microservices dans des fenêtres séparées

#### Services Démarrés

| Service | Port | URL |
|---------|------|-----|
| Eureka Server | 8761 | http://localhost:8761 |
| API Gateway | 8080 | http://localhost:8080 |
| Addition Service | 8081 | http://localhost:8081 |
| Subtraction Service | 8082 | http://localhost:8082 |
| Multiplication Service | 8083 | http://localhost:8083 |
| Division Service | 8084 | http://localhost:8084 |
| Modulo Service | 8085 | http://localhost:8085 |

### Arrêt des Services

#### Windows
```batch
cd calculatrice
stop-all.bat
```

#### Linux/Mac
```bash
cd calculatrice
./scripts/stop-all.sh
```

### Vérification de l'État des Services

#### Windows
```batch
cd calculatrice
health-check.bat
```

#### Linux/Mac
```bash
cd calculatrice
./scripts/health-check.sh
```

---

## 🔄 Déploiement GitLab CI/CD

### Configuration GitLab

#### 1. Variables d'Environnement GitLab

Aller dans **Settings > CI/CD > Variables** et ajouter:

```properties
# SSH Configuration
SSH_PRIVATE_KEY=<votre_clé_privée_ssh>

# Deployment Server
DEPLOY_SERVER_HOST=<adresse_serveur>
DEPLOY_USER=deployer
DEPLOY_PATH=/opt/calculatrice

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=calculatrice_db
DB_USER=postgres
DB_PASSWORD=<mot_de_passe_sécurisé>
```

#### 2. Configuration SSH

Sur le serveur de déploiement:

```bash
# Créer utilisateur de déploiement
sudo adduser deployer
sudo usermod -aG sudo deployer

# Configurer SSH
sudo mkdir -p /home/deployer/.ssh
sudo nano /home/deployer/.ssh/authorized_keys
# Coller votre clé publique SSH

# Permissions
sudo chmod 700 /home/deployer/.ssh
sudo chmod 600 /home/deployer/.ssh/authorized_keys
sudo chown -R deployer:deployer /home/deployer/.ssh

# Créer répertoire de déploiement
sudo mkdir -p /opt/calculatrice
sudo chown -R deployer:deployer /opt/calculatrice
```

### Pipeline CI/CD

Le pipeline `.gitlab-ci.yml` comprend les étapes suivantes:

#### Stages

1. **validate** - Validation du projet et des dépendances
2. **build** - Compilation de tous les modules
3. **test** - Tests unitaires avec PostgreSQL
4. **package** - Création des fichiers JAR
5. **deploy-dev** - Déploiement en développement
6. **deploy-staging** - Déploiement en staging
7. **deploy-prod** - Déploiement en production

#### Déclenchement du Pipeline

```bash
# Développement (branche develop)
git checkout develop
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin develop

# Staging (branche main)
git checkout main
git merge develop
git push origin main

# Production (tag)
git tag -a v1.0.0 -m "Version 1.0.0"
git push origin v1.0.0
```

### Déploiement Manuel via GitLab

1. Aller dans **CI/CD > Pipelines**
2. Sélectionner le pipeline souhaité
3. Cliquer sur le bouton "Play" (▶️) pour le job de déploiement
4. Confirmer le déploiement

---

## 📦 Déploiement Manuel

### Déploiement en Développement

```bash
cd calculatrice
chmod +x scripts/deploy-dev.sh
./scripts/deploy-dev.sh
```

### Déploiement en Staging

```bash
cd calculatrice
chmod +x scripts/deploy-staging.sh
./scripts/deploy-staging.sh
```

**Note**: Le script demandera une confirmation avant de déployer.

### Déploiement en Production

```bash
cd calculatrice
chmod +x scripts/deploy-prod.sh
./scripts/deploy-prod.sh
```

**Sécurité**: Le script de production demande plusieurs confirmations:
1. Confirmation de déploiement en production
2. Confirmation des tests en staging
3. Confirmation finale

### Processus de Déploiement

Chaque script de déploiement effectue:

1. ✅ Vérifications pré-déploiement (espace disque, connectivité)
2. 📦 Création d'un répertoire de release horodaté
3. 💾 Sauvegarde du déploiement actuel
4. 🗄️ Sauvegarde de la base de données (production)
5. ⏹️ Arrêt gracieux des services
6. 📤 Upload des fichiers JAR et configurations
7. 🔄 Mise à jour du schéma de base de données
8. ▶️ Démarrage des nouveaux services
9. 🏥 Vérifications de santé
10. 🧹 Nettoyage des anciennes releases

---

## ⏮️ Rollback

### Rollback Automatique

En cas d'échec des health checks en production, le rollback est automatique.

### Rollback Manuel

```bash
cd calculatrice
chmod +x scripts/rollback.sh
./scripts/rollback.sh
```

Le script va:
1. Identifier la release précédente
2. Arrêter les services actuels
3. Basculer vers la release précédente
4. Redémarrer les services
5. Vérifier la santé des services

### Rollback via GitLab

1. Aller dans **CI/CD > Pipelines**
2. Trouver le job "rollback"
3. Cliquer sur "Play" (▶️)
4. Confirmer le rollback

---

## 📊 Monitoring et Maintenance

### Endpoints de Monitoring

Chaque service expose des endpoints Actuator:

```bash
# Health Check
curl http://localhost:8080/actuator/health

# Metrics
curl http://localhost:8080/actuator/metrics

# Info
curl http://localhost:8080/actuator/info
```

### Logs

#### Local (Windows)
Les logs s'affichent dans les fenêtres de commande de chaque service.

#### Serveur de Déploiement
```bash
# Logs de tous les services
tail -f /opt/calculatrice/logs/*.log

# Log d'un service spécifique
tail -f /opt/calculatrice/logs/gateway.log

# Rechercher des erreurs
grep -i error /opt/calculatrice/logs/*.log
```

### Sauvegarde de la Base de Données

#### Sauvegarde Manuelle

```bash
# Windows
set PGPASSWORD=root
pg_dump -U postgres -h localhost calculatrice_db > backup.sql

# Linux/Mac
export PGPASSWORD=root
pg_dump -U postgres -h localhost calculatrice_db > backup.sql
```

#### Restauration

```bash
# Windows
set PGPASSWORD=root
psql -U postgres -h localhost calculatrice_db < backup.sql

# Linux/Mac
export PGPASSWORD=root
psql -U postgres -h localhost calculatrice_db < backup.sql
```

### Nettoyage

```bash
# Nettoyer les anciennes releases (garder les 10 dernières)
cd /opt/calculatrice/releases
ls -t | tail -n +11 | xargs rm -rf

# Nettoyer les anciennes sauvegardes (plus de 30 jours)
find /opt/calculatrice/backup -mtime +30 -delete

# Nettoyer les logs (plus de 7 jours)
find /opt/calculatrice/logs -name "*.log" -mtime +7 -delete
```

---

## 🔍 Dépannage

### Problème: PostgreSQL ne démarre pas

**Windows:**
```batch
# Vérifier le service
sc query postgresql-x64-15

# Démarrer le service
net start postgresql-x64-15

# Vérifier les logs
type "C:\Program Files\PostgreSQL\15\data\pg_log\*.log"
```

**Linux:**
```bash
# Vérifier le statut
sudo systemctl status postgresql

# Démarrer le service
sudo systemctl start postgresql

# Vérifier les logs
sudo tail -f /var/log/postgresql/postgresql-15-main.log
```

### Problème: Port déjà utilisé

```bash
# Windows - Trouver le processus
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux - Trouver et tuer le processus
lsof -ti:8080
kill -9 $(lsof -ti:8080)
```

### Problème: Erreur de connexion à la base de données

1. Vérifier que PostgreSQL est démarré
2. Vérifier les identifiants dans `application.yml`
3. Vérifier que la base de données existe:
   ```bash
   psql -U postgres -l | grep calculatrice_db
   ```
4. Vérifier les règles du pare-feu pour le port 5432

### Problème: Service ne démarre pas

```bash
# Vérifier les logs du service
tail -f /opt/calculatrice/logs/gateway.log

# Vérifier la configuration Java
java -version

# Vérifier l'espace disque
df -h

# Vérifier la mémoire
free -h
```

### Problème: Health check échoue

```bash
# Vérifier que le service écoute sur le bon port
netstat -tuln | grep 8080

# Tester manuellement
curl -v http://localhost:8080/actuator/health

# Vérifier les logs pour les erreurs
grep -i error /opt/calculatrice/logs/*.log
```

### Problème: Build Maven échoue

```bash
# Nettoyer et rebuilder
mvn clean install -U

# Ignorer les tests temporairement
mvn clean install -DskipTests

# Vérifier les dépendances
mvn dependency:tree
```

---

## 📞 Support

### Contacts

- **Équipe DevOps**: devops@example.com
- **Équipe Développement**: dev@example.com

### Ressources

- **Documentation Spring Boot**: https://spring.io/projects/spring-boot
- **Documentation PostgreSQL**: https://www.postgresql.org/docs/
- **Documentation GitLab CI/CD**: https://docs.gitlab.com/ee/ci/

---

## 📝 Checklist de Déploiement

### Avant le Déploiement

- [ ] Tests unitaires passent
- [ ] Tests d'intégration passent
- [ ] Code review effectuée
- [ ] Documentation mise à jour
- [ ] Variables d'environnement configurées
- [ ] Sauvegarde de la base de données effectuée
- [ ] Plan de rollback préparé

### Pendant le Déploiement

- [ ] Services arrêtés correctement
- [ ] Nouveaux fichiers déployés
- [ ] Configuration mise à jour
- [ ] Services redémarrés
- [ ] Health checks passent

### Après le Déploiement

- [ ] Tous les services sont opérationnels
- [ ] Tests de fumée effectués
- [ ] Monitoring actif
- [ ] Équipe notifiée
- [ ] Documentation de release mise à jour

---

## 🔐 Sécurité

### Bonnes Pratiques

1. **Ne jamais committer les mots de passe** dans le code source
2. Utiliser des **variables d'environnement** pour les secrets
3. Changer les **mots de passe par défaut** en production
4. Utiliser **HTTPS** pour les communications externes
5. Maintenir **Java et PostgreSQL à jour**
6. Effectuer des **sauvegardes régulières**
7. Limiter les **accès SSH** au serveur de production
8. Utiliser des **clés SSH** au lieu de mots de passe

### Rotation des Secrets

```bash
# Changer le mot de passe PostgreSQL
ALTER USER postgres WITH PASSWORD 'nouveau_mot_de_passe';

# Mettre à jour les variables d'environnement
# Redémarrer les services
```

---

## 📈 Performance

### Optimisations Java

Les scripts de production utilisent des paramètres JVM optimisés:

```bash
JAVA_OPTS="-Xmx2048m -Xms1024m \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -Djava.security.egd=file:/dev/./urandom"
```

### Optimisations PostgreSQL

```sql
-- Augmenter les connexions max
ALTER SYSTEM SET max_connections = 200;

-- Optimiser la mémoire
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';

-- Redémarrer PostgreSQL
```

---

**Version**: 1.0.0  
**Dernière mise à jour**: Décembre 2025

