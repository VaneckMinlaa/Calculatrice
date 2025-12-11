#!/bin/bash
# ========================================
# Production Environment Deployment Script
# ========================================
# This script deploys the application to the production environment
# with additional safety checks and rollback capabilities
# ========================================

set -e  # Exit on error

echo "=========================================="
echo "Deploying to PRODUCTION Environment"
echo "=========================================="
echo ""

# Configuration
DEPLOY_USER="${DEPLOY_USER:-deployer}"
DEPLOY_HOST="${DEPLOY_HOST:-prod.example.com}"
DEPLOY_PATH="${DEPLOY_PATH:-/opt/calculatrice}"
ENVIRONMENT="production"

# Database configuration
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-calculatrice_db_prod}"
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

echo "⚠️  PRODUCTION DEPLOYMENT ⚠️"
echo ""
echo "Deployment Configuration:"
echo "  Environment: $ENVIRONMENT"
echo "  Deploy Host: $DEPLOY_HOST"
echo "  Deploy Path: $DEPLOY_PATH"
echo "  Database: $DB_HOST:$DB_PORT/$DB_NAME"
echo ""

# Multiple confirmation prompts for production
read -p "Are you ABSOLUTELY sure you want to deploy to PRODUCTION? (type 'YES' in uppercase): " confirm1
if [ "$confirm1" != "YES" ]; then
    echo "Deployment cancelled."
    exit 0
fi

read -p "Have you tested this release in staging? (yes/no): " confirm2
if [ "$confirm2" != "yes" ]; then
    echo "Please test in staging first. Deployment cancelled."
    exit 0
fi

read -p "Final confirmation - Deploy to PRODUCTION? (type 'DEPLOY'): " confirm3
if [ "$confirm3" != "DEPLOY" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# ========================================
# Step 1: Pre-deployment checks
# ========================================
echo ""
echo "[1/10] Running pre-deployment checks..."

# Check SSH connectivity
if ! ssh -o ConnectTimeout=5 $DEPLOY_USER@$DEPLOY_HOST "echo 'SSH connection successful'"; then
    echo "ERROR: Cannot connect to production server"
    exit 1
fi

# Check disk space
DISK_USAGE=$(ssh $DEPLOY_USER@$DEPLOY_HOST "df -h $DEPLOY_PATH | tail -1 | awk '{print \$5}' | sed 's/%//'")
if [ $DISK_USAGE -gt 85 ]; then
    echo "ERROR: Disk usage is too high ($DISK_USAGE%). Please free up space."
    exit 1
fi

echo "Pre-deployment checks passed ✓"

# ========================================
# Step 2: Prepare deployment directory
# ========================================
echo "[2/10] Preparing deployment directory..."
ssh $DEPLOY_USER@$DEPLOY_HOST "mkdir -p $DEPLOY_PATH/{logs,config,backup,releases}"

# ========================================
# Step 3: Create release directory
# ========================================
RELEASE_ID="release-$(date +%Y%m%d-%H%M%S)"
RELEASE_PATH="$DEPLOY_PATH/releases/$RELEASE_ID"

echo "[3/10] Creating release: $RELEASE_ID..."
ssh $DEPLOY_USER@$DEPLOY_HOST "mkdir -p $RELEASE_PATH"

# Save release info
echo "$RELEASE_ID" > /tmp/current-release.txt
echo "$(date)" >> /tmp/current-release.txt
echo "$CI_COMMIT_SHA" >> /tmp/current-release.txt
rsync -avz /tmp/current-release.txt $DEPLOY_USER@$DEPLOY_HOST:$RELEASE_PATH/release-info.txt
rm /tmp/current-release.txt

# ========================================
# Step 4: Backup current deployment
# ========================================
echo "[4/10] Backing up current deployment..."
BACKUP_DIR="$DEPLOY_PATH/backup/backup-$(date +%Y%m%d-%H%M%S)"

ssh $DEPLOY_USER@$DEPLOY_HOST "
    if [ -L $DEPLOY_PATH/current ]; then
        CURRENT_RELEASE=\$(readlink $DEPLOY_PATH/current)
        echo 'Current release: \$CURRENT_RELEASE'
        echo \$CURRENT_RELEASE > $DEPLOY_PATH/last-release.txt
        
        # Create full backup
        mkdir -p $BACKUP_DIR
        cp -r \$CURRENT_RELEASE/* $BACKUP_DIR/
        echo 'Backup created at: $BACKUP_DIR'
    else
        echo 'No previous deployment found'
    fi
"

# ========================================
# Step 5: Database backup
# ========================================
echo "[5/10] Backing up production database..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    export PGPASSWORD='$DB_PASSWORD'
    BACKUP_FILE='$DEPLOY_PATH/backup/db-backup-\$(date +%Y%m%d-%H%M%S).sql'
    
    if psql -h $DB_HOST -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        echo 'Creating database backup...'
        pg_dump -h $DB_HOST -U $DB_USER $DB_NAME > \$BACKUP_FILE
        gzip \$BACKUP_FILE
        echo 'Database backup created: \${BACKUP_FILE}.gz'
    else
        echo 'Database does not exist yet'
    fi
"

# ========================================
# Step 6: Graceful service shutdown
# ========================================
echo "[6/10] Gracefully stopping services..."

# Create maintenance page (if using a web server)
ssh $DEPLOY_USER@$DEPLOY_HOST "
    echo '<html><body><h1>Maintenance in Progress</h1><p>We will be back shortly.</p></body></html>' \
        > $DEPLOY_PATH/maintenance.html
"

# Stop services with grace period
ssh $DEPLOY_USER@$DEPLOY_HOST "
    # Stop services in reverse order
    for port in $MODULO_PORT $DIVISION_PORT $MULTIPLICATION_PORT $SUBTRACTION_PORT $ADDITION_PORT $GATEWAY_PORT $EUREKA_PORT; do
        pid=\$(lsof -ti:\$port || true)
        if [ ! -z \"\$pid\" ]; then
            echo \"Stopping service on port \$port (PID: \$pid)\"
            kill -15 \$pid || true
        fi
    done
    
    # Wait for graceful shutdown
    echo 'Waiting 30 seconds for graceful shutdown...'
    sleep 30
    
    # Force kill if still running
    for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
        pid=\$(lsof -ti:\$port || true)
        if [ ! -z \"\$pid\" ]; then
            echo \"Force stopping service on port \$port\"
            kill -9 \$pid 2>/dev/null || true
        fi
    done
    
    # Verify all ports are free
    sleep 5
"

# ========================================
# Step 7: Upload JAR files
# ========================================
echo "[7/10] Uploading JAR files..."

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
# Step 8: Upload configuration
# ========================================
echo "[8/10] Uploading configuration files..."

# Create production configuration
cat > /tmp/application-prod.properties <<EOF
# Database Configuration
spring.datasource.url=jdbc:postgresql://$DB_HOST:$DB_PORT/$DB_NAME
spring.datasource.username=$DB_USER
spring.datasource.password=$DB_PASSWORD

# Eureka Configuration
eureka.client.service-url.defaultZone=http://localhost:$EUREKA_PORT/eureka/

# Production Logging
logging.level.root=WARN
logging.level.com.example=INFO
logging.file.name=$DEPLOY_PATH/logs/application.log
logging.file.max-size=100MB
logging.file.max-history=30

# Production Settings
spring.jpa.show-sql=false
management.endpoints.web.exposure.include=health,info,metrics
EOF

rsync -avz /tmp/application-prod.properties $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/config/application.properties
rm /tmp/application-prod.properties

# ========================================
# Step 9: Update database (if needed)
# ========================================
echo "[9/10] Updating database schema..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    export PGPASSWORD='$DB_PASSWORD'
    
    if ! psql -h $DB_HOST -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
        echo 'Creating production database...'
        psql -h $DB_HOST -U $DB_USER -c 'CREATE DATABASE $DB_NAME;'
        psql -h $DB_HOST -U $DB_USER -d $DB_NAME -f $DEPLOY_PATH/init-db.sql
    fi
"

# ========================================
# Step 10: Switch to new release and start services
# ========================================
echo "[10/10] Starting services with new release..."

# Create production startup script
cat > /tmp/start-services-prod.sh <<'EOF'
#!/bin/bash
DEPLOY_PATH="${1:-/opt/calculatrice}"
RELEASE_PATH="${2}"
LOG_DIR="$DEPLOY_PATH/logs"

# Update symlink to new release
rm -f $DEPLOY_PATH/current
ln -sf $RELEASE_PATH $DEPLOY_PATH/current

# Production Java options
JAVA_OPTS="-Xmx2048m -Xms1024m \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -Dspring.config.additional-location=$DEPLOY_PATH/config/ \
    -Dspring.profiles.active=production \
    -Djava.security.egd=file:/dev/./urandom"

# Start Eureka Server
echo "Starting Eureka Server..."
nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/timora-eureka-server-*.jar \
    > $LOG_DIR/eureka-server.log 2>&1 &
echo $! > $DEPLOY_PATH/eureka-server.pid
sleep 20

# Start Gateway
echo "Starting Gateway..."
nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/calculatrice-gateway-*.jar \
    > $LOG_DIR/gateway.log 2>&1 &
echo $! > $DEPLOY_PATH/gateway.pid
sleep 10

# Start microservices
for service in addition subtraction multiplication division modulo; do
    echo "Starting $service service..."
    nohup java $JAVA_OPTS -jar $DEPLOY_PATH/current/${service}-service-*.jar \
        > $LOG_DIR/${service}-service.log 2>&1 &
    echo $! > $DEPLOY_PATH/${service}-service.pid
    sleep 5
done

echo "All services started!"
EOF

rsync -avz /tmp/start-services-prod.sh $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/
rm /tmp/start-services-prod.sh

ssh $DEPLOY_USER@$DEPLOY_HOST "chmod +x $DEPLOY_PATH/start-services-prod.sh && $DEPLOY_PATH/start-services-prod.sh $DEPLOY_PATH $RELEASE_PATH"

# ========================================
# Health Checks with Retry
# ========================================
echo ""
echo "Waiting for services to start..."
sleep 40

echo "Performing comprehensive health checks..."
HEALTH_CHECK_FAILED=0
MAX_RETRIES=5

for port in $EUREKA_PORT $GATEWAY_PORT $ADDITION_PORT $SUBTRACTION_PORT $MULTIPLICATION_PORT $DIVISION_PORT $MODULO_PORT; do
    RETRY=0
    SUCCESS=0
    
    while [ $RETRY -lt $MAX_RETRIES ]; do
        if ssh $DEPLOY_USER@$DEPLOY_HOST "curl -sf http://localhost:$port/actuator/health > /dev/null"; then
            echo "  ✓ Service on port $port is healthy"
            SUCCESS=1
            break
        fi
        RETRY=$((RETRY+1))
        echo "  Retry $RETRY/$MAX_RETRIES for port $port..."
        sleep 10
    done
    
    if [ $SUCCESS -eq 0 ]; then
        echo "  ✗ Service on port $port failed health check"
        HEALTH_CHECK_FAILED=1
    fi
done

# ========================================
# Rollback on failure
# ========================================
if [ $HEALTH_CHECK_FAILED -eq 1 ]; then
    echo ""
    echo "❌ DEPLOYMENT FAILED - Health checks did not pass"
    echo "Initiating automatic rollback..."
    
    # Call rollback script
    if [ -f scripts/rollback.sh ]; then
        chmod +x scripts/rollback.sh
        ./scripts/rollback.sh
    fi
    
    exit 1
fi

# ========================================
# Cleanup
# ========================================
echo ""
echo "Cleaning up old releases (keeping last 10)..."
ssh $DEPLOY_USER@$DEPLOY_HOST "
    cd $DEPLOY_PATH/releases
    ls -t | tail -n +11 | xargs -r rm -rf
    
    # Cleanup old backups (keep last 30 days)
    find $DEPLOY_PATH/backup -name 'backup-*' -mtime +30 -exec rm -rf {} \;
    find $DEPLOY_PATH/backup -name 'db-backup-*.sql.gz' -mtime +30 -delete
"

# Remove maintenance page
ssh $DEPLOY_USER@$DEPLOY_HOST "rm -f $DEPLOY_PATH/maintenance.html"

# ========================================
# Success
# ========================================
echo ""
echo "=========================================="
echo "✓ PRODUCTION DEPLOYMENT SUCCESSFUL!"
echo "=========================================="
echo ""
echo "Release: $RELEASE_ID"
echo "Deployed at: $(date)"
echo ""
echo "Service URLs:"
echo "  Eureka Server: http://$DEPLOY_HOST:$EUREKA_PORT"
echo "  API Gateway:   http://$DEPLOY_HOST:$GATEWAY_PORT"
echo ""
echo "Logs: $DEPLOY_PATH/logs/"
echo "Backup: $BACKUP_DIR"
echo ""
echo "Monitor the application and check logs for any issues."
echo ""

