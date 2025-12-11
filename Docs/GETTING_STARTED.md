# ⚡ FASTEST WAY TO RUN YOUR CALCULATOR

## 🎯 3 Methods to Start (Easiest to Advanced)

---

## ✅ METHOD 1: Double-Click Batch Files (EASIEST)

### Option A: Start Everything at Once
1. Navigate to: `d:\Projets\Projet Java\Project SI`
2. Double-click: **`START_APP.bat`**
3. This will:
   - Open Terminal 1 (Backend on port 8080)
   - Open Terminal 2 (Frontend on port 4200)
   - Automatically start both servers
4. Open browser: **http://localhost:4200**

### Option B: Start Backend & Frontend Separately
**For Backend:**
1. Double-click: **`START_BACKEND.bat`**
2. Wait for: "Tomcat started on port(s): 8080"

**For Frontend (in another window):**
1. Double-click: **`START_FRONTEND.bat`**
2. Wait for: "Serving Angular application"

3. Open browser: **http://localhost:4200**

---

## ✅ METHOD 2: Copy-Paste Commands (QUICK)

### Terminal 1 - Backend
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice" && mvnw.cmd spring-boot:run
```

### Terminal 2 - Frontend
```cmd
cd "d:\Projets\Projet Java\Project SI\Calculatrice_Frond_End" && npm install && npm start
```

### Browser
```
http://localhost:4200
```

---

## ✅ METHOD 3: Using Full Maven (ADVANCED)

If you want to install Maven globally on your system:

### Step 1: Download Maven
1. Visit: https://maven.apache.org/download.cgi
2. Download: **apache-maven-3.9.x-bin.zip**
3. Extract to: `C:\maven` (or any folder)

### Step 2: Add to PATH
1. Open System Properties → Environment Variables
2. Create new variable: `MAVEN_HOME = C:\maven`
3. Edit PATH: Add `;%MAVEN_HOME%\bin` at the end
4. Click OK and restart terminals

### Step 3: Run with `mvn` command
```cmd
cd "d:\Projets\Projet Java\Project SI\calculatrice"
mvn spring-boot:run
```

---

## ⏱️ STARTUP TIMES

| Method | Backend | Frontend | Total |
|--------|---------|----------|-------|
| **First Run** | 1-2 min | 1-2 min | **2-4 min** |
| **After First Run** | 15-20 sec | 10-15 sec | **30-40 sec** |

---

## 🎯 RECOMMENDED STARTUP SEQUENCE

### Step 1: Start Backend (2-4 minutes first time)
```
Double-click: START_BACKEND.bat
or
Command: mvnw.cmd spring-boot:run
```
✅ Wait for: "Tomcat started on port(s): 8080"

### Step 2: Start Frontend (1-2 minutes first time)
```
Double-click: START_FRONTEND.bat
or
Command: npm install && npm start
```
✅ Wait for: "Serving Angular application"

### Step 3: Open Browser
```
Navigate to: http://localhost:4200
```
✅ Calculator should be visible!

### Step 4: Test It
```
Click: 5 + 3 =
Expected: 8
```

---

## 📋 QUICK REFERENCE

### Start Backend
| Method | Command |
|--------|---------|
| Batch File | Double-click `START_BACKEND.bat` |
| Command Line | `mvnw.cmd spring-boot:run` |
| With Maven | `mvn spring-boot:run` |

### Start Frontend
| Method | Command |
|--------|---------|
| Batch File | Double-click `START_FRONTEND.bat` |
| Command Line | `npm start` |
| Full | `npm install && npm start` |

### Stop Servers
| Method | Action |
|--------|--------|
| Keyboard | Press `Ctrl + C` in terminal |
| Close Window | Click X button on terminal |
| Task Manager | Find and end process |

---

## 🔍 VERIFICATION CHECKLIST

After startup, verify everything is working:

### Backend Running?
```
Check Terminal 1:
✅ "Tomcat started on port(s): 8080"
✅ "Started CalculatriceApplication"
✅ No red error messages
```

### Frontend Running?
```
Check Terminal 2:
✅ "Application bundle generation complete"
✅ "Serving Angular application"
✅ No red error messages
```

### Browser Working?
```
Go to: http://localhost:4200
✅ Calculator UI visible
✅ All 24 buttons present
✅ Display panel shows "0"
```

### Test Calculation
```
Steps: 5 + 3 =
Expected: 8
✅ Display shows: 8
✅ No error messages
```

---

## 🐛 QUICK FIXES

### If Backend Won't Start
```cmd
cd calculatrice
mvnw.cmd clean
mvnw.cmd spring-boot:run
```

### If Frontend Won't Start
```cmd
cd Calculatrice_Frond_End
rmdir /s node_modules
npm install
npm start
```

### If Port 8080 Busy
```cmd
netstat -ano | findstr :8080
taskkill /PID <NUMBER> /F
mvnw.cmd spring-boot:run
```

### If Port 4200 Busy
```cmd
netstat -ano | findstr :4200
taskkill /PID <NUMBER> /F
npm start
```

---

## 💡 TIPS & TRICKS

### Keep Both Running
- Use 2 separate terminal windows
- Leave them open in background
- Frontend auto-reloads on code changes
- Backend requires restart for Java changes

### Check Backend Health
```cmd
curl http://localhost:8080/api/calculatrice/health
```

### Test Calculation via Command
```cmd
curl -X POST http://localhost:8080/api/calculatrice/add ^
  -H "Content-Type: application/json" ^
  -d "{\"a\": 10, \"b\": 5}"
```

### View Backend Logs
Check the Terminal 1 where backend is running

### View Frontend Logs
Check the Terminal 2 where frontend is running

---

## 🚀 NEXT STEPS

### First Time
1. Choose Method 1 (Double-click batch file)
2. Let it start (be patient, first run takes 2-4 min)
3. Open http://localhost:4200
4. Test: 5 + 3 = 8

### Subsequent Runs
1. Double-click batch files (15-40 seconds total)
2. Open http://localhost:4200
3. Start calculating!

### Development
1. Edit frontend code in VS Code
2. Browser auto-reloads
3. See changes instantly!

---

## 📞 NEED HELP?

| Issue | Check |
|-------|-------|
| Can't find batch files | In: `d:\Projets\Projet Java\Project SI` |
| Double-click doesn't work | Right-click → Open with → Command Prompt |
| Backend won't start | Check Java version: `java -version` |
| Frontend won't start | Check Node.js: `node -v` and `npm -v` |
| Still stuck | Read: STARTUP_GUIDE.md or README.md |

---

## 🎉 YOU'RE READY!

Everything is set up and ready to run!

**Choose your method and start calculating! 🧮**

---

**Created:** November 2025
**Status:** ✅ Ready to Use
**Support:** See STARTUP_GUIDE.md or README.md
