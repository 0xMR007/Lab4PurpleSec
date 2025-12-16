#!/bin/bash
# ============================================================================
# Lab4PurpleSec - WSL Compatibility Check Script
# ============================================================================
# This script checks if the environment is WSL and provides recommendations
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "WSL Compatibility Check"
echo "=========================================="
echo ""

# Check if running in WSL
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
    echo "[!] WSL detected"
    echo ""
    echo "VirtualBox may have issues when run from WSL on Windows."
    echo ""
    echo "Recommendations:"
    echo "  1. Use Windows PowerShell/CMD instead of WSL for Vagrant commands"
    echo "  2. Or set environment variable: export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1"
    echo "  3. See automation/TROUBLESHOOTING.md for details"
    echo ""
    
    # Check if environment variable is set
    if [ -z "$VAGRANT_WSL_ENABLE_WINDOWS_ACCESS" ]; then
        echo "[!] VAGRANT_WSL_ENABLE_WINDOWS_ACCESS is not set"
        echo "    Consider adding to ~/.bashrc:"
        echo "    export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1"
        echo ""
    else
        echo "[+] VAGRANT_WSL_ENABLE_WINDOWS_ACCESS is set"
        echo ""
    fi
    
    # Check if VirtualBox is accessible
    if command -v VBoxManage &> /dev/null; then
        echo "[+] VirtualBox is accessible"
        VBoxManage --version
    else
        echo "[!] VirtualBox not found in PATH"
        echo "    Try: export PATH=\"\$PATH:/mnt/c/Program Files/Oracle/VirtualBox\""
        echo ""
    fi
else
    echo "[+] Not running in WSL - no special configuration needed"
    echo ""
fi

echo "=========================================="
echo "For more help, see: automation/TROUBLESHOOTING.md"
echo "=========================================="

