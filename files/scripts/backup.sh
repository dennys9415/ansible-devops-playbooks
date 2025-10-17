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

BACKUP_DIR="${1:-/var/backups}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

log_info "Starting backup process..."

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup system configuration
log_info "Backing up system configuration..."
tar -czf "$BACKUP_DIR/system-config-$TIMESTAMP.tar.gz" \
    /etc/ssh/ \
    /etc/nginx/ \
    /etc/postgresql/ \
    /etc/prometheus/ \
    2>/dev/null || log_warning "Some configuration files might be missing"

# Backup PostgreSQL databases
if command -v pg_dump &> /dev/null; then
    log_info "Backing up PostgreSQL databases..."
    sudo -u postgres pg_dumpall > "$BACKUP_DIR/postgresql-full-$TIMESTAMP.sql"
    log_success "PostgreSQL backup completed"
else
    log_warning "PostgreSQL not found, skipping database backup"
fi

# Backup application data
if [ -d "/opt/application" ]; then
    log_info "Backing up application data..."
    tar -czf "$BACKUP_DIR/application-data-$TIMESTAMP.tar.gz" /opt/application/
    log_success "Application data backup completed"
fi

# Clean up old backups
log_info "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR" -name "*.sql" -type f -mtime +$RETENTION_DAYS -delete

log_success "Backup process completed successfully!"
echo "Backup files created in: $BACKUP_DIR"
ls -la "$BACKUP_DIR"/*"$TIMESTAMP"*