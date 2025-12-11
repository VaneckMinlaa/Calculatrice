-- ========================================
-- Database Initialization Script
-- ========================================
-- This script is automatically run when PostgreSQL starts for the first time
-- ========================================

-- Create database if not exists (handled by POSTGRES_DB env var)
\c calculatrice_db;

-- ========================================
-- Create Tables for Calculation History
-- ========================================

CREATE TABLE IF NOT EXISTS calculation_history (
    id BIGSERIAL PRIMARY KEY,
    operation_type VARCHAR(50) NOT NULL,
    operand1 DECIMAL(20, 10) NOT NULL,
    operand2 DECIMAL(20, 10) NOT NULL,
    result DECIMAL(20, 10) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    service_name VARCHAR(100),
    user_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- Create Indexes for Performance
-- ========================================

CREATE INDEX IF NOT EXISTS idx_operation_type ON calculation_history(operation_type);
CREATE INDEX IF NOT EXISTS idx_timestamp ON calculation_history(timestamp);
CREATE INDEX IF NOT EXISTS idx_user_id ON calculation_history(user_id);

-- ========================================
-- Create Sample Data (Optional)
-- ========================================

INSERT INTO calculation_history (operation_type, operand1, operand2, result, service_name, user_id) 
VALUES 
    ('ADDITION', 10.5, 5.5, 16.0, 'addition-service', 'system'),
    ('SUBTRACTION', 20.0, 8.0, 12.0, 'subtraction-service', 'system'),
    ('MULTIPLICATION', 5.0, 4.0, 20.0, 'multiplication-service', 'system'),
    ('DIVISION', 100.0, 5.0, 20.0, 'division-service', 'system'),
    ('MODULO', 17.0, 5.0, 2.0, 'modulo-service', 'system')
ON CONFLICT DO NOTHING;

-- ========================================
-- Grant Permissions
-- ========================================

GRANT ALL PRIVILEGES ON DATABASE calculatrice_db TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;

-- ========================================
-- Success Message
-- ========================================

DO $$
BEGIN
    RAISE NOTICE 'Database initialization completed successfully!';
END $$;

