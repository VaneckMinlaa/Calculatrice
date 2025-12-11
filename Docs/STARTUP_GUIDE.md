# 🚀 Running the Calculatrice Application - Step by Step

## ✅ Your System Info
- **Java Version:** Java 25.0.1 LTS ✅ (Compatible!)
- **Maven:** Not globally installed, but project has Maven Wrapper ✅
- **OS:** Windows
- **Shell:** cmd.exe

---

## 🎯 TWO WAYS TO RUN THE APPLICATION

### METHOD 1: Using Maven Wrapper (RECOMMENDED) ✅
The Maven Wrapper is already in your project - no installation needed!

### METHOD 2: Install Maven Globally
Install Maven and add to PATH (optional)

---

## 📋 STEP-BY-STEP GUIDE

### STEP 1: Open Two Command Prompts
1. Open first CMD window
2. Open second CMD window

### STEP 2: Start Backend (Terminal 1)

**Copy and paste this command:**
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice" && mvnw.cmd spring-boot:run
```

**First Run:** Maven Wrapper will download Maven automatically (about 50-100MB, takes 2-5 minutes)

**What to expect:**
- Downloads Maven (first time only)
- Builds the project
- Starts Spring Boot
- **SUCCESS:** You should see:
```
Tomcat started on port(s): 8080
Started CalculatriceApplication in X.XXX seconds
```

### STEP 3: Start Frontend (Terminal 2)

**First, install npm dependencies (one-time):**
```cmd
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End"
npm install
```

**Then start the development server:**
```cmd
npm start
```

**What to expect:**
- Downloads npm packages
- Compiles TypeScript
- Starts Angular dev server
- **SUCCESS:** You should see:
```
Application bundle generation complete.
Build succeeded.
Serving Angular application...
```

### STEP 4: Open in Browser
1. Open your web browser
2. Navigate to: **http://localhost:4200**
3. You should see the calculator with all buttons

---

## ✅ VERIFICATION CHECKLIST

### Backend (Port 8080)
- [ ] Terminal 1 shows: "Tomcat started on port(s): 8080"
- [ ] Terminal 1 shows: "Started CalculatriceApplication"
- [ ] No red error messages

### Frontend (Port 4200)
- [ ] Terminal 2 shows: "Application bundle generation complete"
- [ ] Terminal 2 shows: "Serving Angular application"
- [ ] No red error messages

### Browser
- [ ] Opens without errors
- [ ] Shows calculator interface
- [ ] All 24 buttons visible
- [ ] Display panel visible

### Test Calculation
- [ ] Click `5`
- [ ] Click `+`
- [ ] Click `3`
- [ ] Click `=`
- [ ] **Result: Should show `8`**

---

## 📊 WHAT'S RUNNING WHERE

```
Terminal 1 (Backend)              Terminal 2 (Frontend)             Browser
──────────────────                ──────────────────                ──────
mvnw.cmd spring-boot:run          npm start                         http://localhost:4200
          ↓                                   ↓                              ↓
   Port 8080                            Port 4200                  Calculator UI
  Spring Boot                           Angular Dev Server
  REST API                              Hot Reload Enabled
```

---

## 🐛 TROUBLESHOOTING

### Problem: "mvnw.cmd: command not found"
**Solution:** Make sure you're in the correct directory:
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice"
mvnw.cmd spring-boot:run
```

### Problem: Maven Wrapper download fails
**Solution:** Check internet connection, then try again
```cmd
mvnw.cmd clean install
mvnw.cmd spring-boot:run
```

### Problem: "npm: command not found"
**Solution:** Node.js not installed
- Download and install from: https://nodejs.org/ (LTS version)
- Restart terminals after installation

### Problem: Port 8080 already in use
**Solution (Windows):**
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F
```

### Problem: Port 4200 already in use
**Solution (Windows):**
```cmd
netstat -ano | findstr :4200
taskkill /PID <PID_NUMBER> /F
```

### Problem: "Cannot connect to backend" in browser
**Solution:**
1. Check Terminal 1 - Backend must be running
2. Check for error messages
3. Wait 30 seconds for startup
4. Refresh browser (F5)

### Problem: npm dependencies conflict
**Solution:**
```cmd
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End"
rmdir /s node_modules
del package-lock.json
npm install
npm start
```

---

## 💡 QUICK REFERENCE COMMANDS

### Backend
```cmd
# Navigate to backend
cd "d:\Projets\Projet Java\Project SI\calculatrice"

# Run application
mvnw.cmd spring-boot:run

# Build only (no run)
mvnw.cmd clean install

# Clean build files
mvnw.cmd clean
```

### Frontend
```cmd
# Navigate to frontend
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End"

# Install dependencies (first time)
npm install

# Start development server
npm start

# Build for production
npm run build

# Run tests
npm test
```

---

## 📈 STARTUP TIMELINE

### First Run (with Maven Wrapper download)
```
Terminal 1 (Backend):
├─ 0-10 sec: Maven Wrapper downloads Maven
├─ 10-30 sec: Maven downloads dependencies
├─ 30-50 sec: Compiles Java code
└─ 50-60 sec: Spring Boot starts ✅ READY

Terminal 2 (Frontend):
├─ 0-20 sec: npm installs packages (if first run)
├─ 20-40 sec: Angular compiles
└─ 40-45 sec: Dev server starts ✅ READY

Browser:
└─ 45+ sec: Open http://localhost:4200 ✅ WORKING
```

### Subsequent Runs (faster)
```
Terminal 1: ~15 seconds to startup
Terminal 2: ~10 seconds to startup
Browser: Instant
```

---

## 🎯 FULL STARTUP EXAMPLE

### Copy & Paste These Commands

**Terminal 1:**
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice" && mvnw.cmd spring-boot:run
```

**Terminal 2:**
```cmd
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End" && npm install && npm start
```

**Browser:**
```
http://localhost:4200
```

---

## 🔄 STOPPING THE APPLICATION

### Stop Backend
Press: **Ctrl + C** in Terminal 1

### Stop Frontend
Press: **Ctrl + C** in Terminal 2

### Stop Both
- Terminal 1: Ctrl + C
- Terminal 2: Ctrl + C
- Close terminals

---

## 📝 USEFUL RESOURCES

| What | Where |
|------|-------|
| Quick Help | QUICK_START.md |
| Full Docs | README.md |
| Setup Guide | SETUP_COMPLETE.md |
| All Docs | INDEX.md |

---

## 🎉 YOU'RE ALL SET!

Everything is ready to run:
1. ✅ Java installed
2. ✅ Maven Wrapper available
3. ✅ Node.js requirement met
4. ✅ Project files created
5. ✅ Configuration done

**Next:** Follow the step-by-step guide above!

---

## 💬 FINAL NOTES

- **Maven Wrapper:** Downloads Maven automatically on first run
- **First Run:** Takes 2-5 minutes (Maven download)
- **Subsequent Runs:** 15-25 seconds startup
- **Hot Reload:** Frontend automatically reloads on code changes
- **Backend Restart:** Requires manual restart on Java code changes

---

**Ready to calculate? Let's go! 🧮**

Last Updated: November 2025
