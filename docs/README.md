# Lab4PurpleSec Documentation

> **Note**: The screenshots in this documentation are in French, while the documentation itself is written in English (blame past-me, not current-me).

Welcome to the **Lab4PurpleSec** documentation directory. This directory contains comprehensive guides for setting up, configuring, and testing your cybersecurity homelab environment.

## Documentation Structure

This directory is organized into two main sections:

### 📚 SETUP/

The `SETUP/` directory contains detailed installation and configuration guides for all components of the Lab4PurpleSec environment:

- **[prereqs.md](SETUP/prereqs.md)** - Hardware and software requirements, ISO images needed
- **[VMs_installation.md](SETUP/VMs_installation.md)** - Step-by-step VM installation guides
- **[pfsense_setup.md](SETUP/pfsense_setup.md)** - pfSense firewall configuration and Suricata IDS/IPS setup
- **[Web_server_setup.md](SETUP/Web_server_setup.md)** - Docker Compose and Nginx reverse proxy configuration
- **[Wazuh_setup.md](SETUP/Wazuh_setup.md)** - Wazuh SIEM installation and agent deployment
- **[GOAD_setup.md](SETUP/GOAD_setup.md)** - GOAD MINILAB Active Directory environment deployment

### 🧪 TESTS/

The `TESTS/` directory contains verification and testing procedures to ensure your lab is properly configured:

- **[Web_server.md](TESTS/Web_server.md)** - Web server and Docker container verification tests
- **[pfSense.md](TESTS/pfSense.md)** - Network connectivity, NAT, and Suricata IDS/IPS tests
- **[Wazuh.md](TESTS/Wazuh.md)** - Wazuh agent connectivity and log collection verification
- **[GOAD-MINILAB.md](TESTS/GOAD-MINILAB.md)** - Active Directory functionality and integration tests

## Getting Started

1. **Start with prerequisites**: Read `SETUP/prereqs.md` to understand hardware/software requirements
2. **Install VMs**: Follow `SETUP/VMs_installation.md` to set up all virtual machines
3. **Configure network**: Use `SETUP/pfsense_setup.md` to configure the firewall
4. **Deploy services**: Follow the remaining setup guides in order (Suricata, Web server, Wazuh, GOAD)
5. **Verify installation**: Run tests from `TESTS/` directory to confirm everything works

## Additional Resources

- **Main README**: See the root `README.md` for project overview and quick start
- **Architecture**: See `ARCHITECTURE.md` for network topology and design
- **Inventory**: See `INVENTORY.md` for complete VM and service listings

## Contributing

If you find errors, have suggestions, or want to improve the documentation, please:

1. Open an issue on the repository
2. Submit a pull request with your improvements
3. Follow the existing documentation style and format

**Note**: This documentation assumes you are working in an isolated lab environment. Never connect these vulnerable machines to production networks.
