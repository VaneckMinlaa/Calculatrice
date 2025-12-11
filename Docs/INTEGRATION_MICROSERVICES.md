# Intégration Frontend Angular avec Architecture Microservices

## Vue d'ensemble

Cette documentation explique comment le frontend Angular (`Calculatrice_Frond_End`) intègre avec l'architecture microservices du backend (`calculatrice`).

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    ANGULAR FRONTEND                          │
│                    (Port: 4200)                              │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  CalculatorComponent                                 │   │
│  │  - Gère l'interface utilisateur                      │   │
│  │  - Appelle CalculatriceService                       │   │
│  └────────────────────┬────────────────────────────────┘   │
│                       │                                      │
│  ┌────────────────────▼────────────────────────────────┐   │
│  │  CalculatriceService                                 │   │
│  │  - Service Angular (HttpClient)                      │   │
│  │  - URL de base: http://localhost:8080/api/calculatrice│  │
│  └────────────────────┬────────────────────────────────┘   │
└────────────────────────┼────────────────────────────────────┘
                         │ HTTP POST
                         │ /api/calculatrice/add
                         │ /api/calculatrice/subtract
                         │ /api/calculatrice/multiply
                         │ /api/calculatrice/divide
                         │ /api/calculatrice/modulo
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    API GATEWAY                               │
│                    (Port: 8080)                              │
│                    Spring Cloud Gateway                      │
│                                                              │
│  Routes:                                                     │
│  /api/calculatrice/add    → http://localhost:8081/api/add   │
│  /api/calculatrice/subtract → http://localhost:8082/api/subtract│
│  /api/calculatrice/multiply → http://localhost:8083/api/multiply│
│  /api/calculatrice/divide → http://localhost:8084/api/divide│
│  /api/calculatrice/modulo → http://localhost:8085/api/modulo│
└────────────────────┬────────────────────────────────────────┘
                     │
                     ├──────────────────────────────────────────┐
                     │                                          │
                     ▼                                          ▼
        ┌────────────────────┐              ┌────────────────────┐
        │  ADDITION SERVICE  │              │ SUBTRACTION SERVICE│
        │  Port: 8081        │              │ Port: 8082         │
        │  /api/add          │              │ /api/subtract      │
        └────────────────────┘              └────────────────────┘
                     │                                          │
                     ▼                                          ▼
        ┌────────────────────┐              ┌────────────────────┐
        │MULTIPLICATION SERV.│              │  DIVISION SERVICE  │
        │ Port: 8083         │              │ Port: 8084         │
        │ /api/multiply      │              │ /api/divide        │
        └────────────────────┘              └────────────────────┘
                     │
                     ▼
        ┌────────────────────┐
        │  MODULO SERVICE    │
        │ Port: 8085         │
        │ /api/modulo        │
        └────────────────────┘
```

## Flux de données

### Exemple: Addition de 10 + 5

1. **Frontend (CalculatorComponent)**
   - L'utilisateur saisit `10`, puis `+`, puis `5`, puis `=`
   - Le component appelle `this.calculatriceService.add(10, 5)`

2. **Service Angular (CalculatriceService)**
   - Effectue un POST vers `http://localhost:8080/api/calculatrice/add`
   - Body: `{ "a": 10, "b": 5 }`

3. **API Gateway (Port 8080)**
   - Reçoit la requête sur `/api/calculatrice/add`
   - Réécrit l'URL en `/api/add` (via RewritePath)
   - Route vers `http://localhost:8081/api/add`

4. **Addition Service (Port 8081)**
   - Reçoit la requête sur `/api/add`
   - Appelle `AdditionService.add(10, 5)`
   - Retourne `{ "result": 15.0, "error": null, "operationType": "ADDITION" }`

5. **Retour vers le Frontend**
   - La réponse remonte par le Gateway
   - Le component met à jour `display` avec `"15"`
   - L'utilisateur voit le résultat

## Configuration

### Frontend (Angular)

**Fichier**: `Calculatrice_Frond_End/src/app/services/calculatrice.service.ts`

```typescript
private apiUrl = 'http://localhost:8080/api/calculatrice';

add(a: number, b: number): Observable<any> {
  return this.http.post(`${this.apiUrl}/add`, { a, b });
}
```

**Fichier**: `Calculatrice_Frond_End/src/app/components/calculator.component.ts`

- Utilise `CalculatriceService` pour toutes les opérations
- Gère les états de chargement (`isLoading`)
- Affiche les erreurs du backend

### Backend - Gateway

**Fichier**: `calculatrice/calculatrice-gateway/src/main/resources/application.yml`

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: addition-service
          uri: http://localhost:8081
          predicates:
            - Path=/api/calculatrice/add
          filters:
            - RewritePath=/api/calculatrice/(?<segment>.*), /api/$\\{segment}
```

**Note importante**: Le Gateway utilise `RewritePath` pour transformer:
- `/api/calculatrice/add` → `/api/add`
- Cela permet au frontend d'appeler `/api/calculatrice/add` pendant que les microservices exposent `/api/add`

### Microservices

Chaque microservice expose son endpoint sous `/api/{operation}`:
- Addition: `/api/add`
- Subtraction: `/api/subtract`
- Multiplication: `/api/multiply`
- Division: `/api/divide`
- Modulo: `/api/modulo`

## Format des requêtes/réponses

### Requête (Frontend → Gateway → Microservice)

```json
POST /api/calculatrice/add
Content-Type: application/json

{
  "a": 10,
  "b": 5
}
```

### Réponse (Microservice → Gateway → Frontend)

**Succès**:
```json
{
  "result": 15.0,
  "error": null,
  "operationType": "ADDITION"
}
```

**Erreur**:
```json
{
  "result": null,
  "error": "Error: Division by zero is not allowed",
  "operationType": "DIVISION"
}
```

## Démarrage de l'application

### 1. Démarrer les microservices

Depuis le répertoire `calculatrice/`:

```bash
# Option 1: Utiliser le script batch
START_MICROSERVICES.bat

# Option 2: Démarrer manuellement chaque service
cd calculatrice-gateway && mvnw spring-boot:run
cd microservices/addition-service && mvnw spring-boot:run
cd microservices/subtraction-service && mvnw spring-boot:run
cd microservices/multiplication-service && mvnw spring-boot:run
cd microservices/division-service && mvnw spring-boot:run
cd microservices/modulo-service && mvnw spring-boot:run
```

### 2. Démarrer le frontend Angular

Depuis le répertoire `Calculatrice_Frond_End/`:

```bash
npm install  # Si nécessaire
npm start
```

Le frontend sera disponible sur `http://localhost:4200`

## Opérations supportées

| Opération | Frontend | Gateway Route | Microservice | Port |
|-----------|----------|---------------|--------------|------|
| Addition | `+` | `/api/calculatrice/add` | `/api/add` | 8081 |
| Soustraction | `-` | `/api/calculatrice/subtract` | `/api/subtract` | 8082 |
| Multiplication | `*` | `/api/calculatrice/multiply` | `/api/multiply` | 8083 |
| Division | `/` | `/api/calculatrice/divide` | `/api/divide` | 8084 |
| Modulo | `%` | `/api/calculatrice/modulo` | `/api/modulo` | 8085 |

## Gestion des erreurs

### Frontend

Le `CalculatorComponent` gère les erreurs de plusieurs façons:

1. **Erreurs réseau**: Affiche "Cannot connect to backend"
2. **Erreurs du backend**: Affiche le message d'erreur dans `response.error`
3. **Erreurs HTTP**: Extrait le message depuis `err.error.error` ou `err.error.message`

### Backend

Chaque microservice:
- Valide les entrées
- Gère les exceptions (division par zéro, etc.)
- Retourne un `CalculationResponse` avec `error` rempli en cas d'erreur

## CORS Configuration

Le Gateway est configuré pour accepter les requêtes depuis n'importe quelle origine:

```yaml
globalcors:
  corsConfigurations:
    '[/**]':
      allowedOrigins: "*"
      allowedMethods: "*"
      allowedHeaders: "*"
```

**Note**: En production, remplacez `*` par l'origine spécifique du frontend.

## Test de l'intégration

### Test manuel

1. Ouvrir `http://localhost:4200`
2. Tester chaque opération:
   - `5 + 3 = 8`
   - `10 - 4 = 6`
   - `6 * 7 = 42`
   - `20 / 4 = 5`
   - `10 % 3 = 1`

### Test avec curl

```bash
# Test via le Gateway
curl -X POST http://localhost:8080/api/calculatrice/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'

# Test direct d'un microservice
curl -X POST http://localhost:8081/api/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'
```

## Dépannage

### Le frontend ne peut pas se connecter au backend

1. Vérifier que le Gateway est démarré sur le port 8080
2. Vérifier que tous les microservices sont démarrés
3. Vérifier la console du navigateur pour les erreurs CORS
4. Vérifier que `apiUrl` dans `calculatrice.service.ts` pointe vers `http://localhost:8080`

### Les calculs ne fonctionnent pas

1. Vérifier les logs de chaque microservice
2. Vérifier que le Gateway route correctement (vérifier les logs du Gateway)
3. Tester directement un microservice avec curl
4. Vérifier la console du navigateur pour les erreurs

### Erreur "Cannot connect to backend"

- Vérifier que le Gateway est démarré
- Vérifier la configuration CORS
- Vérifier que le port 8080 n'est pas déjà utilisé

## Prochaines améliorations

- [ ] Ajouter des opérations avancées (power, sqrt, factorial) comme microservices
- [ ] Ajouter un service de découverte (Eureka) pour la résolution dynamique des services
- [ ] Ajouter la gestion d'historique des calculs
- [ ] Ajouter des tests d'intégration E2E
- [ ] Ajouter la gestion de cache dans le Gateway
- [ ] Ajouter un rate limiting dans le Gateway
- [ ] Ajouter la monitoring et logging centralisé

---

**Dernière mise à jour**: Novembre 2024
