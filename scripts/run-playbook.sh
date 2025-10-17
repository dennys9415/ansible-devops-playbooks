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

# Default values
ENVIRONMENT="development"
PLAYBOOK="base-provisioning.yml"
VAULT_PASSWORD_FILE="vault-password-file"
EXTRA_ARGS=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
        ENVIRONMENT="$2"
        shift
        shift
        ;;
        -p|--playbook)
        PLAYBOOK="$2"
        shift
        shift
        ;;
        --vault-password-file)
        VAULT_PASSWORD_FILE="$2"
        shift
        shift
        ;;
        --check)
        EXTRA_ARGS="$EXTRA_ARGS --check"
        shift
        ;;
        --diff)
        EXTRA_ARGS="$EXTRA_ARGS --diff"
        shift
        ;;
        --tags)
        EXTRA_ARGS="$EXTRA_ARGS --tags $2"
        shift
        shift
        ;;
        --skip-tags)
        EXTRA_ARGS="$EXTRA_ARGS --skip-tags $2"
        shift
        shift
        ;;
        *)
        EXTRA_ARGS="$EXTRA_ARGS $1"
        shift
        ;;
    esac
done

# Validate environment
if [ ! -f "inventory/$ENVIRONMENT/hosts" ]; then
    log_error "Environment '$ENVIRONMENT' not found. Available environments:"
    ls -d inventory/*/ | cut -d'/' -f2
    exit 1
fi

# Validate playbook
if [ ! -f "playbooks/$PLAYBOOK" ]; then
    log_error "Playbook '$PLAYBOOK' not found. Available playbooks:"
    ls playbooks/*.yml | xargs -n 1 basename
    exit 1
fi

# Check vault password file
if [ ! -f "$VAULT_PASSWORD_FILE" ]; then
    log_warning "Vault password file '$VAULT_PASSWORD_FILE' not found"
    VAULT_ARGS="--ask-vault-pass"
else
    VAULT_ARGS="--vault-password-file $VAULT_PASSWORD_FILE"
fi

log_info "Running playbook: $PLAYBOOK"
log_info "Environment: $ENVIRONMENT"
log_info "Inventory: inventory/$ENVIRONMENT/hosts"

# Run the playbook
ansible-playbook \
    -i "inventory/$ENVIRONMENT/hosts" \
    playbooks/$PLAYBOOK \
    $VAULT_ARGS \
    $EXTRA_ARGS

if [ $? -eq 0 ]; then
    log_success "Playbook execution completed successfully!"
else
    log_error "Playbook execution failed!"
    exit 1
fi