# Calculatrice - Full Stack Application

A complete calculator application built with **Spring Boot** (backend) and **Angular** (frontend).

## Project Structure

```
Project SI/
├── calculatrice/                 # Spring Boot Backend
│   ├── src/
│   │   ├── main/java/.../       # Java source code
│   │   └── resources/           # Configuration files
│   └── pom.xml                  # Maven configuration
│
└── Calculatrice_Frond_End/      # Angular Frontend
    ├── src/
    │   └── app/                 # Angular components
    └── package.json             # NPM configuration
```

## Prerequisites

### Backend
- Java 17 or higher
- Maven 3.8.1 or higher

### Frontend
- Node.js 18+ and npm

## Setup & Installation

### 1. Backend (Spring Boot)

Navigate to the backend directory:
```bash
cd calculatrice
```

Build the project:
```bash
mvn clean install
```

Run the Spring Boot application:
```bash
mvn spring-boot:run
```

The backend will start on **http://localhost:8080**

**API Endpoints:**
- `POST /api/calculatrice/add` - Add two numbers
- `POST /api/calculatrice/subtract` - Subtract two numbers
- `POST /api/calculatrice/multiply` - Multiply two numbers
- `POST /api/calculatrice/divide` - Divide two numbers
- `POST /api/calculatrice/modulo` - Modulo operation
- `POST /api/calculatrice/power` - Power operation
- `POST /api/calculatrice/sqrt` - Square root
- `POST /api/calculatrice/factorial` - Factorial
- `POST /api/calculatrice/percentage` - Percentage calculation
- `GET /api/calculatrice/health` - Health check

**Request Format:**
```json
{
  "a": 10,
  "b": 5
}
```

**Response Format:**
```json
{
  "result": 15,
  "error": null
}
```

### 2. Frontend (Angular)

Navigate to the frontend directory:
```bash
cd Calculatrice_Frond_End
```

Install dependencies:
```bash
npm install
```

Start the development server:
```bash
npm start
```

The frontend will be available at **http://localhost:4200**

## Features

### Calculator Operations
- ✅ **Basic Arithmetic**: Addition, Subtraction, Multiplication, Division
- ✅ **Advanced Operations**: Power, Square Root, Factorial, Percentage, Modulo
- ✅ **Error Handling**: Division by zero, invalid operations
- ✅ **Clean UI**: Responsive design with gradient styling
- ✅ **Backend Integration**: All calculations processed by Spring Boot API

### UI Components
- Display panel showing calculation results
- Numeric buttons (0-9)
- Operation buttons (+, -, *, /, %, ^, √, !)
- Clear button (C)
- Backspace button (←)
- Equals button (=)
- Toggle negative button (≈)

## How to Use

1. **Make sure both services are running:**
   - Backend: `http://localhost:8080`
   - Frontend: `http://localhost:4200`

2. **Open the calculator in your browser:**
   - Navigate to `http://localhost:4200`

3. **Perform calculations:**
   - Click number buttons to enter values
   - Click operation buttons to select an operation
   - Click `=` to execute the calculation
   - Click `C` to clear the display

## Example Calculations

- **5 + 3 = 8**
- **10 - 4 = 6**
- **6 * 7 = 42**
- **20 / 4 = 5**
- **√16 = 4**
- **2 ^ 3 = 8**
- **5! = 120**

## Troubleshooting

### Backend Connection Error
If you see "Cannot connect to backend" message:
1. Ensure Spring Boot is running on port 8080
2. Check if CORS is properly configured
3. Verify the API endpoint is correct in the service

### Port Already in Use
- Backend (8080): `lsof -i :8080` to find and kill the process
- Frontend (4200): `lsof -i :4200` to find and kill the process

### Build Issues
- **Backend**: Clear Maven cache: `mvn clean`
- **Frontend**: Clear node_modules: `rm -rf node_modules && npm install`

## Technologies Used

### Backend
- **Spring Boot 3.5.7**
- **Java 17**
- **Maven**

### Frontend
- **Angular 20**
- **TypeScript 5.9**
- **SCSS** for styling
- **RxJS** for reactive programming

## Development

### Backend Development
- Edit service logic in `src/main/java/com/example/calculatrice/service/CalculatriceService.java`
- Modify API endpoints in `src/main/java/com/example/calculatrice/controller/CalculatriceController.java`

### Frontend Development
- Modify calculator logic in `src/app/components/calculator.component.ts`
- Update styles in `src/app/components/calculator.component.scss`
- Update API service in `src/app/services/calculatrice.service.ts`

## Future Enhancements
- [ ] History of calculations
- [ ] Scientific calculator mode
- [ ] Dark mode toggle
- [ ] Keyboard input support
- [ ] Expression parser
- [ ] Unit conversion
- [ ] Database for calculation history

## License
MIT

## Author
Developed as a full-stack calculator application demonstrating Spring Boot and Angular integration.
