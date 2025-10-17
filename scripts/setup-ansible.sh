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

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    log_error "Please do not run this script as root"
    exit 1
fi

log_info "Setting up Ansible development environment..."

# Update package list
log_info "Updating package list..."
sudo apt update

# Install Python and pip
log_info "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Create virtual environment
log_info "Creating Python virtual environment..."
python3 -m venv ~/ansible-venv
source ~/ansible-venv/bin/activate

# Install Ansible
log_info "Installing Ansible and dependencies..."
pip install --upgrade pip
pip install ansible ansible-lint yamllint molecule molecule-docker docker

# Install Ansible Galaxy roles
log_info "Installing Ansible Galaxy roles..."
ansible-galaxy install -r requirements.yml

# Create necessary directories
log_info "Creating directory structure..."
mkdir -p ~/.ansible/roles
mkdir -p ~/.ansible/facts

# Configure git for the project
log_info "Configuring Git hooks..."
cp .git/hooks/pre-commit.sample .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# Create vault password file example
log_info "Creating vault password file example..."
if [ ! -f vault-password-file.example ]; then
    echo "ChangeThisPasswordInProduction" > vault-password-file.example
    log_warning "Created vault-password-file.example - update with your actual password"
fi

# Test installation
log_info "Testing Ansible installation..."
ansible --version
ansible-lint --version
molecule --version

log_success "Ansible environment setup completed!"
echo ""
log_info "Next steps:"
echo "1. Update vault-password-file with your actual password"
echo "2. Configure inventory files for your environments"
echo "3. Run: ansible-playbook -i inventory/development/hosts playbooks/base-provisioning.yml --syntax-check"
echo "4. Run: ansible-lint playbooks/ roles/"