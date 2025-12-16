#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Vagrant Helper Scripts
# ============================================================================
# Helper functions for managing Vagrant VMs and external dependencies
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_info() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# ============================================================================
# External VMs Information
# ============================================================================

show_external_vms() {
    print_header "External VMs Information"
    echo ""
    echo "The following VMs are NOT managed by this Vagrantfile:"
    echo ""
    echo "1. GOAD MINILAB (LAN-DC01-WIN, LAN-WS01-WIN)"
    echo "   Repository: https://github.com/Orange-Cyberdefense/GOAD"
    echo "   Launch: cd <GOAD_REPO> && py goad.py -m vm"
    echo "   See: automation/ORCHESTRATION.md"
    echo ""
    echo "2. Metasploitable3 (DMZ-MS3-LIN, DMZ-MS3-WIN)"
    echo "   Repository: https://github.com/rapid7/metasploitable3"
    echo "   Launch: cd <MS3_REPO> && vagrant up"
    echo "   See: automation/ORCHESTRATION.md"
    echo ""
    echo "3. Metasploitable2 (DMZ-MS2-LIN)"
    echo "   Download: https://www.rapid7.com/products/metasploit/metasploitable/"
    echo "   Manual: Open VMX file in VirtualBox/VMware"
    echo "   See: automation/ORCHESTRATION.md"
    echo ""
    echo "4. pfSense (FW-PFSENSE)"
    echo "   Manual installation from ISO"
    echo "   See: automation/ORCHESTRATION.md and ../docs/SETUP/pfsense_setup.md"
    echo ""
}

# ============================================================================
# Network Information
# ============================================================================

show_network_info() {
    print_header "Network Configuration"
    echo ""
    echo "Internal Networks (VirtualBox):"
    echo "  - lab-lan:  192.168.10.0/24 (LAN segment)"
    echo "  - lab-dmz:  192.168.20.0/24 (DMZ segment)"
    echo ""
    echo "Gateway IPs:"
    echo "  - LAN Gateway:  192.168.10.1 (pfSense)"
    echo "  - DMZ Gateway:  192.168.20.1 (pfSense)"
    echo ""
    echo "VM IP Addresses:"
    echo "  Internal VMs (managed by this Vagrantfile):"
    echo "    - DMZ-WEB01-LIN:  192.168.20.105"
    echo "    - LAN-SIEM-LIN:   192.168.10.104"
    echo "    - LAN-TEST-LIN:   192.168.10.100"
    echo "    - LAN-ATTACK-LIN: 192.168.10.109"
    echo "    - WAN-ATTACK-LIN: DHCP (bridged)"
    echo ""
    echo "  External VMs (see ORCHESTRATION.md):"
    echo "    - LAN-DC01-WIN:  192.168.10.30 (GOAD)"
    echo "    - LAN-WS01-WIN:  192.168.10.31 (GOAD)"
    echo "    - DMZ-MS2-LIN:   192.168.20.104 (Manual)"
    echo "    - DMZ-MS3-LIN:   192.168.20.106 (Metasploitable3)"
    echo "    - DMZ-MS3-WIN:   192.168.20.107 (Metasploitable3)"
    echo ""
}

# ============================================================================
# Status Check
# ============================================================================

check_status() {
    print_header "Lab Status Check"
    echo ""
    
    cd "$AUTOMATION_DIR"
    
    print_info "Checking internal VMs status..."
    vagrant status
    
    echo ""
    print_warning "Remember to check external VMs status separately:"
    echo "  - GOAD: Check in GOAD repository directory"
    echo "  - Metasploitable3: Check in Metasploitable3 repository directory"
    echo "  - pfSense: Check in VirtualBox/VMware directly"
    echo ""
}

# ============================================================================
# Quick Commands
# ============================================================================

case "${1:-}" in
    "external")
        show_external_vms
        ;;
    "network")
        show_network_info
        ;;
    "status")
        check_status
        ;;
    "help"|"--help"|"-h"|"")
        echo "Lab4PurpleSec - Vagrant Helper Scripts"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  external  - Show external VMs information"
        echo "  network   - Show network configuration"
        echo "  status    - Check status of internal VMs"
        echo "  help      - Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 external    # Show external VMs info"
        echo "  $0 network     # Show network configuration"
        echo "  $0 status      # Check VM status"
        ;;
    *)
        print_error "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

