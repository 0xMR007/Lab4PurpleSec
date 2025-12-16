#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Ansible Runner Script
# ============================================================================
# This script helps run Ansible playbooks with the correct inventory
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

cd "$SCRIPT_DIR"

# Check if inventory-vagrant.py exists and is executable
if [ -f "inventory-vagrant.py" ] && [ -x "inventory-vagrant.py" ]; then
    INVENTORY="inventory-vagrant.py"
    echo "Using dynamic Vagrant inventory: inventory-vagrant.py"
else
    INVENTORY="../inventory.yml"
    echo "Using static inventory: ../inventory.yml"
    echo "Note: For better compatibility with Vagrant port forwarding,"
    echo "      consider using inventory-vagrant.py (make it executable: chmod +x)"
fi

# Run ansible-playbook with provided arguments
ansible-playbook -i "$INVENTORY" "$@"

