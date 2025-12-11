# 🎉 CALCULATRICE PROJECT - COMPLETE SETUP GUIDE

## Project Overview
A full-stack calculator application featuring:
- **Backend**: Spring Boot REST API on port 8080
- **Frontend**: Angular responsive UI on port 4200
- **Communication**: HTTP/REST with CORS

---

## 📦 WHAT HAS BEEN CREATED

### Backend Components (calculatrice/)
✅ CalculatriceApplication.java - Main Spring Boot class with CORS config
✅ CalculatriceController.java - 10 REST API endpoints
✅ CalculatriceService.java - Business logic for calculations
✅ CalculationRequest.java - Request DTO
✅ CalculationResponse.java - Response DTO
✅ application.properties - Server configuration

### Frontend Components (Calculatrice_Frond_End/)
✅ calculator.component.ts - Main component logic
✅ calculator.component.html - UI template (6×4 button grid)
✅ calculator.component.scss - Modern gradient styling
✅ calculatrice.service.ts - API client service
✅ app.routes.ts - Routing configuration
✅ app.config.ts - AppConfig with HttpClient
✅ app.ts - Main app component
✅ app.html - App template
✅ app.scss - Global styles

### Documentation
✅ README.md - Complete documentation
✅ QUICK_START.md - Quick setup instructions
✅ ARCHITECTURE.md - System design & diagrams
✅ IMPLEMENTATION_SUMMARY.md - What was created
✅ VISUAL_REFERENCE.md - UI & flow diagrams

---

## 🚀 QUICK START (Copy & Paste)

### Terminal 1 - Start Backend
```bash
cd d:\Projets\Projet Java\Project SI\calculatrice
mvn spring-boot:run
```
**Expected Output:** "Tomcat started on port(s): 8080"

### Terminal 2 - Start Frontend
```bash
cd d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End
npm start
```
**Expected Output:** "Application bundle generation complete"

### Browser
Navigate to: **http://localhost:4200**

---

## 🧮 CALCULATOR OPERATIONS

| Button | Operation | Example |
|--------|-----------|---------|
| + | Add | 5 + 3 = 8 |
| - | Subtract | 10 - 4 = 6 |
| * | Multiply | 6 × 7 = 42 |
| / | Divide | 20 ÷ 4 = 5 |
| ^ | Power | 2 ^ 3 = 8 |
| √ | Square Root | √16 = 4 |
| % | Percentage | 20% of 50 = 10 |
| ! | Factorial | 5! = 120 |
| ≈ | Negate | 5 → -5 |
| ← | Backspace | Delete last digit |
| C | Clear | Reset all |

---

## 🔧 REQUIREMENTS CHECK

Run this in PowerShell to verify setup:

```powershell
# Check Java
java -version
# Should show Java 17 or higher

# Check Maven
mvn -v
# Should show Maven 3.8.1 or higher

# Check Node
node -v
# Should show Node 18 or higher

npm -v
# Should show npm 9 or higher
```

---

## 📋 SETUP CHECKLIST

- [ ] Java 17+ installed
- [ ] Maven 3.8.1+ installed
- [ ] Node.js 18+ installed
- [ ] npm installed with Node.js
- [ ] Run: `cd calculatrice && mvn clean install`
- [ ] Run: `cd Calculatrice_Frond_End && npm install`
- [ ] Terminal 1: `mvn spring-boot:run` (Backend)
- [ ] Terminal 2: `npm start` (Frontend)
- [ ] Browser: Visit http://localhost:4200
- [ ] Test: Click 5 + 3 = (should show 8)

---

## 🎯 FIRST RUN TEST

1. Open calculator in browser (http://localhost:4200)
2. Click sequence: [5] [+] [3] [=]
3. **Expected Result:** Display shows "8"
4. No error messages should appear
5. Check browser console (F12) - no red errors
6. Backend should show successful POST requests

---

## 📁 FILE LOCATIONS (For Reference)

| What | Where |
|------|-------|
| Backend Main | `calculatrice/src/main/java/.../CalculatriceApplication.java` |
| Backend API | `calculatrice/src/main/java/.../controller/CalculatriceController.java` |
| Backend Logic | `calculatrice/src/main/java/.../service/CalculatriceService.java` |
| Frontend Component | `Calculatrice_Frond_End/src/app/components/calculator.component.ts` |
| Frontend Service | `Calculatrice_Frond_End/src/app/services/calculatrice.service.ts` |
| Frontend Template | `Calculatrice_Frond_End/src/app/components/calculator.component.html` |

---

## 🐛 TROUBLESHOOTING

### Problem: "Cannot connect to backend"
**Solution:** 
1. Ensure Spring Boot is running on port 8080
2. Check terminal for error messages
3. Restart: `mvn spring-boot:run`

### Problem: Port 8080 already in use
**Solution (Windows):**
```powershell
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F
```

### Problem: Port 4200 already in use
**Solution (Windows):**
```powershell
netstat -ano | findstr :4200
taskkill /PID <PID_NUMBER> /F
```

### Problem: npm packages missing
**Solution:**
```bash
cd Calculatrice_Frond_End
rm -r node_modules package-lock.json
npm install
```

### Problem: Build errors
**Backend:**
```bash
cd calculatrice
mvn clean install -U
mvn spring-boot:run
```

**Frontend:**
```bash
cd Calculatrice_Frond_End
ng build --configuration development
npm start
```

---

## 📊 SYSTEM ARCHITECTURE

```
CLIENT SIDE              NETWORK              SERVER SIDE
───────────────────────────────────────────────────────────

Browser                                      Spring Boot
(4200)                                       (8080)
  │                                            │
  ├─ App Component                            ├─ Controller
  │                                            │
  ├─ Calculator Component                     ├─ Service
  │  (UI, State, Logic)                       │  (Math Operations)
  │                                            │
  └─ Calculatrice Service                     ├─ DTOs
     (HTTP Client)                            │  (Request/Response)
        │                                     │
        │── HTTP POST ──►                     │
        │  /api/calculatrice/add              │
        │  {"a": 10, "b": 5}                  │
        │                                     │
        │◄─── HTTP 200 ─────                  │
        │  {"result": 15, "error": null}      │
        │                                     │
     Updates Display                      Processes & Returns
```

---

## 💡 KEY FEATURES

✨ **Modern UI**
- Gradient backgrounds (purple theme)
- Responsive design (works on mobile)
- Smooth animations and transitions
- Color-coded buttons for easy use

✨ **Robust Backend**
- 10 calculation operations
- Input validation
- Error handling
- Health check endpoint
- CORS support

✨ **Clean Architecture**
- Service layer pattern
- DTO pattern for type safety
- Separation of concerns
- RESTful API design

---

## 🔗 USEFUL COMMANDS

```bash
# Backend
cd calculatrice
mvn clean                           # Clean build
mvn install                         # Install dependencies
mvn spring-boot:run                 # Run app
mvn test                            # Run tests

# Frontend
cd Calculatrice_Frond_End
npm install                         # Install dependencies
npm start                           # Run dev server
npm run build                       # Build for production
npm test                            # Run tests
ng serve --open                     # Open in browser
```

---

## 📞 API ENDPOINTS REFERENCE

### Health Check
```
GET http://localhost:8080/api/calculatrice/health
Response: "Calculator API is running!"
```

### Add
```
POST http://localhost:8080/api/calculatrice/add
Body: {"a": 10, "b": 5}
Response: {"result": 15.0, "error": null}
```

### Subtract
```
POST http://localhost:8080/api/calculatrice/subtract
Body: {"a": 10, "b": 3}
Response: {"result": 7.0, "error": null}
```

### Multiply
```
POST http://localhost:8080/api/calculatrice/multiply
Body: {"a": 6, "b": 7}
Response: {"result": 42.0, "error": null}
```

### Divide
```
POST http://localhost:8080/api/calculatrice/divide
Body: {"a": 20, "b": 4}
Response: {"result": 5.0, "error": null}
```

### Square Root
```
POST http://localhost:8080/api/calculatrice/sqrt
Body: {"a": 16}
Response: {"result": 4.0, "error": null}
```

---

## 🌐 TECHNOLOGY STACK

**Backend:**
- Spring Boot 3.5.7
- Java 17
- Maven 3.8.1+
- REST API architecture

**Frontend:**
- Angular 20.2.0
- TypeScript 5.9.2
- SCSS styling
- RxJS for async operations
- Angular Signals for state management

**Communication:**
- HTTP/REST
- CORS enabled
- JSON request/response

---

## 📈 NEXT STEPS (Optional Enhancements)

1. **Add History**
   - Store calculation history
   - Display in a sidebar

2. **Keyboard Support**
   - Type numbers directly
   - Use Enter for equals

3. **Dark Mode**
   - Add theme toggle
   - Save preference in localStorage

4. **Animations**
   - Button press animations
   - Smooth number transitions

5. **Testing**
   - Add unit tests
   - Integration tests
   - E2E tests

6. **Database**
   - Save calculation history
   - User profiles

7. **Advanced Features**
   - Expression parser
   - Graph plotting
   - Unit conversion

---

## ✅ VERIFICATION

### Backend Health Check
```bash
curl http://localhost:8080/api/calculatrice/health
# Should return: "Calculator API is running!"
```

### Frontend Accessibility
```
Open: http://localhost:4200
Should see: Calculator UI with 24 buttons
```

### Test Calculation
```
Input: 5 + 3
Output: 8
```

---

## 📚 DOCUMENTATION

| Document | Purpose | Location |
|----------|---------|----------|
| README.md | Full project documentation | Project root |
| QUICK_START.md | Quick setup instructions | Project root |
| ARCHITECTURE.md | System design details | Project root |
| IMPLEMENTATION_SUMMARY.md | What was created | Project root |
| VISUAL_REFERENCE.md | UI & flow diagrams | Project root |

---

## 🎓 LEARNING RESOURCES

### Spring Boot
- Official Docs: https://spring.io/projects/spring-boot
- Guide: https://spring.io/guides/gs/building-web/

### Angular
- Official Docs: https://angular.io
- Learning Path: https://angular.io/guide/what-is-angular

### TypeScript
- Docs: https://www.typescriptlang.org
- Handbook: https://www.typescriptlang.org/docs/

---

## 🎯 SUCCESS CRITERIA

✅ Backend starts without errors
✅ Frontend starts without errors
✅ Calculator UI displays correctly
✅ All buttons are clickable
✅ Basic math works (5 + 3 = 8)
✅ Advanced operations work (√16 = 4, 2^3 = 8)
✅ Error handling works (10/0 shows error)
✅ No console errors in browser
✅ No console errors in terminal

---

## 🏁 YOU'RE ALL SET! 🏁

Your full-stack calculator application is ready to use!

**To start:**
1. Open 2 terminals
2. Run backend in Terminal 1: `mvn spring-boot:run`
3. Run frontend in Terminal 2: `npm start`
4. Open browser to: `http://localhost:4200`
5. Start calculating! 🧮

---

**Need Help?** Check the documentation files (README.md, QUICK_START.md, ARCHITECTURE.md)

**Good luck with your project!** 🚀

---

*Project Status: ✅ COMPLETE*
*Last Updated: November 2025*
*Version: 1.0.0*
