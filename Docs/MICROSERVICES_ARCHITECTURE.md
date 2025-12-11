# Architecture Microservices pour Calculatrice

## Vue d'ensemble

Ce projet transforme le backend monolithique en une architecture microservices où chaque opération mathématique est un service indépendant.

## Structure des Microservices

### 1. API Gateway (Port 8080)
- Point d'entrée unique
- Routage des requêtes
- Gestion des erreurs globales
- Load balancing (optionnel)

### 2. Microservices Métier (Ports 8081-8086)

#### Addition Service (Port 8081)
```
POST /api/add
Body: {"a": 10, "b": 5}
Response: {"result": 15, "error": null}
```

#### Subtraction Service (Port 8082)
```
POST /api/subtract
Body: {"a": 10, "b": 5}
Response: {"result": 5, "error": null}
```

#### Multiplication Service (Port 8083)
```
POST /api/multiply
Body: {"a": 10, "b": 5}
Response: {"result": 50, "error": null}
```

#### Division Service (Port 8084)
```
POST /api/divide
Body: {"a": 10, "b": 5}
Response: {"result": 2, "error": null}
```

#### Modulo Service (Port 8085)
```
POST /api/modulo
Body: {"a": 10, "b": 3}
Response: {"result": 1, "error": null}
```

## Structure des Répertoires

```
calculatrice/
├── calculatrice-gateway/          # API Gateway
│   ├── src/
│   ├── pom.xml
│   └── Dockerfile
│
├── calculatrice-commons/          # Shared DTOs et utilitaires
│   ├── src/
│   └── pom.xml
│
├── microservices/
│   ├── addition-service/          # Service Addition
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   │
│   ├── subtraction-service/       # Service Soustraction
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   │
│   ├── multiplication-service/    # Service Multiplication
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   │
│   ├── division-service/          # Service Division
│   │   ├── src/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   │
│   └── modulo-service/            # Service Modulo
│       ├── src/
│       ├── pom.xml
│       └── Dockerfile
│
├── docker-compose.yml             # Orchestration des services
├── README.md                       # Documentation
└── ARCHITECTURE.md               # Détails architecture

```

## Avantages de cette Architecture

✅ **Indépendance**: Chaque service peut être déployé indépendamment
✅ **Scalabilité**: Chaque service peut être scalé indépendamment
✅ **Maintenabilité**: Code plus petit et focalisé
✅ **Resilience**: Panne d'un service ≠ panne globale
✅ **Technologie**: Chaque service peut utiliser sa propre stack
✅ **Équipes**: Chaque équipe peut gérer son service

## Technologie

- **Framework**: Spring Boot 3.5.7
- **Communication**: REST HTTP
- **Service Discovery**: Eureka (optionnel)
- **Load Balancing**: Zuul/Spring Cloud Gateway
- **Containerization**: Docker
- **Orchestration**: Docker Compose
- **Java Version**: 25 LTS

## Ports Utilisés

| Service | Port |
|---------|------|
| API Gateway | 8080 |
| Addition | 8081 |
| Subtraction | 8082 |
| Multiplication | 8083 |
| Division | 8084 |
| Modulo | 8085 |

## Commandes de Démarrage

### Avec Docker Compose
```bash
docker-compose up
```

### Manuellement
```bash
# Terminal 1: Gateway
cd calculatrice-gateway && mvnw.cmd spring-boot:run

# Terminal 2: Addition
cd microservices/addition-service && mvnw.cmd spring-boot:run

# Terminal 3: Subtraction
cd microservices/subtraction-service && mvnw.cmd spring-boot:run

# ... et ainsi de suite
```

## Testing

```bash
# Test via Gateway
curl -X POST http://localhost:8080/api/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'
```

## Prochaines Étapes

1. Créer les modules Maven parent
2. Créer le projet commons (DTOs partagés)
3. Créer l'API Gateway
4. Créer chaque microservice
5. Configurer Docker Compose
6. Tester l'intégration
