#!/bin/bash
# ============================================================================
# Lab4PurpleSec - External Repositories Bootstrap Script
# ============================================================================
# This script provides instructions and optional cloning for external
# repositories (GOAD, Metasploitable3).
#
# NOTE: This script does NOT automatically launch external VMs.
#       It only provides instructions and optional cloning.
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"
DEPS_DIR="$AUTOMATION_DIR/deps"

echo "=========================================="
echo "Lab4PurpleSec - External Repos Bootstrap"
echo "=========================================="
echo ""

# Create deps directory if it doesn't exist
mkdir -p "$DEPS_DIR"

echo "This script helps you set up external repositories for:"
echo "  - GOAD (Game Of Active Directory)"
echo "  - Metasploitable3"
echo ""
echo "These repositories are NOT managed by this automation."
echo "They must be launched separately using their own procedures."
echo ""

# Function to display instructions for GOAD
show_goad_instructions() {
    echo "=========================================="
    echo "GOAD (Game Of Active Directory)"
    echo "=========================================="
    echo ""
    echo "Repository: https://github.com/Orange-Cyberdefense/GOAD"
    echo ""
    echo "Installation steps:"
    echo "  1. Clone the repository:"
    echo "     git clone https://github.com/Orange-Cyberdefense/GOAD.git"
    echo ""
    echo "  2. Install dependencies (see GOAD documentation)"
    echo ""
    echo "  3. Deploy MINILAB:"
    echo "     cd GOAD"
    echo "     py goad.py -m vm"
    echo ""
    echo "  4. Configure network cards for LAN integration (see ORCHESTRATION.md)"
    echo ""
    echo "Documentation: https://orange-cyberdefense.github.io/GOAD/installation/"
    echo ""
}

# Function to display instructions for Metasploitable3
show_ms3_instructions() {
    echo "=========================================="
    echo "Metasploitable3"
    echo "=========================================="
    echo ""
    echo "Repository: https://github.com/rapid7/metasploitable3"
    echo ""
    echo "Installation steps:"
    echo "  1. Clone the repository:"
    echo "     git clone https://github.com/rapid7/metasploitable3.git"
    echo ""
    echo "  2. Deploy VMs:"
    echo "     cd metasploitable3"
    echo "     vagrant up"
    echo ""
    echo "  3. Configure network cards for DMZ integration (see ORCHESTRATION.md)"
    echo ""
    echo "Documentation: https://github.com/rapid7/metasploitable3"
    echo ""
}

# Check if --auto flag is provided
AUTO_MODE=false
if [[ "$1" == "--auto" ]]; then
    AUTO_MODE=true
fi

# GOAD
echo "Do you want to clone GOAD repository? (y/N)"
if [[ "$AUTO_MODE" == true ]]; then
    CLONE_GOAD="n"
else
    read -r CLONE_GOAD
fi

if [[ "$CLONE_GOAD" =~ ^[Yy]$ ]]; then
    if [ -d "$DEPS_DIR/GOAD" ]; then
        echo "[!] GOAD directory already exists. Skipping clone."
    else
        echo "[*] Cloning GOAD repository..."
        git clone https://github.com/Orange-Cyberdefense/GOAD.git "$DEPS_DIR/GOAD"
        echo "[+] GOAD repository cloned to $DEPS_DIR/GOAD"
    fi
else
    show_goad_instructions
fi

echo ""

# Metasploitable3
echo "Do you want to clone Metasploitable3 repository? (y/N)"
if [[ "$AUTO_MODE" == true ]]; then
    CLONE_MS3="n"
else
    read -r CLONE_MS3
fi

if [[ "$CLONE_MS3" =~ ^[Yy]$ ]]; then
    if [ -d "$DEPS_DIR/metasploitable3" ]; then
        echo "[!] Metasploitable3 directory already exists. Skipping clone."
    else
        echo "[*] Cloning Metasploitable3 repository..."
        git clone https://github.com/rapid7/metasploitable3.git "$DEPS_DIR/metasploitable3"
        echo "[+] Metasploitable3 repository cloned to $DEPS_DIR/metasploitable3"
    fi
else
    show_ms3_instructions
fi

echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""
echo "External repositories are located in: $DEPS_DIR"
echo ""
echo "To launch external VMs, follow the instructions in:"
echo "  - automation/ORCHESTRATION.md"
echo ""
echo "IMPORTANT: External VMs must be launched BEFORE or AFTER"
echo "           internal VMs, depending on dependencies."
echo "           See ORCHESTRATION.md for the recommended order."
echo ""

