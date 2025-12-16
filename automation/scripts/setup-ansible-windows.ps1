# ============================================================================
# Lab4PurpleSec - Ansible Setup for Windows
# ============================================================================
# This script helps configure Ansible on Windows or provides alternatives
# ============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Ansible Setup for Windows" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Windows is not officially supported as Ansible Control Machine." -ForegroundColor Yellow
Write-Host ""

Write-Host "Options:" -ForegroundColor Yellow
Write-Host "  1. Use WSL for Ansible (Recommended)"
Write-Host "  2. Set UTF-8 encoding in PowerShell (may work)"
Write-Host "  3. Disable Ansible provisioning (boot VMs only)"
Write-Host "  4. Run Ansible manually from WSL after booting VMs"
Write-Host ""

$choice = Read-Host "Choose option (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Using WSL for Ansible:" -ForegroundColor Green
        Write-Host ""
        Write-Host "1. Open WSL terminal"
        Write-Host "2. Install Ansible:"
        Write-Host "   sudo apt update"
        Write-Host "   sudo apt install -y ansible"
        Write-Host ""
        Write-Host "3. Set UTF-8 locale:"
        Write-Host "   export LC_ALL=en_US.UTF-8"
        Write-Host "   export LANG=en_US.UTF-8"
        Write-Host "   echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc"
        Write-Host "   echo 'export LANG=en_US.UTF-8' >> ~/.bashrc"
        Write-Host ""
        Write-Host "4. Navigate to automation directory:"
        Write-Host "   cd /mnt/<drive>/<path>/Lab4PurpleSec/automation"
        Write-Host "   # Replace <drive> and <path> with your actual project location"
        Write-Host ""
        Write-Host "5. Boot VMs (without Ansible from PowerShell):"
        Write-Host "   # In PowerShell:"
        Write-Host "   `$env:VAGRANT_ANSIBLE = 'false'"
        Write-Host "   vagrant up"
        Write-Host ""
        Write-Host "6. Run Ansible from WSL:"
        Write-Host "   # In WSL:"
        Write-Host "   cd ansible"
        Write-Host "   ansible-playbook -i ../inventory.yml playbooks/site.yml"
        Write-Host ""
    }
    "2" {
        Write-Host ""
        Write-Host "Setting UTF-8 encoding in PowerShell:" -ForegroundColor Green
        Write-Host ""
        Write-Host "Run these commands in PowerShell:"
        Write-Host ""
        Write-Host '[Console]::OutputEncoding = [System.Text.Encoding]::UTF8' -ForegroundColor Cyan
        Write-Host '$env:PYTHONIOENCODING = "utf-8"' -ForegroundColor Cyan
        Write-Host '$env:LC_ALL = "en_US.UTF-8"' -ForegroundColor Cyan
        Write-Host '$env:LANG = "en_US.UTF-8"' -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Then try: vagrant provision"
        Write-Host ""
        Write-Host "Note: This may not work reliably. WSL is recommended." -ForegroundColor Yellow
        Write-Host ""
    }
    "3" {
        Write-Host ""
        Write-Host "Disabling Ansible provisioning:" -ForegroundColor Green
        Write-Host ""
        Write-Host "VMs will boot without Ansible configuration."
        Write-Host "You can configure them manually or use Ansible later from WSL."
        Write-Host ""
        Write-Host "Run in PowerShell:" -ForegroundColor Cyan
        Write-Host '$env:VAGRANT_ANSIBLE = "false"' -ForegroundColor Cyan
        Write-Host 'vagrant up' -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Or edit Vagrantfile and change:" -ForegroundColor Yellow
        Write-Host "  ANSIBLE_ENABLED = false"
        Write-Host ""
    }
    "4" {
        Write-Host ""
        Write-Host "Manual Ansible execution:" -ForegroundColor Green
        Write-Host ""
        Write-Host "1. Boot VMs without Ansible (in PowerShell):"
        Write-Host "   `$env:VAGRANT_ANSIBLE = 'false'" -ForegroundColor Cyan
        Write-Host "   vagrant up" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "2. Install Ansible in WSL:"
        Write-Host "   sudo apt update && sudo apt install -y ansible" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "3. Run Ansible from WSL:"
        Write-Host "   cd automation/ansible" -ForegroundColor Cyan
        Write-Host "   ansible-playbook -i ../inventory.yml playbooks/site.yml" -ForegroundColor Cyan
        Write-Host ""
    }
    default {
        Write-Host "[!] Invalid option" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "For more help, see: automation/TROUBLESHOOTING.md" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

