# Architecture & System Design

## System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    CALCULATOR APPLICATION                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌─────────────────────────┐      ┌──────────────────────┐  │
│  │    ANGULAR FRONTEND     │      │  SPRING BOOT BACKEND │  │
│  │  (Port: 4200)           │      │  (Port: 8080)        │  │
│  ├─────────────────────────┤      ├──────────────────────┤  │
│  │                         │      │                      │  │
│  │  ┌─────────────────┐    │      │  ┌────────────────┐  │  │
│  │  │  App Component  │    │      │  │  Controller    │  │  │
│  │  └────────┬────────┘    │      │  │  (REST API)    │  │  │
│  │           │             │      │  └────────┬───────┘  │  │
│  │  ┌────────▼────────┐    │      │           │           │  │
│  │  │    Calculator   │    │      │  ┌────────▼───────┐  │  │
│  │  │    Component    │    │      │  │    Service     │  │  │
│  │  └────────┬────────┘    │      │  │  (Business     │  │  │
│  │           │             │      │  │   Logic)       │  │  │
│  │  ┌────────▼────────┐    │  ┌──┼─▶│                │  │  │
│  │  │     Service     │    │  │  │  └────────────────┘  │  │
│  │  │  (API Client)   │◀───┼──┘  │                      │  │
│  │  └─────────────────┘    │     │  - Add              │  │
│  │                         │     │  - Subtract         │  │
│  │  UI Components:         │     │  - Multiply         │  │
│  │  - Display              │     │  - Divide           │  │
│  │  - Button Grid          │     │  - Power            │  │
│  │  - Styling              │     │  - Square Root      │  │
│  │  - Error Messages       │     │  - Factorial        │  │
│  └─────────────────────────┘     │  - Percentage       │  │
│                                   │  - Modulo           │  │
│                                   └──────────────────────┘  │
│                                                               │
│                         HTTP/REST (CORS)                      │
│                    (POST /api/calculatrice/*)                │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Component Structure

### Frontend (Angular)

```
Calculatrice_Frond_End/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── calculator.component.ts
│   │   │   ├── calculator.component.html
│   │   │   └── calculator.component.scss
│   │   ├── services/
│   │   │   └── calculatrice.service.ts
│   │   ├── app.ts (Main Component)
│   │   ├── app.config.ts (Configuration)
│   │   ├── app.routes.ts (Routing)
│   │   ├── app.html
│   │   └── app.scss
│   ├── index.html
│   ├── main.ts
│   └── styles.scss
├── package.json
└── angular.json
```

### Backend (Spring Boot)

```
calculatrice/
├── src/
│   ├── main/
│   │   ├── java/com/example/calculatrice/
│   │   │   ├── CalculatriceApplication.java (Main Class)
│   │   │   ├── controller/
│   │   │   │   └── CalculatriceController.java (REST Endpoints)
│   │   │   ├── service/
│   │   │   │   └── CalculatriceService.java (Business Logic)
│   │   │   └── dto/
│   │   │       ├── CalculationRequest.java
│   │   │       └── CalculationResponse.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/.../CalculatriceApplicationTests.java
├── pom.xml
└── .mvn/wrapper/
```

## Data Flow

### Single Operation Flow

```
1. User Input (UI)
   ↓
2. CalculatorComponent processes input
   ↓
3. Validate and prepare data
   ↓
4. CalculatriceService.methodName(a, b)
   ↓
5. HTTP POST to /api/calculatrice/operation
   ↓
6. CalculatriceController receives request
   ↓
7. Service.operation() computes result
   ↓
8. Returns CalculationResponse(result, error)
   ↓
9. Angular Service receives response
   ↓
10. Update component display
   ↓
11. User sees result on screen
```

## API Endpoints

### Overview

| HTTP Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/calculatrice/health` | Health check |
| POST | `/api/calculatrice/add` | Addition |
| POST | `/api/calculatrice/subtract` | Subtraction |
| POST | `/api/calculatrice/multiply` | Multiplication |
| POST | `/api/calculatrice/divide` | Division |

### Request/Response Format

**Request Body:**
```json
{
  "a": 10,
  "b": 5
}
```

**Response (Success):**
```json
{
  "result": 15.0,
  "error": null
}
```

**Response (Error):**
```json
{
  "result": null,
  "error": "Division by zero is not allowed"
}
```

## Error Handling

### Backend
- Division by zero validation
- Negative number validation for sqrt
- Invalid factorial input validation
- Exception handling with meaningful error messages

### Frontend
- Backend connection errors
- Invalid operation detection
- Display error messages to user
- Clear/reset on error

## Security Features

1. **CORS Configuration**
   - Only allows requests from `http://localhost:4200`
   - Configurable allowed origins

2. **Input Validation**
   - Server-side validation of all inputs
   - Type checking for numeric values

3. **Error Messages**
   - User-friendly error display
   - Prevents exposure of sensitive information

## Performance Considerations

1. **Frontend**
   - Signal-based state management (Angular 17+)
   - Efficient re-rendering
   - Lazy loading of components

2. **Backend**
   - Stateless REST API
   - Direct computation (no database queries)
   - Fast response times
   - Connection pooling for future scalability

## Technologies & Versions

### Frontend Stack
- **Angular**: 20.2.0
- **TypeScript**: 5.9.2
- **RxJS**: 7.8.0
- **SCSS**: CSS preprocessor

### Backend Stack
- **Spring Boot**: 3.5.7
- **Spring Framework**: Latest (from Spring Boot parent)
- **Java**: 17
- **Maven**: 3.8.1+

## Future Enhancements

1. **Database Integration**
   - Store calculation history
   - User preferences

2. **Authentication**
   - User login/registration
   - Secure endpoints

3. **Advanced Features**
   - Expression parser
   - Complex calculations
   - Graph plotting

4. **Testing**
   - Unit tests for services
   - Integration tests
   - E2E tests with Cypress

5. **Deployment**
   - Docker containerization
   - CI/CD pipeline
   - Cloud deployment (AWS, Azure, GCP)

## Scalability

### Current State
- Single instance backend
- Single instance frontend
- Stateless API calls

### For Production Scale
- Load balancer for backend instances
- CDN for frontend assets
- Redis for caching
- Database for persistence
- Monitoring and logging (ELK stack)

---

## Development Workflow

```
Code Changes → Build → Test → Deploy
     ↓          ↓       ↓        ↓
  Editor    Maven/npm  Jasmine  Browser
```

1. Make code changes
2. Build: `mvn clean install` (backend) / `npm build` (frontend)
3. Test: Unit tests, integration tests
4. Deploy: Run `mvn spring-boot:run` / `npm start`
5. Verify in browser

---

**Last Updated:** November 2025
**Version:** 1.0.0
