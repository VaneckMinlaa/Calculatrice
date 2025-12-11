#!/bin/bash
# ========================================
# Development Environment Deployment Script
# ========================================
# This script deploys the application to the development environment
# ========================================

set -e  # Exit on error

echo "=========================================="
echo "Deploying to Development Environment"
echo "=========================================="
echo ""

# Configuration
DEPLOY_USER="${DEPLOY_USER:-deployer}"
DEPLOY_HOST="${DEPLOY_HOST:-localhost}"
DEPLOY_PATH="${DEPLOY_PATH:-/opt/calculatrice}"
ENVIRONMENT="development"

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-calculatrice_db}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-root}"

# Service ports
EUREKA_PORT=8761
GATEWAY_PORT=8080
ADDITION_PORT=8081
SUBTRACTION_PORT=8082
MULTIPLICATION_PORT=8083
DIVISION_PORT=8084
MODULO_PORT=8085

echo "Deployment Configuration:"
echo "  Environment: $ENVIRONMENT"
echo "  Deploy Host: $DEPLOY_HOST"
echo "  Deploy Path: $DEPLOY_PATH"
echo "  Database: $DB_HOST:$DB_PORT/$DB_NAME"
echo ""

# ========================================
# Step 1: Prepare deployment directory
# ========================================
echo "[1/7] Preparing deployment directory..."
ssh $DEPLOY_USER@$DEPLOY_HOST "mkdir -p $DEPLOY_PATH/{logs,config,backup}"

# ========================================
# Step 2: Backup current deployment
# ========================================
echo "[2/7] Backing up current deployment..."
BACKUP_DIR="$DEPLOY_PATH/backup/backup-$(date +%Y%m%d-%H%M%S)"
ssh $DEPLOY_USER@$DEPLOY_HOST "
    if [ -d $DEPLOY_PATH/current ]; then
        mkdir -p $BACKUP_DIR
        cp -r $DEPLOY_PATH/current/* $BACKUP_DIR/ || true
        echo 'Backup created at: $BACKUP_DIR'
    else
        echo 'No previous deployment found, skipping backup'
    fi
"

# ========================================
# Step 3: Stop running services
# ========================================
echo "[3/7] Stopping running services..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    # Stop services by port
    for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
        pid=\$(lsof -ti:\$port || true)
        if [ ! -z \"\$pid\" ]; then
            echo \"Stopping service on port \$port (PID: \$pid)\"
            kill -15 \$pid || true
            sleep 2
            kill -9 \$pid 2>/dev/null || true
        fi
    done
"

# ========================================
# Step 4: Upload JAR files
# ========================================
echo "[4/7] Uploading JAR files..."
mkdir -p $DEPLOY_PATH/current

# Upload Eureka Server
rsync -avz --progress \
    Calaculatrice-eureka-service/target/*.jar \
    $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/current/

# Upload Gateway
rsync -avz --progress \
    calculatrice-gateway/target/*.jar \
    $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/current/

# Upload Microservices
for service in addition subtraction multiplication division modulo; do
    rsync -avz --progress \
        microservices/${service}-service/target/*.jar \
        $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/current/
done

# ========================================
# Step 5: Upload configuration files
# ========================================
echo "[5/7] Uploading configuration files..."

# Create environment configuration
cat > /tmp/application.properties <<EOF
# Database Configuration
spring.datasource.url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
spring.datasource.username=$DB_USER
spring.datasource.password=$DB_PASSWORD

# Eureka Configuration
eureka.client.service-url.defaultZone=http://localhost:$EUREKA_PORT/eureka/
EOF

rsync -avz /tmp/application.properties $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/config/
rm /tmp/application.properties

# ========================================
# Step 6: Initialize/Update Database
# ========================================
echo "[6/7] Initializing database..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    export PGPASSWORD='$DB_PASSWORD'
    
    # Check if database exists
    if psql -h $DB_HOST -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        echo 'Database already exists'
    else
        echo 'Creating database...'
        psql -h $DB_HOST -U $DB_USER -c 'CREATE DATABASE $DB_NAME;'
    fi
    
    # Run initialization script if exists
    if [ -f $DEPLOY_PATH/init-db.sql ]; then
        echo 'Running database initialization script...'
        psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f $DEPLOY_PATH/init-db.sql
    fi
"

# Upload init-db.sql for future use
rsync -avz init-db.sql $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/

# ========================================
# Step 7: Start services
# ========================================
echo "[7/7] Starting services..."

# Create startup script
cat > /tmp/start-services.sh <<'EOF'
#!/bin/bash
DEPLOY_PATH="${1:-/opt/calculatrice}"
LOG_DIR="$DEPLOY_PATH/logs"

# Java options
JAVA_OPTS="-Xmx512m -Xms256m -Dspring.config.additional-location=$DEPLOY_PATH/config/"

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

rsync -avz /tmp/start-services.sh $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/
rm /tmp/start-services.sh

ssh $DEPLOY_USER@$DEPLOY_HOST "chmod +x $DEPLOY_PATH/start-services.sh && $DEPLOY_PATH/start-services.sh $DEPLOY_PATH"

# ========================================
# Step 8: Health Check
# ========================================
echo ""
echo "Waiting for services to start..."
sleep 20

echo "Checking service health..."
for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
    if ssh $DEPLOY_USER@$DEPLOY_HOST "curl -s http://localhost:$port/actuator/health > /dev/null"; then
        echo "  ✓ Service on port $port is healthy"
    else
        echo "  ✗ Service on port $port is not responding"
    fi
done

echo ""
echo "=========================================="
echo "Deployment to Development Complete!"
echo "=========================================="
echo ""
echo "Service URLs:"
echo "  Eureka Server: http://$DEPLOY_HOST:$EUREKA_PORT"
echo "  API Gateway:   http://$DEPLOY_HOST:$GATEWAY_PORT"
echo ""
echo "Logs are available at: $DEPLOY_PATH/logs/"
echo ""

