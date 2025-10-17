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

VAULT_PASSWORD_FILE="vault-password-file"

# Function to display usage
usage() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  encrypt <file>          Encrypt a file with Ansible Vault"
    echo "  decrypt <file>          Decrypt a file with Ansible Vault"
    echo "  view <file>             View encrypted file content"
    echo "  edit <file>             Edit encrypted file"
    echo "  rekey <file>            Change vault password for a file"
    echo "  create <file>           Create new encrypted file"
    echo "  list                    List all encrypted files"
    echo ""
    echo "Options:"
    echo "  --vault-password-file   Specify vault password file (default: vault-password-file)"
    exit 1
}

# Check if vault password file exists
check_vault_file() {
    if [ ! -f "$VAULT_PASSWORD_FILE" ]; then
        log_error "Vault password file '$VAULT_PASSWORD_FILE' not found"
        log_info "Create one with: echo 'your-password' > $VAULT_PASSWORD_FILE"
        log_info "Or use --ask-vault-pass instead"
        exit 1
    fi
}

# Encrypt a file
encrypt_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        log_error "File '$file' not found"
        exit 1
    fi
    
    check_vault_file
    log_info "Encrypting file: $file"
    ansible-vault encrypt "$file" --vault-password-file "$VAULT_PASSWORD_FILE"
    log_success "File encrypted: $file"
}

# Decrypt a file
decrypt_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        log_error "File '$file' not found"
        exit 1
    fi
    
    check_vault_file
    log_info "Decrypting file: $file"
    ansible-vault decrypt "$file" --vault-password-file "$VAULT_PASSWORD_FILE"
    log_success "File decrypted: $file"
}

# View encrypted file
view_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        log_error "File '$file' not found"
        exit 1
    fi
    
    check_vault_file
    log_info "Viewing file: $file"
    ansible-vault view "$file" --vault-password-file "$VAULT_PASSWORD_FILE"
}

# Edit encrypted file
edit_file() {
    local file=$1
    check_vault_file
    log_info "Editing file: $file"
    ansible-vault edit "$file" --vault-password-file "$VAULT_PASSWORD_FILE"
}

# Rekey encrypted file
rekey_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        log_error "File '$file' not found"
        exit 1
    fi
    
    check_vault_file
    log_info "Rekeying file: $file"
    ansible-vault rekey "$file" --vault-password-file "$VAULT_PASSWORD_FILE" --new-vault-password-file "$VAULT_PASSWORD_FILE"
    log_success "File rekeyed: $file"
}

# Create new encrypted file
create_file() {
    local file=$1
    if [ -f "$file" ]; then
        log_warning "File '$file' already exists"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Operation cancelled"
            exit 0
        fi
    fi
    
    check_vault_file
    log_info "Creating new encrypted file: $file"
    ansible-vault create "$file" --vault-password-file "$VAULT_PASSWORD_FILE"
    log_success "File created: $file"
}

# List encrypted files
list_files() {
    log_info "Searching for encrypted files..."
    find . -name "*.yml" -type f | while read -r file; do
        if head -n1 "$file" | grep -q '\$ANSIBLE_VAULT'; then
            echo "🔒 $file"
        fi
    done
}

# Main command handler
case $1 in
    encrypt)
        if [ -z "$2" ]; then
            log_error "No file specified for encryption"
            usage
        fi
        encrypt_file "$2"
        ;;
    decrypt)
        if [ -z "$2" ]; then
            log_error "No file specified for decryption"
            usage
        fi
        decrypt_file "$2"
        ;;
    view)
        if [ -z "$2" ]; then
            log_error "No file specified for viewing"
            usage
        fi
        view_file "$2"
        ;;
    edit)
        if [ -z "$2" ]; then
            log_error "No file specified for editing"
            usage
        fi
        edit_file "$2"
        ;;
    rekey)
        if [ -z "$2" ]; then
            log_error "No file specified for rekeying"
            usage
        fi
        rekey_file "$2"
        ;;
    create)
        if [ -z "$2" ]; then
            log_error "No file specified for creation"
            usage
        fi
        create_file "$2"
        ;;
    list)
        list_files
        ;;
    *)
        log_error "Unknown command: $1"
        usage
        ;;
esac