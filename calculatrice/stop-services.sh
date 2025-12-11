#!/bin/bash
# ========================================
# Stop All Microservices - Linux/Mac
# ========================================

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "========================================"
echo "Stopping All Calculatrice Services"
echo "========================================"
echo ""

docker-compose down

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}[SUCCESS]${NC} All services stopped successfully!"
    echo ""
else
    echo ""
    echo -e "${RED}[ERROR]${NC} Failed to stop services!"
    echo ""
fi

