# Quick Start Guide - Calculatrice Application

## One-Click Setup

### Step 1: Start the Backend (Spring Boot)

**Windows CMD:**
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice"
mvn spring-boot:run
```

**Expected Output:**
```
...
Started CalculatriceApplication in X.XXX seconds (process running for X.XXX)
```

### Step 2: Start the Frontend (Angular)

**Open a new CMD/PowerShell and run:**
```cmd
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End"
npm start
```

**Expected Output:**
```
Application bundle generation complete.
Build succeeded.
Serving Angular application...
```

### Step 3: Open in Browser

Navigate to: **http://localhost:4200**

---

## Verification Checklist

- [ ] Backend running on `http://localhost:8080`
- [ ] Frontend running on `http://localhost:4200`
- [ ] No connection errors in calculator display
- [ ] Calculator buttons are responsive
- [ ] Test: `5 + 3 =` should display `8`

---

## Keyboard Commands

| Key | Action |
|-----|--------|
| `Ctrl + C` | Stop running service |
| `npm install` | Install frontend dependencies |
| `mvn clean install` | Rebuild backend |

---

## File Locations

| Component | File |
|-----------|------|
| Backend Main | `calculatrice/src/main/java/.../CalculatriceApplication.java` |
| Backend Service | `calculatrice/src/main/java/.../service/CalculatriceService.java` |
| Backend API | `calculatrice/src/main/java/.../controller/CalculatriceController.java` |
| Frontend Component | `Calculatrice_Frond_End/src/app/components/calculator.component.ts` |
| Frontend Service | `Calculatrice_Frond_End/src/app/services/calculatrice.service.ts` |

---

## Common Issues & Solutions

### Issue: "Cannot connect to backend"
**Solution:** Make sure the Spring Boot application is running on port 8080

### Issue: Port 8080 or 4200 already in use
**Solution:**
```cmd
netstat -ano | findstr :8080  (Windows)
taskkill /PID <PID> /F
```

### Issue: Node modules not installed
**Solution:**
```cmd
cd Calculatrice_Frond_End
npm install
```

---

## API Testing

You can test the backend API using curl or Postman:

```bash
curl -X POST http://localhost:8080/api/calculatrice/add \
  -H "Content-Type: application/json" \
  -d '{"a": 10, "b": 5}'
```

Response:
```json
{"result": 15, "error": null}
```

---

## Need Help?

1. Check the main README.md for detailed documentation
2. Ensure both applications are running
3. Check browser console for errors (F12)
4. Check terminal for backend/frontend errors
5. Verify Java 17+ and Node.js 18+ are installed

---

**Happy Calculating! 🧮**
