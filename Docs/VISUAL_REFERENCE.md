# Visual Reference Guide - Calculatrice

## Calculator UI Layout

```
╔════════════════════════════════════╗
║      CALCULATRICE - Display        ║
║                               0.00 ║
╚════════════════════════════════════╝

╔═══════════╦═══════════╦═══════════╦═══════════╗
║     7     ║     8     ║     9     ║     /     ║
╠═══════════╬═══════════╬═══════════╬═══════════╣
║     4     ║     5     ║     6     ║     *     ║
╠═══════════╬═══════════╬═══════════╬═══════════╣
║     1     ║     2     ║     3     ║     -     ║
╠═══════════╬═══════════╬═══════════╬═══════════╣
║     0     ║     .     ║     =     ║     +     ║
╠═══════════╬═══════════╬═══════════╬═══════════╣
║     √     ║     ^     ║     %     ║     !     ║
╠═══════════╬═══════════╬═══════════╬═══════════╣
║     C     ║     ←     ║   C/CE    ║     ≈     ║
╚═══════════╩═══════════╩═══════════╩═══════════╝

Legend:
  √  = Square Root      !  = Factorial
  ^  = Power            %  = Percentage
  ← = Backspace         ≈  = Toggle Negative
  C  = Clear           /,*,-,+ = Operations
```

## Color Scheme

### Button Colors
```
┌─ NUMERIC BUTTONS ─────┐
│  Background: #f9f9f9  │
│  Text: #333           │
│  Hover: #efefef       │
└───────────────────────┘

┌─ OPERATION BUTTONS ───┐
│  Background: Gradient │
│  (667eea → 764ba2)    │
│  Text: White          │
│  Font Weight: Bold    │
└───────────────────────┘

┌─ EQUALS BUTTON ───────┐
│  Background: Gradient │
│  (00d084 → 00b369)    │
│  Text: White          │
│  Font Weight: Bold    │
└───────────────────────┘

┌─ SPECIAL BUTTONS ─────┐
│  Background: Gradient │
│  (ff6b6b → ee5a52)    │
│  Text: White          │
│  Font Weight: Bold    │
└───────────────────────┘

┌─ DISPLAY AREA ────────┐
│  Background: Gradient │
│  (667eea → 764ba2)    │
│  Text: White          │
│  Font Size: 2.5rem    │
└───────────────────────┘
```

## Operation Examples

### Example 1: Simple Addition
```
User Action          Display       Internal State
─────────────────────────────────────────────────
Click [5]       →    5             firstOperand: null
Click [+]       →    5             firstOperand: 5, operation: '+'
Click [3]       →    3             waitingForSecondOperand: true
Click [=]       →    8             result = 5 + 3
```

### Example 2: Complex Expression
```
User Action          Display       Internal State
─────────────────────────────────────────────────
Click [2]       →    2
Click [^]       →    2             firstOperand: 2, operation: '^'
Click [3]       →    3
Click [×2]      →    8             result = 2^3 = 8
Click [+]       →    8             firstOperand: 8, operation: '+'
Click [4]       →    4
Click [=]       →    12            result = 8 + 4 = 12
```

### Example 3: Square Root
```
User Action          Display       Internal State
─────────────────────────────────────────────────
Click [1]       →    1
Click [6]       →    16
Click [√]       →    4             Backend API call: sqrt(16)
                                    Response: {result: 4}
```

## API Request/Response Examples

### Addition Request
```http
POST /api/calculatrice/add HTTP/1.1
Host: localhost:8080
Content-Type: application/json

{
  "a": 10,
  "b": 5
}
```

### Addition Response (Success)
```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "result": 15.0,
  "error": null
}
```

### Division by Zero Response (Error)
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "result": null,
  "error": "Division by zero is not allowed"
}
```

## File Structure Visual

```
📦 Project SI
 ├── 📁 calculatrice (Spring Boot Backend)
 │   ├── 📁 src/main/java/com/example/calculatrice
 │   │   ├── 📄 CalculatriceApplication.java
 │   │   ├── 📁 controller
 │   │   │   └── 📄 CalculatriceController.java
 │   │   ├── 📁 service
 │   │   │   └── 📄 CalculatriceService.java
 │   │   └── 📁 dto
 │   │       ├── 📄 CalculationRequest.java
 │   │       └── 📄 CalculationResponse.java
 │   ├── 📁 src/main/resources
 │   │   └── 📄 application.properties
 │   └── 📄 pom.xml
 │
 ├── 📁 Calculatrice_Frond_End (Angular Frontend)
 │   ├── 📁 src/app
 │   │   ├── 📁 components
 │   │   │   ├── 📄 calculator.component.ts
 │   │   │   ├── 📄 calculator.component.html
 │   │   │   └── 📄 calculator.component.scss
 │   │   ├── 📁 services
 │   │   │   └── 📄 calculatrice.service.ts
 │   │   ├── 📄 app.ts
 │   │   ├── 📄 app.config.ts
 │   │   ├── 📄 app.routes.ts
 │   │   ├── 📄 app.html
 │   │   └── 📄 app.scss
 │   ├── 📄 package.json
 │   └── 📄 angular.json
 │
 ├── 📄 README.md (Full Documentation)
 ├── 📄 QUICK_START.md (Quick Setup)
 ├── 📄 ARCHITECTURE.md (System Design)
 └── 📄 IMPLEMENTATION_SUMMARY.md (This Project)
```

## Development Workflow

```
┌─────────────────────────────────────────────────────────┐
│                  START BOTH SERVICES                     │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Terminal 1:                    Terminal 2:            │
│  ┌────────────────────┐        ┌─────────────────────┐ │
│  │ cd calculatrice    │        │ cd Calculatrice...  │ │
│  │ mvn spring-boot:run│        │ npm start           │ │
│  │                    │        │                     │ │
│  │ ⚙️ Port: 8080      │        │ ⚙️ Port: 4200       │ │
│  │ ✅ Running...      │        │ ✅ Running...       │ │
│  └────────────────────┘        └─────────────────────┘ │
│                                                          │
│  Open Browser: http://localhost:4200                    │
│                       ↓                                  │
│  See Calculator UI with all buttons ready for input     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Component Interaction Diagram

```
┌──────────────────────────────────┐
│   User Browser (4200)            │
├──────────────────────────────────┤
│                                  │
│  ┌─ Calculator Component ──────┐ │
│  │                             │ │
│  │  1. Display (Signals)      │ │
│  │  2. Buttons (Event Loop)   │ │
│  │  3. User Input Handler     │ │
│  │                             │ │
│  │  handleButtonClick(btn)    │ │
│  │  │                         │ │
│  │  ├─ If Number/Operator    │ │
│  │  │  └─ Update State      │ │
│  │  │                         │ │
│  │  └─ If Special (√, ^, !)   │ │
│  │     └─ Call Service       │ │
│  └─────────────┬──────────────┘ │
│                │                 │
│  ┌────────────▼──────────────┐  │
│  │ Calculatrice Service      │  │
│  │                           │  │
│  │ HttpClient.post(...)      │  │
│  └────────────┬──────────────┘  │
│               │                  │
└───────────────┼──────────────────┘
                │
                │ HTTP POST
                │ (CORS Enabled)
                │
┌───────────────▼──────────────────┐
│ Spring Boot Backend (8080)        │
├───────────────────────────────────┤
│                                   │
│  ┌─ CalculatriceController ────┐ │
│  │ @RestController             │ │
│  │ @RequestMapping("/api/...")│ │
│  │                             │ │
│  │ @PostMapping("/add")       │ │
│  │ public add(...) { }        │ │
│  └────────┬────────────────────┘ │
│           │                       │
│  ┌────────▼──────────────────┐  │
│  │ CalculatriceService       │  │
│  │                           │  │
│  │ add(a, b) -> a + b       │  │
│  │ sqrt(a) -> Math.sqrt(a)  │  │
│  │ etc.                      │  │
│  └────────┬──────────────────┘  │
│           │                      │
│  ┌────────▼──────────────────┐  │
│  │ CalculationResponse       │  │
│  │ { result: X, error: null }│  │
│  └────────┬──────────────────┘  │
│           │                      │
└───────────┼──────────────────────┘
            │
            │ HTTP 200 OK
            │ (JSON Response)
            │
┌───────────▼──────────────────────┐
│ Angular Frontend                  │
│                                   │
│ Receive Response → Update Display │
└───────────────────────────────────┘
```

## Error Handling Flow

```
┌────────────────────────────────────┐
│     User Input: 10 / 0             │
├────────────────────────────────────┤
│              ↓                      │
│  Frontend validates locally        │
│              ↓                      │
│  Sends to Backend                  │
│              ↓                      │
│  Backend receives request          │
│              ↓                      │
│  ❌ Validation fails               │
│  (division by zero check)          │
│              ↓                      │
│  Service throws exception          │
│              ↓                      │
│  Controller catches exception      │
│              ↓                      │
│  Response: {                       │
│    result: null,                   │
│    error: "Division by zero..."    │
│  }                                 │
│              ↓                      │
│  Frontend receives error           │
│              ↓                      │
│  Display error in UI               │
│              ↓                      │
│  User sees: "Division by zero..."  │
└────────────────────────────────────┘
```

## Performance Metrics

```
Operation                    Expected Time    Status
─────────────────────────────────────────────────────
Basic Math (+, -, *, /)      < 50ms           ✅ Fast
Power Operation              < 100ms          ✅ Fast
Square Root                  < 100ms          ✅ Fast
Factorial (small)            < 50ms           ✅ Fast
API Round Trip               < 200ms          ✅ Acceptable
UI Render                    < 16ms           ✅ Smooth (60 FPS)
```

## Browser Compatibility

```
Browser              Supported    Version
─────────────────────────────────────────
Chrome/Chromium      ✅          Latest
Firefox              ✅          Latest
Safari               ✅          Latest
Edge                 ✅          Latest
Mobile Safari        ✅          Latest
Chrome Mobile        ✅          Latest
```

---

**This visual reference guide helps understand the calculator's UI, flow, and architecture at a glance!**
