# Testing Guide - Calculatrice Application

## Manual Testing Guide

### Pre-Test Requirements
- [ ] Backend running on port 8080
- [ ] Frontend running on port 4200
- [ ] Browser developer tools open (F12)
- [ ] No errors in console

---

## Test Case 1: Basic Addition

**Steps:**
1. Open http://localhost:4200
2. Click `5`
3. Click `+`
4. Click `3`
5. Click `=`

**Expected Result:**
- Display shows: `8`
- No error messages
- HTTP POST request to `/api/calculatrice/add` with `{a:5, b:3}`

**Pass/Fail:** ✅ / ❌

---

## Test Case 2: Basic Subtraction

**Steps:**
1. Click `1`, `0` (display shows 10)
2. Click `-`
3. Click `4`
4. Click `=`

**Expected Result:**
- Display shows: `6`
- No error messages

**Pass/Fail:** ✅ / ❌

---

## Test Case 3: Multiplication

**Steps:**
1. Click `6`
2. Click `*`
3. Click `7`
4. Click `=`

**Expected Result:**
- Display shows: `42`
- No error messages

**Pass/Fail:** ✅ / ❌

---

## Test Case 4: Division

**Steps:**
1. Click `2`, `0` (display shows 20)
2. Click `/`
3. Click `4`
4. Click `=`

**Expected Result:**
- Display shows: `5`
- No error messages

**Pass/Fail:** ✅ / ❌

---

## Test Case 5: Division by Zero Error

**Steps:**
1. Click `1`, `0` (display shows 10)
2. Click `/`
3. Click `0`
4. Click `=`

**Expected Result:**
- Display shows: Error message
- Error text: "Division by zero is not allowed"
- Red/pink error section displays

**Pass/Fail:** ✅ / ❌

---

## Test Case 6: Square Root Operation

**Steps:**
1. Click `1`, `6` (display shows 16)
2. Click `√`

**Expected Result:**
- Display shows: `4`
- Backend API call made to `/api/calculatrice/sqrt`
- Response: `{result: 4.0}`

**Pass/Fail:** ✅ / ❌

---

## Test Case 7: Negative Square Root Error

**Steps:**
1. Click `-`, `4` (display shows -4)
2. Click `√`

**Expected Result:**
- Display shows: Error message
- Error text: "Cannot calculate square root of negative number"

**Pass/Fail:** ✅ / ❌

---

## Test Case 8: Power Operation

**Steps:**
1. Click `2`
2. Click `^`
3. Click `3`
4. Click `=`

**Expected Result:**
- Display shows: `8` (2^3 = 8)
- Backend API call made to `/api/calculatrice/power`

**Pass/Fail:** ✅ / ❌

---

## Test Case 9: Factorial Operation

**Steps:**
1. Click `5`
2. Click `!`

**Expected Result:**
- Display shows: `120` (5! = 120)
- Backend API call made to `/api/calculatrice/factorial`

**Pass/Fail:** ✅ / ❌

---

## Test Case 10: Invalid Factorial (Negative)

**Steps:**
1. Click `-`, `5` (display shows -5)
2. Click `!`

**Expected Result:**
- Display shows: Error message
- Error text: "Factorial is only defined for non-negative integers"

**Pass/Fail:** ✅ / ❌

---

## Test Case 11: Clear Button

**Steps:**
1. Click `5`, `+`, `3`
2. Click `C`

**Expected Result:**
- Display shows: `0`
- All internal state reset
- Ready for new calculation

**Pass/Fail:** ✅ / ❌

---

## Test Case 12: Backspace Button

**Steps:**
1. Click `1`, `2`, `3` (display shows 123)
2. Click `←`
3. Click `←`

**Expected Result:**
- Display shows: `1` (removed 2 digits)
- Each click removes one digit from right

**Pass/Fail:** ✅ / ❌

---

## Test Case 13: Toggle Negative Button

**Steps:**
1. Click `5`
2. Click `≈`
3. Click `≈`

**Expected Result:**
- First click: Display shows `-5`
- Second click: Display shows `5`
- Toggles negative sign

**Pass/Fail:** ✅ / ❌

---

## Test Case 14: Decimal Numbers

**Steps:**
1. Click `3`
2. Click `.`
3. Click `5` (display shows 3.5)
4. Click `+`
5. Click `2`
6. Click `=`

**Expected Result:**
- Display shows: `5.5`
- Decimal operations work correctly

**Pass/Fail:** ✅ / ❌

---

## Test Case 15: Multiple Operations in Sequence

**Steps:**
1. Click `1`, `0` (10)
2. Click `+`
3. Click `5` (5)
4. Click `*` (should calculate 10+5=15 first)
5. Click `2`
6. Click `=`

**Expected Result:**
- Display shows: `30` (15 × 2 = 30)
- Operations execute in sequence correctly

**Pass/Fail:** ✅ / ❌

---

## Test Case 16: Percentage Operation

**Steps:**
1. Click `5`, `0` (50)
2. Click `%`
3. Click `2`, `0` (20)
4. Click `=`

**Expected Result:**
- Display shows: `10` (20% of 50)
- Backend API call made to `/api/calculatrice/percentage`

**Pass/Fail:** ✅ / ❌

---

## Test Case 17: Modulo Operation

**Steps:**
1. Click `1`, `7` (17)
2. Click `%` (in bottom row - modulo)
3. Click `5`
4. Click `=`

**Expected Result:**
- Display shows: `2` (17 mod 5 = 2)
- Remainder operation works

**Pass/Fail:** ✅ / ❌

---

## Test Case 18: Double Decimal Prevention

**Steps:**
1. Click `1`, `.`, `.` (try clicking . twice)

**Expected Result:**
- Only one decimal point appears in display
- Second click is ignored
- Display shows: `1.`

**Pass/Fail:** ✅ / ❌

---

## Test Case 19: Backend Health Check

**Steps (Using curl or Postman):**
```bash
curl http://localhost:8080/api/calculatrice/health
```

**Expected Result:**
- HTTP Status: 200 OK
- Response: "Calculator API is running!"

**Pass/Fail:** ✅ / ❌

---

## Test Case 20: API Connectivity

**Steps:**
1. Open browser Developer Tools (F12)
2. Go to Network tab
3. Clear history
4. Perform a calculation: `5 + 3 =`
5. Look for POST request in Network tab

**Expected Result:**
- Request URL: `http://localhost:8080/api/calculatrice/add`
- Status: 200 (OK)
- Request Body: `{"a":5,"b":3}`
- Response: `{"result":8.0,"error":null}`

**Pass/Fail:** ✅ / ❌

---

## Test Case 21: CORS Headers

**Steps:**
1. Open browser Developer Tools (F12)
2. Network tab
3. Click on the POST request made during calculation
4. Check "Response Headers"

**Expected Headers:**
```
Access-Control-Allow-Origin: http://localhost:4200
Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
Access-Control-Allow-Headers: *
```

**Pass/Fail:** ✅ / ❌

---

## Test Case 22: Responsive Design - Mobile

**Steps:**
1. Open DevTools (F12)
2. Toggle device toolbar (Ctrl+Shift+M)
3. Select iPhone/Mobile device
4. Test calculator operations

**Expected Result:**
- UI scales properly on mobile
- Buttons are still clickable
- No horizontal scrolling required
- Display is readable

**Pass/Fail:** ✅ / ❌

---

## Test Case 23: Responsive Design - Tablet

**Steps:**
1. Open DevTools (F12)
2. Toggle device toolbar
3. Select iPad/Tablet device
4. Test calculator operations

**Expected Result:**
- UI scales properly on tablet
- Layout is responsive
- All buttons visible
- Touch-friendly button sizes

**Pass/Fail:** ✅ / ❌

---

## Test Case 24: Zero Division by Zero

**Steps:**
1. Click `0`
2. Click `/`
3. Click `0`
4. Click `=`

**Expected Result:**
- Display shows: Error message
- Error text: "Division by zero is not allowed"
- Handled gracefully

**Pass/Fail:** ✅ / ❌

---

## Performance Tests

### Test: Response Time
```
Measurement: Time from clicking = to result display
Expected: < 200ms
Actual: ___ ms
Pass/Fail: ✅ / ❌
```

### Test: API Response Time
```
Measurement: Backend processing time (check in Network tab)
Expected: < 100ms
Actual: ___ ms
Pass/Fail: ✅ / ❌
```

### Test: UI Render Time
```
Measurement: Time for display to update
Expected: < 16ms (60 FPS)
Actual: ___ ms
Pass/Fail: ✅ / ❌
```

---

## Browser Console Tests

**Steps:**
1. Open F12 (Developer Tools)
2. Go to Console tab
3. Perform calculations
4. Check for errors/warnings

**Expected Result:**
- No red error messages
- No warning messages
- Clean console output
- HTTP requests logged (if configured)

**Pass/Fail:** ✅ / ❌

---

## Stress Tests

### Test: Large Numbers
**Steps:**
1. Enter very large number (e.g., 999999999)
2. Perform calculations

**Expected Result:**
- Calculations work correctly
- No overflow errors
- Display shows result

**Pass/Fail:** ✅ / ❌

### Test: Small Decimals
**Steps:**
1. Click `0`, `.`, `0`, `0`, `1` (0.001)
2. Click `*`
3. Click `2`
4. Click `=`

**Expected Result:**
- Display shows: `0.002`
- Decimal precision maintained

**Pass/Fail:** ✅ / ❌

### Test: Many Operations
**Steps:**
1. Perform 10+ sequential operations
2. Clear between operations
3. Repeat 5 times

**Expected Result:**
- No memory leaks
- No performance degradation
- All calculations correct

**Pass/Fail:** ✅ / ❌

---

## Test Summary Report

| Test Case | Description | Status |
|-----------|-------------|--------|
| 1 | Basic Addition | ✅ / ❌ |
| 2 | Basic Subtraction | ✅ / ❌ |
| 3 | Multiplication | ✅ / ❌ |
| 4 | Division | ✅ / ❌ |
| 5 | Division by Zero | ✅ / ❌ |
| 6 | Square Root | ✅ / ❌ |
| 7 | Negative Square Root | ✅ / ❌ |
| 8 | Power Operation | ✅ / ❌ |
| 9 | Factorial | ✅ / ❌ |
| 10 | Invalid Factorial | ✅ / ❌ |
| 11 | Clear Button | ✅ / ❌ |
| 12 | Backspace Button | ✅ / ❌ |
| 13 | Toggle Negative | ✅ / ❌ |
| 14 | Decimal Numbers | ✅ / ❌ |
| 15 | Sequence Operations | ✅ / ❌ |
| 16 | Percentage | ✅ / ❌ |
| 17 | Modulo | ✅ / ❌ |
| 18 | Double Decimal | ✅ / ❌ |
| 19 | Health Check | ✅ / ❌ |
| 20 | API Connectivity | ✅ / ❌ |
| 21 | CORS Headers | ✅ / ❌ |
| 22 | Mobile Responsive | ✅ / ❌ |
| 23 | Tablet Responsive | ✅ / ❌ |
| 24 | Zero/Zero Division | ✅ / ❌ |

---

## Overall Test Result

**Total Tests:** 24
**Passed:** ___ / 24
**Failed:** ___ / 24
**Pass Rate:** ___% 

**Status:** ✅ PASS / ❌ FAIL

---

## Notes & Observations

```
[Space for test notes, observations, and issues found]


```

---

## Sign-Off

**Tested By:** _______________
**Date:** _______________
**Time Spent:** _______________
**Issues Found:** _______________

---

**Testing Complete!** 🎉
