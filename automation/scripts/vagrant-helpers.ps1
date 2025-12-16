# ============================================================================
# Lab4PurpleSec - Vagrant Helper Scripts (PowerShell)
# ============================================================================
# Helper functions for managing Vagrant VMs and external dependencies
# ============================================================================

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

# ============================================================================
# Helper Functions
# ============================================================================

function Print-Header {
    param([string]$Text)
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host $Text -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}

function Print-Info {
    param([string]$Text)
    Write-Host "[*] $Text" -ForegroundColor Green
}

function Print-Warning {
    param([string]$Text)
    Write-Host "[!] $Text" -ForegroundColor Yellow
}

function Print-Error {
    param([string]$Text)
    Write-Host "[ERROR] $Text" -ForegroundColor Red
}

# ============================================================================
# External VMs Information
# ============================================================================

function Show-ExternalVMs {
    Print-Header "External VMs Information"
    Write-Host ""
    Write-Host "The following VMs are NOT managed by this Vagrantfile:"
    Write-Host ""
    Write-Host "1. GOAD MINILAB (LAN-DC01-WIN, LAN-WS01-WIN)"
    Write-Host "   Repository: https://github.com/Orange-Cyberdefense/GOAD"
    Write-Host "   Launch: cd <GOAD_REPO> && py goad.py -m vm"
    Write-Host "   See: automation/ORCHESTRATION.md"
    Write-Host ""
    Write-Host "2. Metasploitable3 (DMZ-MS3-LIN, DMZ-MS3-WIN)"
    Write-Host "   Repository: https://github.com/rapid7/metasploitable3"
    Write-Host "   Launch: cd <MS3_REPO> && vagrant up"
    Write-Host "   See: automation/ORCHESTRATION.md"
    Write-Host ""
    Write-Host "3. Metasploitable2 (DMZ-MS2-LIN)"
    Write-Host "   Download: https://www.rapid7.com/products/metasploit/metasploitable/"
    Write-Host "   Manual: Open VMX file in VirtualBox/VMware"
    Write-Host "   See: automation/ORCHESTRATION.md"
    Write-Host ""
    Write-Host "4. pfSense (FW-PFSENSE)"
    Write-Host "   Manual installation from ISO"
    Write-Host "   See: automation/ORCHESTRATION.md and ../docs/SETUP/pfsense_setup.md"
    Write-Host ""
}

# ============================================================================
# Network Information
# ============================================================================

function Show-NetworkInfo {
    Print-Header "Network Configuration"
    Write-Host ""
    Write-Host "Internal Networks (VirtualBox):"
    Write-Host "  - lab-lan:  192.168.10.0/24 (LAN segment)"
    Write-Host "  - lab-dmz:  192.168.20.0/24 (DMZ segment)"
    Write-Host ""
    Write-Host "Gateway IPs:"
    Write-Host "  - LAN Gateway:  192.168.10.1 (pfSense)"
    Write-Host "  - DMZ Gateway:  192.168.20.1 (pfSense)"
    Write-Host ""
    Write-Host "VM IP Addresses:"
    Write-Host "  Internal VMs (managed by this Vagrantfile):"
    Write-Host "    - DMZ-WEB01-LIN:  192.168.20.105"
    Write-Host "    - LAN-SIEM-LIN:   192.168.10.104"
    Write-Host "    - LAN-TEST-LIN:   192.168.10.100"
    Write-Host "    - LAN-ATTACK-LIN: 192.168.10.109"
    Write-Host "    - WAN-ATTACK-LIN: DHCP (bridged)"
    Write-Host ""
    Write-Host "  External VMs (see ORCHESTRATION.md):"
    Write-Host "    - LAN-DC01-WIN:  192.168.10.30 (GOAD)"
    Write-Host "    - LAN-WS01-WIN:  192.168.10.31 (GOAD)"
    Write-Host "    - DMZ-MS2-LIN:   192.168.20.104 (Manual)"
    Write-Host "    - DMZ-MS3-LIN:   192.168.20.106 (Metasploitable3)"
    Write-Host "    - DMZ-MS3-WIN:   192.168.20.107 (Metasploitable3)"
    Write-Host ""
}

# ============================================================================
# Status Check
# ============================================================================

function Check-Status {
    Print-Header "Lab Status Check"
    Write-Host ""
    
    Push-Location $AutomationDir
    
    try {
        Print-Info "Checking internal VMs status..."
        vagrant status
    } finally {
        Pop-Location
    }
    
    Write-Host ""
    Print-Warning "Remember to check external VMs status separately:"
    Write-Host "  - GOAD: Check in GOAD repository directory"
    Write-Host "  - Metasploitable3: Check in Metasploitable3 repository directory"
    Write-Host "  - pfSense: Check in VirtualBox/VMware directly"
    Write-Host ""
}

# ============================================================================
# Main
# ============================================================================

switch ($Command.ToLower()) {
    "external" {
        Show-ExternalVMs
    }
    "network" {
        Show-NetworkInfo
    }
    "status" {
        Check-Status
    }
    "help" {
        Write-Host "Lab4PurpleSec - Vagrant Helper Scripts"
        Write-Host ""
        Write-Host "Usage: .\vagrant-helpers.ps1 [command]"
        Write-Host ""
        Write-Host "Commands:"
        Write-Host "  external  - Show external VMs information"
        Write-Host "  network   - Show network configuration"
        Write-Host "  status    - Check status of internal VMs"
        Write-Host "  help      - Show this help message"
        Write-Host ""
        Write-Host "Examples:"
        Write-Host "  .\vagrant-helpers.ps1 external    # Show external VMs info"
        Write-Host "  .\vagrant-helpers.ps1 network     # Show network configuration"
        Write-Host "  .\vagrant-helpers.ps1 status      # Check VM status"
    }
    default {
        Print-Error "Unknown command: $Command"
        Write-Host "Use '.\vagrant-helpers.ps1 help' for usage information"
        exit 1
    }
}

