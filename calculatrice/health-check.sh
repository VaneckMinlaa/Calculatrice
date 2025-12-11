#!/bin/bash
# ========================================
# Health Check Script - Linux/Mac
# ========================================

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo "========================================"
echo "Services Health Check"
echo "========================================"
echo ""

# Array of services and ports
declare -A services=(
    ["eureka-server"]="8761"
    ["calculatrice-gateway"]="8080"
    ["addition-service"]="8081"
    ["subtraction-service"]="8082"
    ["multiplication-service"]="8083"
    ["division-service"]="8084"
    ["modulo-service"]="8085"
)

# Check each service
for service in "${!services[@]}"; do
    port="${services[$service]}"
    echo -n "Checking $service on port $port... "
    
    if curl -s -f http://localhost:$port/actuator/health > /dev/null 2>&1; then
        echo -e "${GREEN}[OK]${NC} healthy"
    else
        echo -e "${RED}[ERROR]${NC} not responding"
    fi
done

echo ""
echo "========================================"
echo "Docker Container Status"
echo "========================================"
docker-compose ps
echo ""

echo "========================================"
echo "PostgreSQL Status"
echo "========================================"
docker exec calculatrice-postgres pg_isready -U postgres
echo ""

