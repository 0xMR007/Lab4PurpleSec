#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Initialization Script (Linux)
# ============================================================================
# This script performs initial setup tasks for the automation environment.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "Lab4PurpleSec - Initialization Script"
echo "=========================================="
echo ""

# Check prerequisites
echo "[*] Checking prerequisites..."

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    echo "[!] ERROR: Vagrant is not installed."
    echo "    Please install Vagrant: https://www.vagrantup.com/downloads"
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "[!] ERROR: Ansible is not installed."
    echo "    Please install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/index.html"
    exit 1
fi

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    echo "[!] WARNING: VirtualBox is not installed or not in PATH."
    echo "    Please install VirtualBox: https://www.virtualbox.org/wiki/Downloads"
    echo "    Continuing anyway..."
fi

echo "[+] Prerequisites check passed."
echo ""

# Display information
echo "=========================================="
echo "Automation Directory: $AUTOMATION_DIR"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Review automation/README.md"
echo "  2. Review automation/ORCHESTRATION.md"
echo "  3. Configure external VMs (GOAD, Metasploitable3) if needed"
echo "  4. Run: cd automation && vagrant up"
echo ""

