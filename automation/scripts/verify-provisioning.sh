#!/bin/bash
# ============================================================================
# Lab4PurpleSec - Provisioning Verification Script
# ============================================================================
# This script verifies that the Ansible provisioning completed successfully
# by checking for expected configurations, services, and packages.
#
# Usage:
#   ./verify-provisioning.sh [hostname]
#   Or via Vagrant: vagrant ssh dmz-web01-lin -c "/vagrant/scripts/verify-provisioning.sh"
# ============================================================================

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Get hostname
HOSTNAME=${1:-$(hostname)}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
    ((TESTS_PASSED++))
    ((TESTS_TOTAL++))
}

log_failure() {
    echo -e "${RED}[✗]${NC} $1"
    ((TESTS_FAILED++))
    ((TESTS_TOTAL++))
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_header() {
    echo ""
    echo "============================================================"
    echo "$1"
    echo "============================================================"
}

# Test if command exists
check_command() {
    local cmd=$1
    local description=${2:-$cmd}
    
    if command -v "$cmd" &> /dev/null; then
        log_success "$description is installed"
        return 0
    else
        log_failure "$description is NOT installed"
        return 1
    fi
}

# Test if service is running
check_service() {
    local service=$1
    local description=${2:-$service}
    
    if systemctl is-active --quiet "$service" 2>/dev/null; then
        log_success "$description service is running"
        return 0
    else
        log_failure "$description service is NOT running"
        return 1
    fi
}

# Test if file or directory exists
check_path() {
    local path=$1
    local description=${2:-$path}
    
    if [ -e "$path" ]; then
        log_success "$description exists"
        return 0
    else
        log_failure "$description does NOT exist"
        return 1
    fi
}

# Test if port is listening
check_port() {
    local port=$1
    local description=${2:-port $port}
    
    if ss -tuln | grep -q ":$port " 2>/dev/null || netstat -tuln 2>/dev/null | grep -q ":$port "; then
        log_success "$description is listening"
        return 0
    else
        log_failure "$description is NOT listening"
        return 1
    fi
}

# ============================================================================
# Common Tests (All Hosts)
# ============================================================================
test_common() {
    log_header "Common Configuration Tests"
    
    # Check basic packages
    check_command "python3" "Python 3"
    check_command "git" "Git"
    check_command "curl" "cURL"
    check_command "wget" "Wget"
    
    # Check SSH
    check_service "ssh" "SSH"
    check_port 22 "SSH port 22"
    
    # Check hosts file configuration
    if grep -q "192.168.10.1" /etc/hosts 2>/dev/null; then
        log_success "/etc/hosts contains LAN gateway entry"
    else
        log_warn "/etc/hosts does not contain LAN gateway entry"
    fi
}

# ============================================================================
# DMZ Web Server Tests (dmz-web01-lin)
# ============================================================================
test_dmz_web01() {
    log_header "DMZ Web Server Tests (dmz-web01-lin)"
    
    # Check Docker
    check_command "docker" "Docker"
    check_service "docker" "Docker"
    
    # Check Docker Compose
    check_command "docker-compose" "Docker Compose" || check_command "docker" "Docker Compose (via docker compose plugin)"
    
    # Check web directories
    check_path "/opt/webapps" "Web applications directory"
    check_path "/vagrant" "Vagrant shared directory"
    
    # Check if Docker is functional
    if docker ps &> /dev/null; then
        log_success "Docker is functional"
    else
        log_failure "Docker is NOT functional"
    fi
    
    # Check Docker containers (if any)
    local container_count=$(docker ps -q | wc -l)
    if [ "$container_count" -gt 0 ]; then
        log_info "Found $container_count running Docker container(s)"
    else
        log_warn "No Docker containers running (this may be normal)"
    fi
}

# ============================================================================
# LAN SIEM Tests (lan-siem-lin)
# ============================================================================
test_lan_siem() {
    log_header "LAN SIEM Tests (lan-siem-lin)"
    
    # Check Wazuh services
    check_service "wazuh-manager" "Wazuh Manager" || log_warn "Wazuh Manager not installed yet (Phase E)"
    check_service "wazuh-indexer" "Wazuh Indexer" || log_warn "Wazuh Indexer not installed yet (Phase E)"
    check_service "wazuh-dashboard" "Wazuh Dashboard" || log_warn "Wazuh Dashboard not installed yet (Phase E)"
    
    # Check Wazuh ports
    check_port 1514 "Wazuh Agent communication (TCP 1514)" || log_warn "Wazuh not configured yet"
    check_port 1515 "Wazuh Agent enrollment (TCP 1515)" || log_warn "Wazuh not configured yet"
    check_port 55000 "Wazuh API (TCP 55000)" || log_warn "Wazuh not configured yet"
    check_port 443 "Wazuh Dashboard (HTTPS)" || log_warn "Wazuh Dashboard not configured yet"
}

# ============================================================================
# Attack Machine Tests (lan-attack-lin, wan-attack-lin)
# ============================================================================
test_attack_machine() {
    log_header "Attack Machine Tests"
    
    # Check Kali tools (common)
    check_command "nmap" "Nmap"
    check_command "metasploit-framework" "Metasploit Framework" || check_command "msfconsole" "Metasploit Framework"
    check_command "sqlmap" "SQLMap" || log_warn "SQLMap not installed (may be normal)"
    check_command "burpsuite" "Burp Suite" || log_warn "Burp Suite not installed (may be normal)"
    
    # Check network tools
    check_command "netcat" "Netcat" || check_command "nc" "Netcat"
    check_command "tcpdump" "TCPDump"
    check_command "wireshark" "Wireshark" || log_warn "Wireshark not installed (GUI tool)"
}

# ============================================================================
# Main Function
# ============================================================================
main() {
    log_header "Lab4PurpleSec - Provisioning Verification"
    log_info "Hostname: $HOSTNAME"
    log_info "Distribution: $(lsb_release -d 2>/dev/null | cut -f2- || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    log_info "Kernel: $(uname -r)"
    
    # Run common tests
    test_common
    
    # Run host-specific tests based on hostname
    case "$HOSTNAME" in
        dmz-web01-lin|DMZ-WEB01-LIN)
            test_dmz_web01
            ;;
        lan-siem-lin|LAN-SIEM-LIN)
            test_lan_siem
            ;;
        lan-attack-lin|LAN-ATTACK-LIN|wan-attack-lin|WAN-ATTACK-LIN)
            test_attack_machine
            ;;
        lan-test-lin|LAN-TEST-LIN)
            log_info "Test machine - running common tests only"
            ;;
        *)
            log_warn "Unknown hostname: $HOSTNAME"
            log_info "Running common tests only"
            ;;
    esac
    
    # Summary
    log_header "Test Summary"
    echo ""
    echo "Total tests: $TESTS_TOTAL"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo ""
    
    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "All tests passed!"
        exit 0
    else
        log_failure "$TESTS_FAILED test(s) failed"
        log_info "This may be normal if provisioning is incomplete"
        exit 1
    fi
}

# Run main function
main "$@"

