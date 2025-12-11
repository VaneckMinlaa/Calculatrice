# 🚀 Guide de Démarrage Rapide - MICROSERVICES

## ⚠️ PROBLÈME: Les services ne démarrent pas?

### Solution 1: Utiliser START_MICROSERVICES.bat (RECOMMANDÉ)

Ce script a été corrigé et démarre maintenant **TOUS** les services dans le bon ordre :

```batch
cd calculatrice
START_MICROSERVICES.bat
```

**Ce script va:**
1. ✅ Compiler le projet Maven
2. ✅ Démarrer **Eureka Server** (IMPORTANT - nécessaire pour les autres services)
3. ✅ Démarrer Gateway
4. ✅ Démarrer tous les microservices

**IMPORTANT:** PostgreSQL doit être installé et configuré avec la base `calculatrice_db`

---

### Solution 2: Utiliser start-all.bat (avec vérification PostgreSQL)

Ce script vérifie PostgreSQL et peut fonctionner SANS base de données :

```batch
cd calculatrice
start-all.bat
```

**Ce script va:**
1. ✅ Vérifier si PostgreSQL est installé
2. ✅ Proposer de continuer sans DB si PostgreSQL n'est pas disponible
3. ✅ Démarrer tous les services

---

## 📋 Configuration PostgreSQL

### Étape 1: Installer PostgreSQL

**Windows:**
1. Télécharger: https://www.postgresql.org/download/windows/
2. Installer avec les options par défaut
3. **IMPORTANT:** Définir le mot de passe `root` pour l'utilisateur `postgres`
4. Ajouter PostgreSQL au PATH: `C:\Program Files\PostgreSQL\15\bin`

### Étape 2: Initialiser la Base de Données

```batch
cd calculatrice
init-postgres.bat
```

Identifiants par défaut:
- **Utilisateur:** postgres
- **Mot de passe:** root
- **Base de données:** calculatrice_db
- **Port:** 5432

---

## 🔍 Vérifier que les services sont lancés

### Méthode 1: Vérifier les fenêtres CMD

Après avoir lancé le script, vous devriez voir **7 fenêtres CMD** ouvertes:
1. Eureka Server
2. Gateway
3. Addition Service
4. Subtraction Service
5. Multiplication Service
6. Division Service
7. Modulo Service

### Méthode 2: Vérifier dans le navigateur

Ouvrez votre navigateur et allez sur:

**Eureka Dashboard:** http://localhost:8761

Vous devriez voir tous les services enregistrés :
- CALCULATRICE-GATEWAY
- ADDITION-SERVICE
- SUBTRACTION-SERVICE
- MULTIPLICATION-SERVICE
- DIVISION-SERVICE
- MODULO-SERVICE

### Méthode 3: Tester l'API Gateway

```bash
curl http://localhost:8080/actuator/health
```

Devrait retourner: `{"status":"UP"}`

---

## 🛑 Problèmes Courants

### Problème 1: "PostgreSQL is not installed or not in PATH"

**Solutions:**
1. Installer PostgreSQL (voir ci-dessus)
2. OU ajouter PostgreSQL au PATH:
   ```
   setx PATH "%PATH%;C:\Program Files\PostgreSQL\15\bin"
   ```
3. OU utiliser `start-all.bat` et choisir de continuer sans PostgreSQL

### Problème 2: Les services ne s'enregistrent pas dans Eureka

**Cause:** Eureka Server n'a pas démarré correctement ou n'a pas eu assez de temps

**Solution:**
- Fermer toutes les fenêtres CMD des services
- Relancer `START_MICROSERVICES.bat`
- Attendre au moins 30 secondes avant de vérifier http://localhost:8761

### Problème 3: Port déjà utilisé

**Message:** "Port 8080 is already in use"

**Solution:**
```batch
REM Trouver le processus
netstat -ano | findstr :8080

REM Tuer le processus (remplacer PID par le numéro trouvé)
taskkill /PID <PID> /F

REM OU utiliser le script d'arrêt
stop-all.bat
```

### Problème 4: Services démarrent puis s'arrêtent

**Cause probable:** Erreur de connexion à PostgreSQL

**Vérifier les logs dans la fenêtre CMD du service:**
- Chercher `Connection refused` ou `database does not exist`

**Solution:**
1. Vérifier que PostgreSQL est démarré:
   ```batch
   sc query postgresql-x64-15
   ```
2. Si pas démarré:
   ```batch
   net start postgresql-x64-15
   ```
3. Vérifier que la base existe:
   ```batch
   psql -U postgres -l
   ```
4. Si la base n'existe pas, lancer:
   ```batch
   init-postgres.bat
   ```

---

## ✅ Checklist de Démarrage

### Avant de lancer les services:

- [ ] Java JDK 17 installé
- [ ] Maven fonctionnel (ou mvnw.cmd présent)
- [ ] PostgreSQL installé (optionnel mais recommandé)
- [ ] Base de données `calculatrice_db` créée (si PostgreSQL installé)
- [ ] Aucun service ne tourne déjà sur les ports 8080-8085 et 8761

### Après avoir lancé les services:

- [ ] 7 fenêtres CMD sont ouvertes
- [ ] Eureka Dashboard accessible (http://localhost:8761)
- [ ] 6 services enregistrés dans Eureka (visible après 1-2 minutes)
- [ ] Gateway répond (http://localhost:8080/actuator/health)

---

## 🎯 Ordre de Démarrage Correct

**TRÈS IMPORTANT:** Les services doivent démarrer dans cet ordre:

1. **Eureka Server** (Port 8761) - Attendre 15-20 secondes
2. **API Gateway** (Port 8080) - Attendre 5-10 secondes
3. **Microservices** (Ports 8081-8085) - En parallèle

Le script `START_MICROSERVICES.bat` (maintenant corrigé) respecte cet ordre automatiquement.

---

## 📞 Commandes Utiles

```batch
REM Démarrer tous les services
START_MICROSERVICES.bat

REM OU avec vérification PostgreSQL
start-all.bat

REM Arrêter tous les services
stop-all.bat

REM Initialiser PostgreSQL
init-postgres.bat

REM Vérifier l'état des services
REM (À exécuter dans un nouveau terminal)
curl http://localhost:8761
curl http://localhost:8080/actuator/health
curl http://localhost:8081/actuator/health
```

---

## 🌐 URLs des Services

| Service | URL | Description |
|---------|-----|-------------|
| Eureka Dashboard | http://localhost:8761 | Tableau de bord de découverte |
| API Gateway | http://localhost:8080 | Point d'entrée de l'API |
| Addition | http://localhost:8081 | Service d'addition |
| Subtraction | http://localhost:8082 | Service de soustraction |
| Multiplication | http://localhost:8083 | Service de multiplication |
| Division | http://localhost:8084 | Service de division |
| Modulo | http://localhost:8085 | Service de modulo |

---

## 📖 Documentation Complète

Pour plus de détails, consultez:
- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Guide complet de déploiement
- [README_DEPLOYMENT.md](README_DEPLOYMENT.md) - Guide de démarrage rapide

---

**Dernière mise à jour:** Décembre 2025

