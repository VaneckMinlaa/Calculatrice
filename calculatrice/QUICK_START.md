# ⚡ Quick Start Guide

## 🚀 Démarrage Rapide (5 minutes)

### Prérequis
- Docker Desktop installé et démarré
- 4 GB de RAM disponible

---

## 📝 Étapes Rapides

### 1️⃣ Configuration Initiale (Une seule fois)

#### Windows
```bash
setup.bat
```

#### Linux/Mac
```bash
chmod +x setup.sh
./setup.sh
```

### 2️⃣ Déploiement

#### Windows
```bash
deploy.bat
```
➡️ Choisir l'option **1** (Full Deployment)

#### Linux/Mac
```bash
./deploy.sh
```
➡️ Choisir l'option **1** (Full Deployment)

⏳ **Attendre 2-3 minutes** pour que tous les services démarrent.

### 3️⃣ Vérification

#### Accéder aux Services
🌐 Ouvrir dans le navigateur :
- **Eureka Dashboard** : http://localhost:8761
- **API Gateway** : http://localhost:8080

#### Test Rapide
```bash
# Addition : 10 + 5 = 15
curl "http://localhost:8080/api/calculatrice/add?a=10&b=5"

# Multiplication : 7 * 8 = 56
curl "http://localhost:8080/api/calculatrice/multiply?a=7&b=8"
```

---

## 🛑 Arrêter les Services

#### Windows
```bash
stop-services.bat
```

#### Linux/Mac
```bash
./stop-services.sh
```

---

## 🔧 Commandes Utiles

```bash
# Voir les logs en temps réel
docker-compose logs -f

# Vérifier le statut
docker-compose ps

# Redémarrer tout
docker-compose restart
```

---

## 🆘 Problèmes ?

### Service ne démarre pas ?
```bash
docker-compose logs [service-name]
```

### Conflit de port ?
Éditez le fichier `.env` et changez les ports :
```env
GATEWAY_PORT=8090
```

### Tout réinitialiser ?
```bash
docker-compose down -v
./deploy.sh  # Option 1
```

---

## 📚 Documentation Complète

Pour plus de détails, consultez : **[DEPLOYMENT.md](DEPLOYMENT.md)**

---

## 🎯 Architecture

```
┌─────────────────┐
│   API Gateway   │ :8080
│  (Entry Point)  │
└────────┬────────┘
         │
    ┌────┴────┐
    │  Eureka │ :8761
    │ Server  │
    └────┬────┘
         │
    ┌────┴────────────────────────┐
    │                             │
┌───┴───┐  ┌──────┐  ┌──────┐   ┌─┴────┐
│ Add   │  │ Sub  │  │ Mult │...│ Mod  │
│ :8081 │  │:8082 │  │:8083 │   │:8085 │
└───┬───┘  └──┬───┘  └──┬───┘   └──┬───┘
    │         │         │           │
    └─────────┴─────────┴───────────┘
              │
        ┌─────┴─────┐
        │ PostgreSQL│ :5432
        └───────────┘
```

---

**Bon déploiement ! 🚀**

