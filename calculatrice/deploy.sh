#!/bin/bash
# ========================================
# Automated Deployment Script for Linux/Mac
# Calculatrice Microservices Architecture
# ========================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo "========================================"
echo "Calculatrice Microservices Deployment"
echo "========================================"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}[ERROR]${NC} Docker is not running! Please start Docker first."
    exit 1
fi

echo -e "${GREEN}[OK]${NC} Docker is running"
echo ""

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}[WARNING]${NC} .env file not found!"
    echo -e "${BLUE}[INFO]${NC} Creating .env from template..."
    
    if [ -f "env.template" ]; then
        cp env.template .env
        echo -e "${GREEN}[OK]${NC} .env file created from template"
        echo -e "${YELLOW}[ACTION REQUIRED]${NC} Please edit .env file with your credentials before continuing"
        read -p "Press enter to continue..."
    else
        echo -e "${RED}[ERROR]${NC} env.template not found! Cannot create .env file."
        exit 1
    fi
fi

echo -e "${GREEN}[OK]${NC} .env file exists"
echo ""

# Display menu
display_menu() {
    echo "Select deployment option:"
    echo ""
    echo "1. Full Deployment (Stop + Clean + Build + Start)"
    echo "2. Quick Start (Start existing containers)"
    echo "3. Stop All Services"
    echo "4. View Logs"
    echo "5. Clean Everything (Remove containers, images, volumes)"
    echo "6. Build Only (No start)"
    echo "7. Exit"
    echo ""
    read -p "Enter your choice (1-7): " choice
}

# Full deployment
full_deploy() {
    echo ""
    echo "========================================"
    echo "Full Deployment Started"
    echo "========================================"
    echo ""

    echo -e "${BLUE}[1/5]${NC} Stopping existing containers..."
    docker-compose down
    echo ""

    echo -e "${BLUE}[2/5]${NC} Removing old images..."
    docker-compose down --rmi local
    echo ""

    echo -e "${BLUE}[3/5]${NC} Building all services..."
    docker-compose build --no-cache
    echo ""

    echo -e "${BLUE}[4/5]${NC} Starting all services..."
    docker-compose up -d
    echo ""

    echo -e "${BLUE}[5/5]${NC} Waiting for services to start..."
    sleep 30
    echo ""

    echo "========================================"
    echo "Service Status"
    echo "========================================"
    docker-compose ps
    echo ""

    echo "========================================"
    echo "Services are now available at:"
    echo "========================================"
    echo "Eureka Dashboard:    http://localhost:8761"
    echo "API Gateway:         http://localhost:8080"
    echo "Addition Service:    http://localhost:8081"
    echo "Subtraction Service: http://localhost:8082"
    echo "Multiplication:      http://localhost:8083"
    echo "Division Service:    http://localhost:8084"
    echo "Modulo Service:      http://localhost:8085"
    echo "PostgreSQL:          localhost:5432"
    echo "========================================"
    echo ""
    echo -e "${GREEN}[SUCCESS]${NC} Deployment completed successfully!"
    echo ""
    echo "Useful commands:"
    echo "- View logs: docker-compose logs -f"
    echo "- Stop services: docker-compose down"
    echo "- Restart service: docker-compose restart [service-name]"
    echo ""
}

# Quick start
quick_start() {
    echo ""
    echo "========================================"
    echo "Quick Start"
    echo "========================================"
    echo ""

    docker-compose up -d
    echo -e "${GREEN}[SUCCESS]${NC} Services started!"
    docker-compose ps
    echo ""
}

# Stop services
stop_services() {
    echo ""
    echo "========================================"
    echo "Stopping All Services"
    echo "========================================"
    echo ""

    docker-compose down
    echo -e "${GREEN}[SUCCESS]${NC} All services stopped!"
    echo ""
}

# View logs
view_logs() {
    echo ""
    echo "========================================"
    echo "Viewing Logs (Press Ctrl+C to exit)"
    echo "========================================"
    echo ""

    docker-compose logs -f
}

# Clean everything
clean_all() {
    echo ""
    echo "========================================"
    echo "Clean Everything"
    echo "========================================"
    echo -e "${YELLOW}[WARNING]${NC} This will remove all containers, images, and volumes!"
    echo ""

    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" != "yes" ]; then
        echo -e "${YELLOW}[CANCELLED]${NC} Operation cancelled."
        return
    fi

    echo ""
    echo "Cleaning..."
    docker-compose down -v --rmi all
    docker system prune -f
    echo -e "${GREEN}[SUCCESS]${NC} Everything cleaned!"
    echo ""
}

# Build only
build_only() {
    echo ""
    echo "========================================"
    echo "Building All Services"
    echo "========================================"
    echo ""

    docker-compose build --no-cache
    echo -e "${GREEN}[SUCCESS]${NC} Build completed!"
    echo ""
}

# Main menu loop
while true; do
    display_menu

    case $choice in
        1)
            full_deploy
            read -p "Press enter to continue..."
            ;;
        2)
            quick_start
            read -p "Press enter to continue..."
            ;;
        3)
            stop_services
            read -p "Press enter to continue..."
            ;;
        4)
            view_logs
            ;;
        5)
            clean_all
            read -p "Press enter to continue..."
            ;;
        6)
            build_only
            read -p "Press enter to continue..."
            ;;
        7)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}[ERROR]${NC} Invalid choice! Please select 1-7."
            read -p "Press enter to continue..."
            ;;
    esac
done

