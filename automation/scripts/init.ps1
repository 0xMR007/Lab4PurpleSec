# ============================================================================
# Lab4PurpleSec - Initialization Script (Windows PowerShell)
# ============================================================================
# This script performs initial setup tasks for the automation environment.
# ============================================================================

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Lab4PurpleSec - Initialization Script" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check prerequisites
Write-Host "[*] Checking prerequisites..." -ForegroundColor Yellow

# Check if Vagrant is installed
try {
    $null = Get-Command vagrant -ErrorAction Stop
    Write-Host "[+] Vagrant is installed." -ForegroundColor Green
} catch {
    Write-Host "[!] ERROR: Vagrant is not installed." -ForegroundColor Red
    Write-Host "    Please install Vagrant: https://www.vagrantup.com/downloads" -ForegroundColor Yellow
    exit 1
}

# Check if Ansible is installed
try {
    $null = Get-Command ansible -ErrorAction Stop
    Write-Host "[+] Ansible is installed." -ForegroundColor Green
} catch {
    Write-Host "[!] ERROR: Ansible is not installed." -ForegroundColor Red
    Write-Host "    Please install Ansible: https://docs.ansible.com/ansible/latest/installation_guide/index.html" -ForegroundColor Yellow
    exit 1
}

# Check if VirtualBox is installed
try {
    $null = Get-Command VBoxManage -ErrorAction Stop
    Write-Host "[+] VirtualBox is installed." -ForegroundColor Green
} catch {
    Write-Host "[!] WARNING: VirtualBox is not installed or not in PATH." -ForegroundColor Yellow
    Write-Host "    Please install VirtualBox: https://www.virtualbox.org/wiki/Downloads" -ForegroundColor Yellow
    Write-Host "    Continuing anyway..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Automation Directory: $AutomationDir" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review automation/README.md"
Write-Host "  2. Review automation/ORCHESTRATION.md"
Write-Host "  3. Configure external VMs (GOAD, Metasploitable3) if needed"
Write-Host "  4. Run: cd automation; vagrant up"
Write-Host ""

