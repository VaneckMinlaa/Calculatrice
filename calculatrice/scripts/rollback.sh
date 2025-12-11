#!/bin/bash
# ========================================
# Rollback Script
# ========================================
# This script rolls back to the previous deployment
# ========================================

set -e  # Exit on error

echo "=========================================="
echo "Rollback to Previous Release"
echo "=========================================="
echo ""

# Configuration
DEPLOY_USER="${DEPLOY_USER:-deployer}"
DEPLOY_HOST="${DEPLOY_HOST:-localhost}"
DEPLOY_PATH="${DEPLOY_PATH:-/opt/calculatrice}"

# Service ports
EUREKA_PORT=8761
GATEWAY_PORT=8080
ADDITION_PORT=8081
SUBTRACTION_PORT=8082
MULTIPLICATION_PORT=8083
DIVISION_PORT=8084
MODULO_PORT=8085

echo "Rollback Configuration:"
echo "  Deploy Host: $DEPLOY_HOST"
echo "  Deploy Path: $DEPLOY_PATH"
echo ""

# Confirmation
read -p "Are you sure you want to rollback? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Rollback cancelled."
    exit 0
fi

# ========================================
# Step 1: Find previous release
# ========================================
echo "[1/4] Finding previous release..."

LAST_RELEASE=$(ssh $DEPLOY_USER@$DEPLOY_HOST "
    if [ -f $DEPLOY_PATH/last-release.txt ]; then
        cat $DEPLOY_PATH/last-release.txt
    else
        cd $DEPLOY_PATH/releases
        ls -t | head -2 | tail -1
    fi
")

if [ -z "$LAST_RELEASE" ]; then
    echo "ERROR: No previous release found!"
    exit 1
fi

echo "Previous release: $LAST_RELEASE"

# Verify release exists
ssh $DEPLOY_USER@$DEPLOY_HOST "
    if [ ! -d $LAST_RELEASE ]; then
        echo 'ERROR: Release directory not found: $LAST_RELEASE'
        exit 1
    fi
"

# ========================================
# Step 2: Stop current services
# ========================================
echo "[2/4] Stopping current services..."

ssh $DEPLOY_USER@$DEPLOY_HOST "
    for port in $MODULO_PORT $DIVISION_PORT $MULTIPLICATION_PORT $SUBTRACTION_PORT $ADDITION_PORT $GATEWAY_PORT $EUREKA_PORT; do
        pid=\$(lsof -ti:\$port || true)
        if [ ! -z \"\$pid\" ]; then
            echo \"Stopping service on port \$port (PID: \$pid)\"
            kill -15 \$pid || true
            sleep 2
            kill -9 \$pid 2>/dev/null || true
        fi
    done
    
    sleep 5
"

# ========================================
# Step 3: Switch to previous release
# ========================================
echo "[3/4] Switching to previous release..."

ssh $DEPLOY_USER@$DEPLOY_HOST "
    # Save current release for potential re-rollback
    if [ -L $DEPLOY_PATH/current ]; then
        CURRENT=\$(readlink $DEPLOY_PATH/current)
        echo \$CURRENT > $DEPLOY_PATH/rollback-from.txt
    fi
    
    # Update symlink
    rm -f $DEPLOY_PATH/current
    ln -sf $LAST_RELEASE $DEPLOY_PATH/current
    
    echo 'Switched to: $LAST_RELEASE'
"

# ========================================
# Step 4: Start services with previous release
# ========================================
echo "[4/4] Starting services with previous release..."

# Create rollback startup script
cat > /tmp/start-services-rollback.sh <<'EOF'
#!/bin/bash
DEPLOY_PATH="${1:-/opt/calculatrice}"
LOG_DIR="$DEPLOY_PATH/logs"

# Java options
JAVA_OPTS="-Xmx1024m -Xms512m -Dspring.config.additional-location=$DEPLOY_PATH/config/"

# Start Eureka Server
echo "Starting Eureka Server..."
nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/timora-eureka-server-*.jar \
    > $LOG_DIR/eureka-server.log 2>&1 &
echo $! > $DEPLOY_PATH/eureka-server.pid
sleep 15

# Start Gateway
echo "Starting Gateway..."
nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/calculatrice-gateway-*.jar \
    > $LOG_DIR/gateway.log 2>&1 &
echo $! > $DEPLOY_PATH/gateway.pid
sleep 5

# Start microservices
for service in addition subtraction multiplication division modulo; do
    echo "Starting $service service..."
    nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/${service}-service-*.jar \
        > $LOG_DIR/${service}-service.log 2>&1 &
    echo $! > $DEPLOY_PATH/${service}-service.pid
    sleep 3
done

echo "All services started!"
EOF

rsync -avz /tmp/start-services-rollback.sh $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/
rm /tmp/start-services-rollback.sh

ssh $DEPLOY_USER@$DEPLOY_HOST "chmod +x $DEPLOY_PATH/start-services-rollback.sh && $DEPLOY_PATH/start-services-rollback.sh $DEPLOY_PATH"

# ========================================
# Health Check
# ========================================
echo ""
echo "Waiting for services to start..."
sleep 30

echo "Performing health checks..."
HEALTH_CHECK_FAILED=0

for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
    if ssh $DEPLOY_USER@$DEPLOY_HOST "curl -sf http://localhost:$port/actuator/health > /dev/null"; then
        echo "  ✓ Service on port $port is healthy"
    else
        echo "  ✗ Service on port $port is not responding"
        HEALTH_CHECK_FAILED=1
    fi
done

if [ $HEALTH_CHECK_FAILED -eq 1 ]; then
    echo ""
    echo "WARNING: Some services failed health checks after rollback!"
    echo "Please check logs at: $DEPLOY_PATH/logs/"
    exit 1
fi

echo ""
echo "=========================================="
echo "Rollback Completed Successfully!"
echo "=========================================="
echo ""
echo "Rolled back to: $LAST_RELEASE"
echo ""
echo "Service URLs:"
echo "  Eureka Server: http://$DEPLOY_HOST:$EUREKA_PORT"
echo "  API Gateway:   http://$DEPLOY_HOST:$GATEWAY_PORT"
echo ""

