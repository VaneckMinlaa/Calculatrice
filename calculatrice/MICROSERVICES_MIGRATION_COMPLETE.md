# Microservices Architecture - Migration Complete ✅

## Architecture Overview

The calculator application has been successfully migrated to a **microservices architecture** where each mathematical operation runs as an independent service.

### Services Overview

| Service | Port | Operation | Route |
|---------|------|-----------|-------|
| **API Gateway** | 8080 | Central routing hub | `/api/*` |
| **Addition Service** | 8081 | a + b | `/api/add` |
| **Subtraction Service** | 8082 | a - b | `/api/subtract` |
| **Multiplication Service** | 8083 | a * b | `/api/multiply` |
| **Division Service** | 8084 | a ÷ b | `/api/divide` |
| **Modulo Service** | 8085 | a % b | `/api/modulo` |

---

## Project Structure

```
calculatrice/
├── calculatrice-commons/           # Shared DTOs and utilities
│   ├── pom.xml
│   └── src/main/java/.../commons/dto/
│       ├── CalculationRequest.java    # Request DTO (a, b)
│       └── CalculationResponse.java   # Response DTO (result, error)
│
├── calculatrice-gateway/           # Spring Cloud Gateway
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/main/java/.../gateway/
│       └── CalculatriceGatewayApplication.java
│   └── src/main/resources/
│       └── application.yml          # Routing rules
│
├── microservices/                  # Microservices parent module
│   ├── pom.xml
│   ├── addition-service/
│   ├── subtraction-service/
│   ├── multiplication-service/
│   ├── division-service/
│   └── modulo-service/
│       └── Each service contains:
│           ├── pom.xml
│           ├── Dockerfile
│           └── src/main/java/.../
│               ├── *ServiceApplication.java    # Spring Boot entry point
│               ├── service/*Service.java       # Business logic
│               ├── controller/*Controller.java # REST endpoints
│           └── src/main/resources/
│               └── application.yml
│
└── docker-compose.yml              # Docker orchestration
```

---

## How to Run the Microservices

### **Option 1: Using Maven Wrapper (Recommended)**

1. **Navigate to the project root:**
   ```cmd
   cd d:\Projets\Projet Java\Project SI\calculatrice
   ```

2. **Build all modules:**
   ```cmd
   mvnw clean package
   ```

3. **Start each service in separate command windows:**

   **Terminal 1 - API Gateway (Port 8080):**
   ```cmd
   cd calculatrice-gateway
   mvnw spring-boot:run
   ```

   **Terminal 2 - Addition Service (Port 8081):**
   ```cmd
   cd microservices\addition-service
   mvnw spring-boot:run
   ```

   **Terminal 3 - Subtraction Service (Port 8082):**
   ```cmd
   cd microservices\subtraction-service
   mvnw spring-boot:run
   ```

   **Terminal 4 - Multiplication Service (Port 8083):**
   ```cmd
   cd microservices\multiplication-service
   mvnw spring-boot:run
   ```

   **Terminal 5 - Division Service (Port 8084):**
   ```cmd
   cd microservices\division-service
   mvnw spring-boot:run
   ```

   **Terminal 6 - Modulo Service (Port 8085):**
   ```cmd
   cd microservices\modulo-service
   mvnw spring-boot:run
   ```

### **Option 2: Using Docker Compose**

1. **Navigate to the project root:**
   ```cmd
   cd d:\Projets\Projet Java\Project SI\calculatrice
   ```

2. **Build and run all services:**
   ```cmd
   docker-compose up --build
   ```

3. **Access the services:**
   - API Gateway: `http://localhost:8080`
   - Individual services available at their respective ports

---

## API Usage Examples

### **Addition (via Gateway)**
```bash
curl -X POST http://localhost:8080/api/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'
```
**Response:** `{"result": 15.0, "error": null, "operationType": "ADDITION"}`

### **Division with Error Handling**
```bash
curl -X POST http://localhost:8080/api/divide \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 0}'
```
**Response:** `{"result": null, "error": "Error: Cannot divide by zero", "operationType": "DIVISION"}`

### **Direct Service Access (Bypass Gateway)**
```bash
curl -X POST http://localhost:8081/api/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'
```

---

## Key Features

✅ **Fully Independent Microservices**
- Each operation runs in its own Spring Boot application
- Isolated databases and resources (for future scaling)
- Independent scaling capabilities

✅ **API Gateway Pattern**
- Single entry point for all requests
- Request routing to appropriate microservice
- CORS enabled for frontend compatibility

✅ **Shared Commons Module**
- Centralized DTOs (`CalculationRequest`, `CalculationResponse`)
- Ensures consistent API contracts across services
- Easy to extend with shared utilities

✅ **Error Handling**
- Division by zero protection in Division Service
- Modulo by zero protection in Modulo Service
- Graceful error responses with descriptive messages

✅ **Multi-Module Maven Structure**
- Clean parent-child POM hierarchy
- Easy to build all modules with single command
- Dependency management at parent level

✅ **Containerization Ready**
- Docker files prepared for each service
- Docker Compose orchestration file included
- Environment-based configuration support

---

## Configuration Files

### **Gateway Application Configuration** (`calculatrice-gateway/src/main/resources/application.yml`)
- Routes requests to microservices
- Handles CORS for frontend
- Eureka client registration (optional)

### **Microservice Configurations**
Each service has its own `application.yml`:
- Service name and port definition
- Eureka registration settings
- Service-specific configurations

---

## Development Tips

### **Adding a New Microservice**
1. Create new directory under `microservices/`
2. Create `pom.xml` with parent reference
3. Create main application class extending `SpringBootApplication`
4. Create service and controller classes
5. Configure `application.yml` with unique port
6. Add module reference to `microservices/pom.xml`

### **Debugging**
- Check individual service logs at their respective ports
- Use `mvnw clean compile` to validate syntax without building
- Review `application.yml` for configuration issues

### **Testing Individual Services**
- Each service can be tested independently
- Use the service's direct port (8081-8085)
- Gateway will handle orchestration in production

---

## Frontend Integration

The Angular frontend (`Calculatrice_Front_End/`) should be updated to call the API Gateway:

**Update service URLs from:**
```typescript
// Old monolithic approach
private apiUrl = 'http://localhost:8080/api/...';
```

**To (if needed, but Gateway will handle it):**
```typescript
// New microservices approach
private apiUrl = 'http://localhost:8080/api/...'; // Same URL, Gateway routes it!
```

The frontend doesn't need changes! The API Gateway acts as a transparent proxy.

---

## Troubleshooting

### **Port Already in Use**
```bash
# Find process using port 8080
netstat -ano | findstr :8080

# Kill process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

### **Build Failures**
```bash
# Clean build
mvnw clean install

# Skip tests to speed up
mvnw clean package -DskipTests
```

### **Service Not Starting**
- Check logs for errors
- Ensure port is not already in use
- Verify Java 25 is installed
- Check application.yml syntax

---

## Next Steps

1. ✅ **Microservices Created** - All 5 operation services ready
2. ✅ **API Gateway Ready** - Routing configured
3. ✅ **DTOs Shared** - Commons module setup
4. ⏳ **Optional: Add Eureka Server** - For service discovery
5. ⏳ **Optional: Add Circuit Breaker** - Using Resilience4j
6. ⏳ **Optional: Add Distributed Logging** - Using ELK Stack
7. ⏳ **Containerize & Deploy** - Using Docker/Docker Compose

---

## Important Notes

- **Eureka Configuration**: Currently disabled for simplicity. To enable, uncomment Eureka settings in application.yml files and add Eureka Server service.
- **Database**: Each microservice is ready for its own database (currently stateless).
- **Load Balancing**: Gateway handles initial routing. Kubernetes ready for production scaling.

---

## Support Files

- **MICROSERVICES_ARCHITECTURE.md** - Detailed architecture documentation
- **docker-compose.yml** - All services orchestration
- **Individual Dockerfiles** - Per-service containerization

---

**Migration Complete! Your calculator is now a true microservices architecture! 🚀**
