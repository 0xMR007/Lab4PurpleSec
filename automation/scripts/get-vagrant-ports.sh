#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Get Vagrant SSH Ports
# ============================================================================
# This script extracts SSH ports from vagrant ssh-config
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATION_DIR="$(dirname "$SCRIPT_DIR")"

cd "$AUTOMATION_DIR"

echo "=========================================="
echo "Vagrant SSH Port Mapping"
echo "=========================================="
echo ""

echo "Getting SSH configuration from Vagrant..."
echo ""

vagrant ssh-config 2>/dev/null | awk '
BEGIN {
    current_host = ""
}
/Host / {
    current_host = $2
}
/Port / {
    if (current_host != "") {
        printf "%-20s %s:%s\n", current_host, "127.0.0.1", $2
    }
}
' | grep -E "(dmz-web01-lin|lan-siem-lin|lan-test-lin|lan-attack-lin|wan-attack-lin)"

echo ""
echo "=========================================="
echo "Use these ports in inventory-vagrant.yml"
echo "=========================================="



