# ============================================================================
# Lab4PurpleSec - Fix Guest Additions Script (PowerShell)
# ============================================================================
# This script helps fix VirtualBox Guest Additions issues
# ============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Guest Additions Fix Helper" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

Push-Location $AutomationDir

Write-Host "Options:" -ForegroundColor Yellow
Write-Host "  1. Disable vagrant-vbguest plugin (recommended)"
Write-Host "  2. Show Guest Additions status for all VMs"
Write-Host "  3. Manual Guest Additions installation instructions"
Write-Host ""

$choice = Read-Host "Choose option (1-3)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "[*] Checking if vagrant-vbguest is installed..." -ForegroundColor Yellow
        
        $plugins = vagrant plugin list
        if ($plugins -match "vagrant-vbguest") {
            Write-Host "[!] vagrant-vbguest plugin is installed" -ForegroundColor Yellow
            Write-Host ""
            $uninstall = Read-Host "Uninstall vagrant-vbguest plugin? (y/N)"
            if ($uninstall -eq "y" -or $uninstall -eq "Y") {
                vagrant plugin uninstall vagrant-vbguest
                Write-Host "[+] Plugin uninstalled" -ForegroundColor Green
            } else {
                Write-Host "[*] Plugin kept. Guest Additions auto-update is disabled in Vagrantfile." -ForegroundColor Yellow
            }
        } else {
            Write-Host "[+] vagrant-vbguest plugin is not installed" -ForegroundColor Green
            Write-Host "[+] Guest Additions auto-update is disabled in Vagrantfile" -ForegroundColor Green
        }
        Write-Host ""
        Write-Host "[+] Guest Additions warnings can be safely ignored" -ForegroundColor Green
        Write-Host "    VMs will work fine without matching Guest Additions" -ForegroundColor Green
    }
    "2" {
        Write-Host ""
        Write-Host "[*] Checking Guest Additions status..." -ForegroundColor Yellow
        Write-Host ""
        
        $vms = @("dmz-web01-lin", "lan-siem-lin", "lan-test-lin", "lan-attack-lin", "wan-attack-lin")
        foreach ($vm in $vms) {
            $status = vagrant status $vm 2>&1
            if ($status -match "running") {
                Write-Host "=== $vm ===" -ForegroundColor Cyan
                vagrant ssh $vm -c "VBoxControl --version 2>/dev/null || echo 'Guest Additions not installed or not running'" 2>&1 | Out-String
                Write-Host ""
            } else {
                Write-Host "=== $vm ===" -ForegroundColor Cyan
                Write-Host "VM is not running"
                Write-Host ""
            }
        }
    }
    "3" {
        Write-Host ""
        Write-Host "Manual Guest Additions Installation:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "1. SSH into the VM:"
        Write-Host "   vagrant ssh <vm-name>"
        Write-Host ""
        Write-Host "2. Install kernel headers:"
        Write-Host "   sudo apt-get update"
        Write-Host "   sudo apt-get install -y linux-headers-`$(uname -r) build-essential dkms"
        Write-Host ""
        Write-Host "3. In VirtualBox GUI:"
        Write-Host "   - Select VM → Devices → Insert Guest Additions CD image"
        Write-Host ""
        Write-Host "4. In VM terminal:"
        Write-Host "   sudo mount /dev/cdrom /mnt"
        Write-Host "   sudo /mnt/VBoxLinuxAdditions.run"
        Write-Host "   sudo reboot"
        Write-Host ""
        Write-Host "Note: Guest Additions are optional. VMs work fine without them." -ForegroundColor Yellow
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

Pop-Location

