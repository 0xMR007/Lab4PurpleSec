# Setup Documentation

This directory contains detailed installation and configuration guides for all components of the **Lab4PurpleSec** environment.

## Installation Guides

Follow these guides in the recommended order for a complete lab deployment:

### 1. Prerequisites

**[prereqs.md](prereqs.md)** - Start here!

- Hardware requirements (RAM, CPU, storage)
- Software requirements (hypervisor, ISO images)
- Network segment configuration
- Reference configuration used for testing

### 2. Virtual Machine Installation

**[VMs_installation.md](VMs_installation.md)**

Complete guide for installing all virtual machines:

- WAN segment machines (Kali Linux)
- LAN segment machines (SIEM, test machine, attack machine, GOAD)
- DMZ segment machines (Metasploitable2/3, web server)
- Hardware configurations for each VM
- Post-installation script usage

### 3. Network Infrastructure

**[pfsense_setup.md](pfsense_setup.md)**

pfSense firewall and network configuration:

- Interface configuration (WAN, LAN, DMZ)
- Firewall rules setup
- NAT/port forwarding configuration
- Suricata IDS/IPS installation and configuration
- Optional configuration file import

### 4. Web Services

**[Web_server_setup.md](Web_server_setup.md)**

Vulnerable web applications deployment:

- Docker Compose installation
- Nginx reverse proxy configuration
- OWASP applications (Juice Shop, WebGoat, bWAPP, NodeGoat, VAmPI)
- Virtual host configuration
- Integration with pfSense NAT rules

### 5. Security Monitoring

**[Wazuh_setup.md](Wazuh_setup.md)**

Wazuh SIEM deployment:

- Wazuh Manager installation
- Agent deployment on Linux/Windows machines
- pfSense agent configuration
- Suricata log integration
- Docker container monitoring

### 6. Active Directory Environment

**[GOAD_setup.md](GOAD_setup.md)**

GOAD MINILAB Active Directory setup:

- Vagrant deployment
- Network integration into LAN segment
- Domain controller and workstation configuration
- Security considerations

## Installation Order

For a complete lab setup, follow this sequence:

1. ✅ **Prerequisites** - Verify hardware/software requirements
2. ✅ **VM Installation** - Install all virtual machines
3. ✅ **pfSense Setup** - Configure firewall and network segmentation
4. ✅ **Web Server Setup** - Deploy vulnerable web applications
5. ✅ **Wazuh Setup** - Deploy SIEM and agents
6. ✅ **GOAD Setup** - Deploy Active Directory environment

## Post-Installation

After completing all setup guides:

1. Run verification tests from `../TESTS/` directory
2. Verify network connectivity between all segments
3. Test firewall rules and NAT functionality
4. Confirm all services are accessible
5. Verify log collection in Wazuh

## Troubleshooting

If you encounter issues during setup:

1. Check the relevant setup guide's troubleshooting section
2. Verify prerequisites are met
3. Review network configuration
4. Check firewall rules
5. Consult test documentation in `../TESTS/` for verification steps

## Additional Resources

- **Configuration files**: See `../../CONFIGS/` for example configurations
- **Test procedures**: See `../TESTS/` for verification guides

**Important**: Always change default passwords after installation and never connect these machines to production networks.
