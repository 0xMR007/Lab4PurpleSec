#!/bin/bash
# ============================================================================
# Bootstrap Script for Ansible Installation
# ============================================================================
# This script prepares the VM for ansible_local provisioning by installing
# Ansible and its dependencies via apt (not pip) to avoid PEP 668 issues.
#
# Compatible with:
# - Debian 12 (Bookworm)
# - Ubuntu 22.04+ (Jammy)
# - Kali Linux 2024.x
#
# Usage:
#   sudo ./bootstrap-ansible.sh
#   Or via Vagrant: vagrant provision --provision-with bootstrap-ansible
# ============================================================================

set -euo pipefail

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR_DISTRO=1
readonly EXIT_ERROR_ROOT=2
readonly EXIT_ERROR_ANSIBLE=3

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        VERSION=$VERSION_ID
        VERSION_CODENAME=${VERSION_CODENAME:-unknown}
    else
        log_error "Cannot detect distribution"
        exit $EXIT_ERROR_DISTRO
    fi
}

# Check if Ansible is already installed
check_ansible_installed() {
    if command -v ansible &> /dev/null && command -v ansible-playbook &> /dev/null; then
        ANSIBLE_VERSION=$(ansible --version | head -n1)
        log_info "Ansible is already installed: $ANSIBLE_VERSION"
        return 0
    else
        return 1
    fi
}

# Install Ansible via apt (Debian/Ubuntu)
install_ansible_debian() {
    log_info "Installing Ansible via apt for Debian/Ubuntu (${VERSION_CODENAME})..."
    
    # Export DEBIAN_FRONTEND to avoid interactive prompts
    export DEBIAN_FRONTEND=noninteractive
    
    # Update package list
    log_info "Updating package lists..."
    apt-get update -qq || {
        log_error "Failed to update package lists"
        exit $EXIT_ERROR_ANSIBLE
    }
    
    # Install prerequisites
    log_info "Installing prerequisites..."
    apt-get install -y -qq \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        python3 \
        python3-pip \
        python3-apt \
        sudo \
        openssh-server \
        git \
        curl \
        wget 2>&1 | grep -v "^debconf: " || true
    
    # Detect if Ubuntu or Debian
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        IS_UBUNTU=false
        if [ "$ID" = "ubuntu" ]; then
            IS_UBUNTU=true
        fi
    else
        IS_UBUNTU=false
    fi
    
    # Add Ansible repository (only if not already present)
    if [ ! -f /etc/apt/sources.list.d/ansible.list ]; then
        log_info "Adding Ansible official repository..."
        
        if [ "$IS_UBUNTU" = true ] && command -v add-apt-repository &> /dev/null; then
            # Ubuntu: Use PPA (preferred method)
            log_info "Using PPA for Ubuntu..."
            add-apt-repository -y ppa:ansible/ansible 2>&1 | grep -v "^debconf: " || {
                log_warn "PPA method failed, trying manual repository..."
                echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ansible.list
                # Use newer method for key management (avoid apt-key deprecation)
                curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x93C4A3FD7BB9C367" | gpg --dearmor -o /etc/apt/trusted.gpg.d/ansible.gpg 2>/dev/null || {
                    log_warn "Failed to add GPG key, will try installing from main repository"
                    rm -f /etc/apt/sources.list.d/ansible.list
                }
            }
        else
            # Debian: Try using Ubuntu focal repository
            log_info "Using Ubuntu PPA repository for Debian..."
            echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" > /etc/apt/sources.list.d/ansible.list
            curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x93C4A3FD7BB9C367" | gpg --dearmor -o /etc/apt/trusted.gpg.d/ansible.gpg 2>/dev/null || {
                # Alternative: Try installing from Debian backports or main repo
                log_warn "Repository key addition failed, trying Debian main repository..."
                # Debian 12 has ansible in main repository
                rm -f /etc/apt/sources.list.d/ansible.list
                rm -f /etc/apt/trusted.gpg.d/ansible.gpg
            }
        fi
        
        # Update package list after adding repository
        apt-get update -qq 2>&1 | grep -v "^debconf: " || true
    fi
    
    # Install Ansible
    if ! command -v ansible &> /dev/null; then
        log_info "Installing Ansible..."
        # Try PPA first, then fallback to main repository
        if apt-get install -y -qq ansible 2>&1 | grep -v "^debconf: "; then
            log_info "Ansible installed successfully from repository"
        else
            log_warn "Ansible not found in PPA, trying main repository..."
            # For Debian, ansible might be in main repo
            if apt-get install -y -qq ansible-core 2>&1 | grep -v "^debconf: "; then
                log_info "Ansible Core installed successfully"
                # Also install ansible for full functionality
                apt-get install -y -qq ansible 2>&1 | grep -v "^debconf: " || true
            else
                log_error "Failed to install Ansible. Please check your repositories."
                exit $EXIT_ERROR_ANSIBLE
            fi
        fi
    else
        log_info "Ansible is already installed: $(ansible --version | head -n1)"
    fi
}

# Install Ansible via apt (Kali Linux)
install_ansible_kali() {
    log_info "Installing Ansible via apt for Kali Linux..."
    
    # Export DEBIAN_FRONTEND to avoid interactive prompts
    export DEBIAN_FRONTEND=noninteractive
    
    # Update package list
    log_info "Updating package lists..."
    apt-get update -qq 2>&1 | grep -v "^debconf: " || true
    
    # Install prerequisites
    log_info "Installing prerequisites..."
    apt-get install -y -qq \
        python3 \
        python3-pip \
        python3-apt \
        sudo \
        openssh-server \
        git \
        curl \
        wget 2>&1 | grep -v "^debconf: " || true
    
    # Kali has Ansible in main repository (no PPA needed)
    if ! command -v ansible &> /dev/null; then
        log_info "Installing Ansible from Kali repositories..."
        apt-get install -y -qq ansible 2>&1 | grep -v "^debconf: " || {
            log_warn "Full ansible package not found, installing ansible-core..."
            apt-get install -y -qq ansible-core 2>&1 | grep -v "^debconf: " || {
                log_error "Failed to install Ansible"
                exit $EXIT_ERROR_ANSIBLE
            }
        }
    else
        log_info "Ansible is already installed: $(ansible --version | head -n1)"
    fi
}

# Main installation function
main() {
    log_info "============================================================"
    log_info "Lab4PurpleSec - Ansible Bootstrap"
    log_info "============================================================"
    log_info "Starting Ansible bootstrap for ansible_local..."
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root (use sudo)"
        exit $EXIT_ERROR_ROOT
    fi
    
    # Detect distribution
    detect_distro
    log_info "Detected distribution: $DISTRO $VERSION ($VERSION_CODENAME)"
    
    # Check if Ansible is already installed (skip if present)
    if check_ansible_installed; then
        log_info "Ansible is already installed, skipping installation"
        log_info "Bootstrap completed successfully (no changes needed)!"
        exit $EXIT_SUCCESS
    fi
    
    # Install Ansible based on distribution
    log_info "Ansible not found, proceeding with installation..."
    case "$DISTRO" in
        debian|ubuntu)
            install_ansible_debian
            ;;
        kali)
            install_ansible_kali
            ;;
        *)
            log_warn "Unknown distribution: $DISTRO"
            log_info "Attempting Debian/Ubuntu installation method..."
            install_ansible_debian
            ;;
    esac
    
    # Verify installation
    if command -v ansible &> /dev/null; then
        ANSIBLE_VERSION=$(ansible --version | head -n1)
        log_info "Ansible successfully installed: $ANSIBLE_VERSION"
        
        # Verify ansible-playbook
        if command -v ansible-playbook &> /dev/null; then
            log_info "ansible-playbook is available"
        else
            log_error "ansible-playbook not found!"
            exit $EXIT_ERROR_ANSIBLE
        fi
        
        # Display Ansible configuration
        log_info "Ansible configuration:"
        ansible --version | head -n 5
    else
        log_error "Ansible installation failed!"
        exit $EXIT_ERROR_ANSIBLE
    fi
    
    log_info "============================================================"
    log_info "Bootstrap completed successfully!"
    log_info "============================================================"
}

# Run main function
main "$@"

