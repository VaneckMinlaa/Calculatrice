# ========================================
# Makefile for Calculatrice Microservices
# ========================================
# Usage: make [target]
# ========================================

.PHONY: help setup build start stop restart clean logs health test

# Default target
help:
	@echo "========================================="
	@echo "Calculatrice Microservices - Make Commands"
	@echo "========================================="
	@echo ""
	@echo "Available targets:"
	@echo "  make setup       - Initial setup (create .env, pull images)"
	@echo "  make build       - Build all Docker images"
	@echo "  make start       - Start all services"
	@echo "  make stop        - Stop all services"
	@echo "  make restart     - Restart all services"
	@echo "  make clean       - Clean all containers and images"
	@echo "  make logs        - View logs (all services)"
	@echo "  make health      - Check health of all services"
	@echo "  make test        - Run tests"
	@echo "  make dev         - Start development environment"
	@echo "  make prod        - Start production environment"
	@echo ""

# Initial setup
setup:
	@echo "Setting up environment..."
	@if [ ! -f .env ]; then cp env.template .env; fi
	@chmod +x *.sh
	@docker pull postgres:15-alpine
	@docker pull maven:3.9.5-eclipse-temurin-17
	@docker pull eclipse-temurin:17-jre-alpine
	@echo "Setup completed!"

# Build all services
build:
	@echo "Building all services..."
	docker-compose build --no-cache

# Start all services
start:
	@echo "Starting all services..."
	docker-compose up -d
	@echo "Services started! Check status with: make logs"

# Stop all services
stop:
	@echo "Stopping all services..."
	docker-compose down
	@echo "Services stopped!"

# Restart all services
restart: stop start

# Clean everything
clean:
	@echo "Cleaning all containers, images, and volumes..."
	docker-compose down -v --rmi all
	docker system prune -f
	@echo "Cleaned!"

# View logs
logs:
	docker-compose logs -f

# Health check
health:
	@echo "Checking service health..."
	@docker-compose ps
	@echo ""
	@echo "Testing API Gateway..."
	@curl -s http://localhost:8080/actuator/health || echo "Gateway not responding"
	@echo ""
	@echo "Testing Eureka Server..."
	@curl -s http://localhost:8761/actuator/health || echo "Eureka not responding"

# Run tests
test:
	@echo "Running tests..."
	./mvnw test

# Development environment
dev:
	@echo "Starting development environment..."
	docker-compose -f docker-compose.dev.yml up -d
	@echo "Development environment started!"
	@echo "pgAdmin: http://localhost:5050 (admin@calculatrice.local / admin)"

# Production environment
prod:
	@echo "Starting production environment..."
	docker-compose up -d --build
	@echo "Production environment started!"

