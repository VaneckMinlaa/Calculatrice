#!/bin/bash
# ========================================
# Initial Setup Script - Linux/Mac
# ========================================

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "========================================"
echo "Calculatrice Microservices - Setup"
echo "========================================"
echo ""

# Step 1: Check Docker
echo -e "${BLUE}[1/5]${NC} Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}[ERROR]${NC} Docker is not installed!"
    echo "Please install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi
echo -e "${GREEN}[OK]${NC} Docker is installed"
echo ""

# Step 2: Create .env file
echo -e "${BLUE}[2/5]${NC} Setting up environment configuration..."
if [ -f ".env" ]; then
    echo -e "${YELLOW}[WARNING]${NC} .env file already exists"
    read -p "Do you want to overwrite it? (yes/no): " overwrite
    if [ "$overwrite" = "yes" ]; then
        cp env.template .env
        echo -e "${GREEN}[OK]${NC} .env file recreated"
    else
        echo -e "${GREEN}[OK]${NC} Keeping existing .env file"
    fi
else
    cp env.template .env
    echo -e "${GREEN}[OK]${NC} .env file created from template"
fi
echo ""

# Step 3: Make scripts executable
echo -e "${BLUE}[3/5]${NC} Making scripts executable..."
chmod +x deploy.sh
chmod +x stop-services.sh
chmod +x health-check.sh
chmod +x setup.sh
echo -e "${GREEN}[OK]${NC} Scripts are executable"
echo ""

# Step 4: Pull base images
echo -e "${BLUE}[4/5]${NC} Pulling Docker base images..."
echo "This may take several minutes..."
docker pull postgres:15-alpine
docker pull maven:3.9.5-eclipse-temurin-17
docker pull eclipse-temurin:17-jre-alpine
echo -e "${GREEN}[OK]${NC} Base images pulled"
echo ""

# Step 5: Display next steps
echo -e "${BLUE}[5/5]${NC} Setup completed successfully!"
echo ""
echo "========================================"
echo "Next Steps:"
echo "========================================"
echo ""
echo "1. Edit the .env file if needed:"
echo "   - Update POSTGRES_PASSWORD for production"
echo "   - Adjust ports if conflicts exist"
echo ""
echo "2. Deploy the application:"
echo "   - Run: ./deploy.sh"
echo "   - Select option 1 (Full Deployment)"
echo ""
echo "3. Verify the deployment:"
echo "   - Run: ./health-check.sh"
echo "   - Or visit: http://localhost:8761"
echo ""
echo "========================================"
echo "Configuration Summary:"
echo "========================================"
cat .env
echo "========================================"
echo ""

