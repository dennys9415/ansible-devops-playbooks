#!/bin/bash

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# Function to check service status
check_service() {
    local service_name=$1
    if systemctl is-active --quiet "$service_name"; then
        log_success "Service $service_name is running"
        return 0
    else
        log_error "Service $service_name is not running"
        return 1
    fi
}

# Function to check port listening
check_port() {
    local port=$1
    local service=$2
    if netstat -tuln | grep ":$port " > /dev/null; then
        log_success "Port $port ($service) is listening"
        return 0
    else
        log_error "Port $port ($service) is not listening"
        return 1
    fi
}

# Function to check disk usage
check_disk() {
    local threshold=${1:-80}
    local usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$usage" -lt "$threshold" ]; then
        log_success "Disk usage: $usage% (below $threshold%)"
        return 0
    else
        log_warning "Disk usage: $usage% (above $threshold%)"
        return 1
    fi
}

# Function to check memory usage
check_memory() {
    local threshold=${1:-80}
    local usage=$(free | awk 'NR==2{printf "%.0f", $3*100/$2}')
    if [ "$usage" -lt "$threshold" ]; then
        log_success "Memory usage: $usage% (below $threshold%)"
        return 0
    else
        log_warning "Memory usage: $usage% (above $threshold%)"
        return 1
    fi
}

log_info "Starting health check..."

# Check system services
check_service "nginx"
check_service "postgresql"
check_service "prometheus"
check_service "docker"

# Check network ports
check_port 80 "HTTP"
check_port 443 "HTTPS"
check_port 5432 "PostgreSQL"
check_port 9090 "Prometheus"
check_port 3000 "Grafana"

# Check system resources
check_disk 85
check_memory 90

# Check application health
if command -v curl &> /dev/null; then
    if curl -f http://localhost:8080/health > /dev/null 2>&1; then
        log_success "Application health check passed"
    else
        log_warning "Application health check failed"
    fi
fi

log_info "Health check completed!"