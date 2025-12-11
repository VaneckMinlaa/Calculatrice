# 🚀 Guide de Démarrage Rapide - Calculatrice Microservices

## Démarrage Local (Sans Docker)

### 1️⃣ Installation PostgreSQL

#### Windows
1. Télécharger PostgreSQL: https://www.postgresql.org/download/windows/
2. Installer avec les paramètres par défaut
3. Mot de passe: `root` (pour l'utilisateur `postgres`)

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### 2️⃣ Initialiser la Base de Données

```batch
cd calculatrice
init-postgres.bat
```

### 3️⃣ Démarrer Tous les Services

```batch
cd calculatrice
start-all.bat
```

Ce script va automatiquement:
- ✅ Vérifier PostgreSQL
- ✅ Compiler le projet
- ✅ Démarrer tous les microservices

### 4️⃣ Accéder aux Services

| Service | URL |
|---------|-----|
| 🌐 API Gateway | http://localhost:8080 |
| 🔍 Eureka Dashboard | http://localhost:8761 |
| ➕ Addition | http://localhost:8081 |
| ➖ Subtraction | http://localhost:8082 |
| ✖️ Multiplication | http://localhost:8083 |
| ➗ Division | http://localhost:8084 |
| 📐 Modulo | http://localhost:8085 |

### 5️⃣ Arrêter les Services

```batch
cd calculatrice
stop-all.bat
```

---

## 🔄 Déploiement GitLab CI/CD

### Configuration Initiale

1. **Configurer les variables GitLab** (Settings > CI/CD > Variables):
   ```
   SSH_PRIVATE_KEY=<votre_clé_ssh>
   DEPLOY_SERVER_HOST=<adresse_serveur>
   DB_PASSWORD=<mot_de_passe_db>
   ```

2. **Préparer le serveur de déploiement**:
   ```bash
   # Créer l'utilisateur de déploiement
   sudo adduser deployer
   sudo mkdir -p /opt/calculatrice
   sudo chown deployer:deployer /opt/calculatrice
   
   # Configurer SSH
   sudo mkdir -p /home/deployer/.ssh
   # Ajouter votre clé publique dans authorized_keys
   ```

3. **Pousser le code sur GitLab**:
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

### Pipeline Automatique

Le pipeline se déclenche automatiquement sur:
- **Push sur `develop`** → Tests + Déploiement Dev (manuel)
- **Push sur `main`** → Tests + Déploiement Staging (manuel)
- **Tag (v1.x.x)** → Tests + Déploiement Production (manuel)

### Déploiement Manuel

```bash
# Développement
./scripts/deploy-dev.sh

# Staging
./scripts/deploy-staging.sh

# Production
./scripts/deploy-prod.sh
```

---

## 📊 Vérification de Santé

```bash
# Vérifier tous les services
./scripts/health-check.sh

# Vérifier un service spécifique
curl http://localhost:8080/actuator/health
```

---

## ⏮️ Rollback

En cas de problème:

```bash
./scripts/rollback.sh
```

---

## 📖 Documentation Complète

Voir [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) pour la documentation complète.

---

## 🆘 Aide Rapide

### PostgreSQL ne démarre pas
```batch
net start postgresql-x64-15
```

### Port déjà utilisé
```batch
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Erreur de build Maven
```batch
mvnw clean install -U
```

---

## 📞 Support

Pour toute question, consultez [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) ou contactez l'équipe DevOps.

