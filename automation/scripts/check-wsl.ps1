# ============================================================================
# Lab4PurpleSec - WSL Compatibility Check Script (PowerShell)
# ============================================================================
# This script checks WSL configuration and provides recommendations
# ============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "WSL Compatibility Check" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if WSL is installed
$wslInstalled = Get-Command wsl -ErrorAction SilentlyContinue

if ($wslInstalled) {
    Write-Host "[+] WSL is installed" -ForegroundColor Green
    Write-Host ""
    Write-Host "If you plan to use Vagrant from WSL:" -ForegroundColor Yellow
    Write-Host "  1. Set environment variable in WSL:"
    Write-Host "     export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1"
    Write-Host "  2. Or use PowerShell/CMD for Vagrant commands (recommended)"
    Write-Host ""
} else {
    Write-Host "[!] WSL is not installed" -ForegroundColor Yellow
    Write-Host "    This is fine if you're using PowerShell/CMD directly"
    Write-Host ""
}

# Check VirtualBox
try {
    $null = Get-Command VBoxManage -ErrorAction Stop
    $vbVersion = VBoxManage --version
    Write-Host "[+] VirtualBox is installed: $vbVersion" -ForegroundColor Green
} catch {
    Write-Host "[!] VirtualBox not found in PATH" -ForegroundColor Red
    Write-Host "    Please install VirtualBox: https://www.virtualbox.org/wiki/Downloads"
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "For more help, see: automation/TROUBLESHOOTING.md" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

