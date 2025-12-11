#!/bin/bash
# ========================================
# Staging Environment Deployment Script
# ========================================
# This script deploys the application to the staging environment
# ========================================

set -e  # Exit on error

echo "=========================================="
echo "Deploying to Staging Environment"
echo "=========================================="
echo ""

# Configuration
DEPLOY_USER="${DEPLOY_USER:-deployer}"
DEPLOY_HOST="${DEPLOY_HOST:-staging.example.com}"
DEPLOY_PATH="${DEPLOY_PATH:-/opt/calculatrice}"
ENVIRONMENT="staging"

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-calculatrice_db_staging}"
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

# Confirmation prompt
read -p "Are you sure you want to deploy to STAGING? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# ========================================
# Step 1: Prepare deployment directory
# ========================================
echo "[1/8] Preparing deployment directory..."
ssh $DEPLOY_USER@$DEPLOY_HOST "mkdir -p $DEPLOY_PATH/{logs,config,backup,releases}"

# ========================================
# Step 2: Create release directory
# ========================================
RELEASE_ID="release-$(date +%Y%m%d-%H%M%S)"
RELEASE_PATH="$DEPLOY_PATH/releases/$RELEASE_ID"

echo "[2/8] Creating release: $RELEASE_ID..."
ssh $DEPLOY_USER@$DEPLOY_HOST "mkdir -p $RELEASE_PATH"

# ========================================
# Step 3: Backup current deployment
# ========================================
echo "[3/8] Backing up current deployment..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    if [ -L $DEPLOY_PATH/current ]; then
        CURRENT_RELEASE=\$(readlink $DEPLOY_PATH/current)
        echo 'Current release: \$CURRENT_RELEASE'
        echo \$CURRENT_RELEASE > $DEPLOY_PATH/last-release.txt
    fi
"

# ========================================
# Step 4: Stop running services
# ========================================
echo "[4/8] Stopping running services..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    # Stop services gracefully
    for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
        pid=\$(lsof -ti:\$port || true)
        if [ ! -z \"\$pid\" ]; then
            echo \"Stopping service on port \$port (PID: \$pid)\"
            kill -15 \$pid || true
            sleep 3
            # Force kill if still running
            if ps -p \$pid > /dev/null 2>&1; then
                kill -9 \$pid 2>/dev/null || true
            fi
        fi
    done
    
    # Wait for ports to be released
    sleep 5
"

# ========================================
# Step 5: Upload JAR files to release directory
# ========================================
echo "[5/8] Uploading JAR files..."

# Upload Eureka Server
rsync -avz --progress \
    Calaculatrice-eureka-service/target/*.jar \
    $DEPLOY_USER@$DEPLOY_HOST:$RELEASE_PATH/

# Upload Gateway
rsync -avz --progress \
    calculatrice-gateway/target/*.jar \
    $DEPLOY_USER@$DEPLOY_HOST:$RELEASE_PATH/

# Upload Microservices
for service in addition subtraction multiplication division modulo; do
    rsync -avz --progress \
        microservices/${service}-service/target/*.jar \
        $DEPLOY_USER@$DEPLOY_HOST:$RELEASE_PATH/
done

# ========================================
# Step 6: Upload configuration files
# ========================================
echo "[6/8] Uploading configuration files..."

# Create environment configuration
cat > /tmp/application-staging.properties <<EOF
# Database Configuration
spring.datasource.url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
spring.datasource.username=$DB_USER
spring.datasource.password=$DB_PASSWORD

# Eureka Configuration
eureka.client.service-url.defaultZone=http://localhost:$EUREKA_PORT/eureka/

# Logging Configuration
logging.level.root=INFO
logging.level.com.example=DEBUG
EOF

rsync -avz /tmp/application-staging.properties $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/config/application.properties
rm /tmp/application-staging.properties

# Upload database initialization script
rsync -avz init-db.sql $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/

# ========================================
# Step 7: Update database
# ========================================
echo "[7/8] Updating database..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    export PGPASSWORD='$DB_PASSWORD'
    
    # Check if database exists
    if psql -h $DB_HOST -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        echo 'Database exists, running migrations...'
    else
        echo 'Creating database...'
        psql -h $DB_HOST -U $DB_USER -c 'CREATE DATABASE $DB_NAME;'
        echo 'Running initialization script...'
        psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f $DEPLOY_PATH/init-db.sql
    fi
"

# ========================================
# Step 8: Switch to new release and start services
# ========================================
echo "[8/8] Switching to new release and starting services..."

# Create startup script
cat > /tmp/start-services-staging.sh <<'EOF'
#!/bin/bash
DEPLOY_PATH="${1:-/opt/calculatrice}"
RELEASE_PATH="${2}"
LOG_DIR="$DEPLOY_PATH/logs"

# Update symlink to new release
rm -f $DEPLOY_PATH/current
ln -sf $RELEASE_PATH $DEPLOY_PATH/current

# Java options for staging
JAVA_OPTS="-Xmx1024m -Xms512m -Dspring.config.additional-location=$DEPLOY_PATH/config/ -Dspring.profiles.active=staging"

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

rsync -avz /tmp/start-services-staging.sh $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/
rm /tmp/start-services-staging.sh

ssh $DEPLOY_USER@$DEPLOY_HOST "chmod +x $DEPLOY_PATH/start-services-staging.sh && $DEPLOY_PATH/start-services-staging.sh $DEPLOY_PATH $RELEASE_PATH"

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
    echo "WARNING: Some services failed health checks!"
    echo "Check logs at: $DEPLOY_PATH/logs/"
    exit 1
fi

# ========================================
# Cleanup old releases
# ========================================
echo ""
echo "Cleaning up old releases (keeping last 5)..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    cd $DEPLOY_PATH/releases
    ls -t | tail -n +6 | xargs -r rm -rf
"

echo ""
echo "=========================================="
echo "Deployment to Staging Complete!"
echo "=========================================="
echo ""
echo "Release: $RELEASE_ID"
echo ""
echo "Service URLs:"
echo "  Eureka Server: http://$DEPLOY_HOST:$EUREKA_PORT"
echo "  API Gateway:   http://$DEPLOY_HOST:$GATEWAY_PORT"
echo ""
echo "Logs: $DEPLOY_PATH/logs/"
echo ""

