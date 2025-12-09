# Test Documentation

This directory contains verification and testing procedures to ensure your **Lab4PurpleSec** environment is properly configured and operational.

## Test Guides

Each test guide provides step-by-step procedures to verify specific components of the lab:

### Network and Firewall Tests

**[pfSense.md](pfSense.md)**

Verification procedures for:

- Network connectivity between segments (WAN, LAN, DMZ)
- NAT/port forwarding functionality
- Suricata IDS/IPS detection capabilities
- Firewall rule enforcement

### Web Services Tests

**[Web_server.md](Web_server.md)**

Verification procedures for:

- Docker container status
- Nginx reverse proxy functionality
- Access to vulnerable web applications (Juice Shop, WebGoat, bWAPP, etc.)
- Virtual host routing
- Integration with pfSense NAT

### Security Monitoring Tests

**[Wazuh.md](Wazuh.md)**

Verification procedures for:

- Wazuh agent connectivity
- Log collection from various sources
- Event correlation and alerting
- Integration with Suricata
- SSH brute-force detection testing

### Active Directory Tests

**[GOAD-MINILAB.md](GOAD-MINILAB.md)**

Verification procedures for:

- System information and domain integration
- Network connectivity (internal and external)
- Domain authentication (successful and failed)
- Active Directory service status (DNS, Kerberos, LDAP, Netlogon)
- Share access (SYSVOL, NETLOGON)
- Wazuh log forwarding from AD machines

## Testing Workflow

Recommended testing sequence:

1. **Network Tests** (`pfSense.md`) - Verify basic connectivity
2. **Web Server Tests** (`Web_server.md`) - Verify web services
3. **Wazuh Tests** (`Wazuh.md`) - Verify monitoring
4. **GOAD Tests** (`GOAD-MINILAB.md`) - Verify Active Directory

## Test Prerequisites

Before running tests, ensure:

- ✅ All VMs are installed and running
- ✅ pfSense is configured and accessible
- ✅ Network segments are properly configured
- ✅ All services are installed and started
- ✅ Firewall rules are in place

## Expected Results

Each test guide includes:

- **Expected results** for each test
- **Screenshots** showing successful verification
- **Troubleshooting tips** for common issues
- **Next steps** if tests fail

## Test Environment

Tests are designed to be run from:

- **LAN-TEST-LIN** - Primary test machine
- **LAN-ATTACK-LIN** - Attack machine for security testing
- **WAN-ATTACK-LIN** - External attack simulation

## Security Note

These tests include:

- ✅ Legitimate connectivity tests
- ✅ Service verification
- ⚠️ **Simulated attacks** (brute-force, scanning) - Only for testing detection capabilities

All tests are designed for isolated lab environments. Never run these tests against production systems.

## Contributing

If you discover additional test scenarios or improvements:

1. Document the test procedure
2. Include screenshots
3. Submit a pull request

**Remember**: These tests verify that your lab is properly configured. If tests fail, review the corresponding setup guide in `../SETUP/`.
