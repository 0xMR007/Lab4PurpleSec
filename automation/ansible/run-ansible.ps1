# ============================================================================
# Lab4PurpleSec - Ansible Runner Script (PowerShell)
# ============================================================================
# This script helps run Ansible playbooks with the correct inventory
# ============================================================================

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$AutomationDir = Split-Path -Parent $ScriptDir

Set-Location $ScriptDir

# Check if inventory-vagrant.py exists
if (Test-Path "inventory-vagrant.py") {
    $Inventory = "inventory-vagrant.py"
    Write-Host "Using dynamic Vagrant inventory: inventory-vagrant.py"
} else {
    $Inventory = "../inventory.yml"
    Write-Host "Using static inventory: ../inventory.yml"
    Write-Host "Note: For better compatibility with Vagrant port forwarding,"
    Write-Host "      consider using inventory-vagrant.py"
}

# Run ansible-playbook with provided arguments
$argsString = $args -join " "
Invoke-Expression "ansible-playbook -i $Inventory $argsString"

