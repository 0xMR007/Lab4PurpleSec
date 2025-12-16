#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Fix Guest Additions Script
# ============================================================================
# This script helps fix VirtualBox Guest Additions issues
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

echo "=========================================="
echo "Guest Additions Fix Helper"
echo "=========================================="
echo ""

cd "$AUTOMATION_DIR"

echo "Options:"
echo "  1. Disable vagrant-vbguest plugin (recommended)"
echo "  2. Show Guest Additions status for all VMs"
echo "  3. Manual Guest Additions installation instructions"
echo ""

read -p "Choose option (1-3): " choice

case $choice in
    1)
        echo ""
        echo "[*] Checking if vagrant-vbguest is installed..."
        if vagrant plugin list | grep -q vagrant-vbguest; then
            echo "[!] vagrant-vbguest plugin is installed"
            echo ""
            read -p "Uninstall vagrant-vbguest plugin? (y/N): " uninstall
            if [[ "$uninstall" =~ ^[Yy]$ ]]; then
                vagrant plugin uninstall vagrant-vbguest
                echo "[+] Plugin uninstalled"
            else
                echo "[*] Plugin kept. Guest Additions auto-update is disabled in Vagrantfile."
            fi
        else
            echo "[+] vagrant-vbguest plugin is not installed"
            echo "[+] Guest Additions auto-update is disabled in Vagrantfile"
        fi
        echo ""
        echo "[+] Guest Additions warnings can be safely ignored"
        echo "    VMs will work fine without matching Guest Additions"
        ;;
    2)
        echo ""
        echo "[*] Checking Guest Additions status..."
        echo ""
        for vm in dmz-web01-lin lan-siem-lin lan-test-lin lan-attack-lin wan-attack-lin; do
            if vagrant status "$vm" | grep -q "running"; then
                echo "=== $vm ==="
                vagrant ssh "$vm" -c "VBoxControl --version 2>/dev/null || echo 'Guest Additions not installed or not running'" 2>/dev/null || echo "VM not accessible"
                echo ""
            else
                echo "=== $vm ==="
                echo "VM is not running"
                echo ""
            fi
        done
        ;;
    3)
        echo ""
        echo "Manual Guest Additions Installation:"
        echo ""
        echo "1. SSH into the VM:"
        echo "   vagrant ssh <vm-name>"
        echo ""
        echo "2. Install kernel headers:"
        echo "   sudo apt-get update"
        echo "   sudo apt-get install -y linux-headers-\$(uname -r) build-essential dkms"
        echo ""
        echo "3. In VirtualBox GUI:"
        echo "   - Select VM → Devices → Insert Guest Additions CD image"
        echo ""
        echo "4. In VM terminal:"
        echo "   sudo mount /dev/cdrom /mnt"
        echo "   sudo /mnt/VBoxLinuxAdditions.run"
        echo "   sudo reboot"
        echo ""
        echo "Note: Guest Additions are optional. VMs work fine without them."
        ;;
    *)
        echo "[!] Invalid option"
        exit 1
        ;;
esac

echo ""
echo "=========================================="
echo "For more help, see: automation/TROUBLESHOOTING.md"
echo "=========================================="

