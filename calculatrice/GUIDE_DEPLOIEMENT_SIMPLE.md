# 🚀 Guide - Déploiement Simple GitLab CI/CD

## ✅ Pipeline Simplifié

Votre pipeline est maintenant **simple et direct** :

1. **Build** → Compile et crée les fichiers JAR
2. **Test** → Exécute les tests
3. **Deploy** → Déploie automatiquement

---

## 📋 Comment Utiliser

### 1. Push sur une branche (automatique)

```bash
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push origin votre-branche
```

**Résultat** : Le pipeline se déclenche automatiquement et exécute :
- ✅ **Build** : Compilation et création des JAR
- ✅ **Test** : Tests unitaires
- ⏸️ **Deploy** : Seulement sur `main`, `develop` ou tags

### 2. Déploiement Automatique

Le déploiement se fait **automatiquement** après les tests réussis sur :
- Branche `main`
- Branche `develop`
- Tags (ex: `v1.0.0`)

```bash
# Déploiement automatique sur develop
git checkout develop
git push origin develop

# Déploiement automatique sur main
git checkout main
git push origin main

# Déploiement automatique avec tag
git tag -a v1.0.0 -m "Version 1.0.0"
git push origin v1.0.0
```

---

## ⚙️ Configuration Requise

### Variables GitLab (Settings > CI/CD > Variables)

Configurer ces variables dans GitLab :

```
SSH_PRIVATE_KEY          → Votre clé privée SSH
DEPLOY_SERVER_HOST      → Adresse du serveur (ex: 192.168.1.100)
```

### GitLab Runner

Un runner doit être actif :
- Vérifier : **Settings > CI/CD > Runners**
- Au moins un runner avec un point vert 🟢

---

## 📊 Étapes du Pipeline

### Stage 1: Build
- Compile tous les modules
- Crée les fichiers JAR
- **Durée** : ~2-5 minutes

### Stage 2: Test
- Exécute les tests unitaires
- Utilise PostgreSQL en service
- **Durée** : ~3-10 minutes

### Stage 3: Deploy
- Déploie les JAR sur le serveur
- Utilise SSH et rsync
- **Durée** : ~1-2 minutes

---

## 🔍 Vérifier le Pipeline

1. **Aller dans CI/CD > Pipelines**
2. Voir le pipeline en cours
3. Cliquer pour voir les détails de chaque étape

### Statut des Jobs

- 🟢 **Succès** : Job terminé avec succès
- 🟡 **En cours** : Job en cours d'exécution
- 🔴 **Échec** : Job échoué (voir les logs)

---

## ❓ Problèmes Courants

### Le pipeline ne se déclenche pas

**Vérifications** :
- ✅ Fichier `.gitlab-ci.yml` présent dans le repository
- ✅ Runner actif dans GitLab
- ✅ Push effectué correctement

### Les tests échouent

**Solution** :
- Vérifier les logs du job `test`
- S'assurer que PostgreSQL est disponible
- Vérifier que le code compile

### Le déploiement échoue

**Vérifications** :
- ✅ Variables `SSH_PRIVATE_KEY` et `DEPLOY_SERVER_HOST` configurées
- ✅ Le serveur est accessible via SSH
- ✅ La clé SSH est correcte

---

## 🎯 Exemple Complet

```bash
# 1. Modifier le code
echo "Nouvelle fonctionnalité" >> README.md

# 2. Commit et push
git add .
git commit -m "feat: ajout fonctionnalité"
git push origin develop

# 3. Le pipeline se déclenche automatiquement
# - Build ✅
# - Test ✅
# - Deploy ✅ (automatique sur develop)
```

---

## 📝 Notes

- Le déploiement est **automatique** sur `main`, `develop` et les tags
- Les tests doivent passer pour que le déploiement se fasse
- Le pipeline utilise le script `scripts/deploy-dev.sh` s'il existe, sinon un déploiement simple

---

**Version** : 1.0.0  
**Dernière mise à jour** : Décembre 2025

