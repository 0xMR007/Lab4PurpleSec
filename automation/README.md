# Lab4PurpleSec Automation

> **⚠️ Security Warning**: This lab contains intentionally vulnerable services. **Never** connect these machines to a production network. Always change default passwords after installation. This environment is designed for isolated, educational use only.

> **Note**: This is a V1. Feedback and contributions welcome.

This directory contains Vagrant and Ansible automation scripts for semi-automated deployment of the **Lab4PurpleSec** environment.

## Overview

The automation system provides a streamlined way to provision and configure most internal VMs in the lab. However, some components still require manual installation and configuration for educational purposes and due to technical limitations.

## What is Automated

The following VMs are automatically provisioned and configured:

- **LAN-SIEM-LIN** (192.168.10.104): Ubuntu 22.04 with Wazuh Manager
- **LAN-TEST-LIN** (192.168.10.100): Ubuntu 22.04 Desktop with GUI
- **LAN-ATTACK-LIN** (192.168.10.109): Kali Linux attack machine (LAN segment)
- **WAN-ATTACK-LIN** (DHCP): Kali Linux attack machine (WAN segment, bridged)
- **DMZ-WEB01-LIN** (192.168.20.105): Debian 12 web server with Docker and Nginx (not configured)

**Automated configurations:**

- Base system setup (packages, users, network configuration)
- Wazuh Manager installation and configuration
- Desktop GUI environment (for LAN-TEST-LIN)
- Common tools and utilities
- SSH key management
- Hosts file configuration

## What Requires Manual Setup

The following components must be installed and configured manually:

### 1. pfSense Firewall (FW-PFSENSE)

- Manual installation from ISO image
- Interface configuration (WAN, LAN, DMZ)
- Firewall rules setup
- NAT/port forwarding configuration
- **Suricata IDS/IPS** installation and configuration

**See:** `../docs/SETUP/pfsense_setup.md`

### 2. Wazuh Agents

- Manual installation on Windows machines (LAN-DC01-WIN, LAN-WS01-WIN)
- Manual installation and configuration on pfSense
- Agent enrollment and configuration

**See:** `../docs/SETUP/Wazuh_setup.md`

### 3. Web Server (DMZ-WEB01-LIN)

- Docker Compose installation
- Nginx reverse proxy configuration
- Vulnerable web applications deployment (OWASP Juice Shop, WebGoat, etc.)

**Note:** DMZ-WEB01-LIN is provisioned by Vagrant but requires manual Docker Compose setup.

**See:** `../docs/SETUP/Web_server_setup.md`

### 4. External VMs

These VMs are managed by external repositories and must be deployed separately:

- **GOAD MINILAB** (LAN-DC01-WIN, LAN-WS01-WIN)

  - Repository: https://github.com/Orange-Cyberdefense/GOAD
  - Launch: `cd <GOAD_REPO> && py goad.py -m vm`
  - Network: Configure to use 'lab-lan' internal network

- **Metasploitable3** (DMZ-MS3-LIN, DMZ-MS3-WIN)

  - Repository: https://github.com/rapid7/metasploitable3
  - Launch: `cd <MS3_REPO> && vagrant up`
  - Network: Configure to use 'lab-dmz' internal network

- **Metasploitable2** (DMZ-MS2-LIN)
  - Download: https://www.rapid7.com/products/metasploit/metasploitable/
  - Manual: Open VMX file in VirtualBox/VMware
  - Network: Configure to use 'lab-dmz' internal network

**See:** `../docs/SETUP/GOAD_setup.md`

## Prerequisites

Before using the automation scripts, ensure you have:

1. **VirtualBox** or **VMware Workstation/Player** installed
2. **Vagrant** installed (version 2.2+)
   - Download: https://www.vagrantup.com/downloads
3. **Ansible** installed (optional, for manual playbook execution)
   - On Linux/macOS: `sudo apt install ansible` or `brew install ansible`
   - On Windows: Use WSL or install via pip
4. **Sufficient system resources:**
   - RAM: At least 16GB recommended (8GB minimum)
   - CPU: Multi-core processor recommended
   - Disk: At least 50GB free space

## Quick Start

### 1. Navigate to Automation Directory

```bash
cd automation
```

### 2. Start VMs with Vagrant

```bash
# Start all VMs
vagrant up

# Start specific VM
vagrant up lan-siem-lin

# Check status
vagrant status

# SSH into a VM
vagrant ssh lan-siem-lin
```

### 3. Verify Provisioning

After VMs are up, verify that Ansible provisioning completed successfully:

```bash
# Check Ansible logs (if provisioning was enabled)
vagrant ssh lan-siem-lin -c "sudo journalctl -u ansible-pull || echo 'Ansible logs not available'"

# Or manually run Ansible playbooks
cd ansible
ansible-playbook -i inventory-vagrant.py playbooks/site.yml
```

### 4. Manual Configuration Steps

After automated provisioning, complete the manual setup:

1. **Install and configure pfSense** (see `../Docs/SETUP/pfsense_setup.md`)
2. **Configure Suricata on pfSense**
3. **Set up web server** on DMZ-WEB01-LIN (see `../Docs/SETUP/Web_server_setup.md`)
4. **Deploy GOAD MINILAB** (see `../Docs/SETUP/GOAD_setup.md`)
5. **Deploy Metasploitable2/3** VMs
6. **Install Wazuh agents** on Windows machines and pfSense

## Directory Structure

```
automation/
├── README.md              # This file
├── Vagrantfile            # Vagrant configuration for VM provisioning
├── vagrant-config.yml     # Vagrant configuration values
├── inventory.yml          # Ansible inventory file
├── ansible/               # Ansible playbooks and roles
│   ├── README.md          # Ansible-specific documentation
│   ├── README.md          # Ansible documentation
│   ├── playbooks/         # Ansible playbooks
│   │   ├── site.yml       # Main playbook
│   │   ├── base-setup.yml # Base system configuration
│   │   └── applications.yml # Application-specific configuration
│   ├── roles/             # Ansible roles
│   │   ├── common/        # Common tasks (packages, users)
│   │   ├── linux-base/    # Linux base configuration
│   │   ├── wazuh/         # Wazuh Manager installation
│   │   ├── desktop-gui/   # Desktop GUI setup
│   │   └── ...
│   └── group_vars/        # Group variables
│   └── host_vars/         # Host-specific variables
├── scripts/               # Helper scripts
│   ├── bootstrap-ansible.sh  # Ansible installation script
│   ├── init.sh            # Initialization script
│   └── ...
└── deps/                  # Dependency information
```

## Configuration

### Environment Variables

You can customize the deployment using environment variables:

```bash
# Change provider (default: virtualbox)
export VAGRANT_PROVIDER=vmware_desktop
vagrant up

# Change default memory
export VAGRANT_MEMORY=4096
vagrant up

# Disable Ansible provisioning (if needed)
export VAGRANT_ANSIBLE=false
vagrant up

# Enable verbose Ansible output
export VAGRANT_ANSIBLE_VERBOSE=true
vagrant up
```

### Network Configuration

The automation uses the following network segments:

- **WAN**: Bridged network (connects to host network)
- **LAN**: Internal network `lab-lan` (192.168.10.0/24)
- **DMZ**: Internal network `lab-dmz` (192.168.20.0/24)

These networks are automatically created by Vagrant. Ensure pfSense is configured to use the same network segments.

## Troubleshooting

### VMs Not Starting

```bash
# Check Vagrant status
vagrant status

# Check VirtualBox/VMware logs
# VirtualBox: Check VM logs in VirtualBox GUI
# VMware: Check logs in VMware Workstation

# Destroy and recreate
vagrant destroy
vagrant up
```

### Ansible Provisioning Issues

```bash
# Check if Ansible is installed in VM
vagrant ssh <vm-name> -c "ansible --version"

# Manually run Ansible playbooks
cd ansible
ansible-playbook -i inventory-vagrant.py playbooks/site.yml -v

# Check Ansible logs
tail -f ansible.log
```

### Network Connectivity Issues

```bash
# Test connectivity from host
ping 192.168.10.104  # LAN-SIEM-LIN

# Test from VM
vagrant ssh lan-siem-lin
ping 192.168.10.1    # Should reach pfSense (if configured)

# Check network configuration
ip addr show
```

### Windows-Specific Issues

On Windows, Ansible provisioning is disabled by default. To enable:

```bash
# Use WSL (recommended)
wsl
cd /mnt/<drive>/<path>/Lab4PurpleSec/automation
vagrant up

# Or enable Ansible explicitly
$env:VAGRANT_ANSIBLE="true"
vagrant up
```

## Advanced Usage

### Running Ansible Manually

If you prefer to run Ansible playbooks manually:

```bash
cd ansible

# Using dynamic inventory (recommended)
ansible-playbook -i inventory-vagrant.py playbooks/site.yml

# Using static inventory
ansible-playbook -i ../inventory.yml playbooks/site.yml

# Run specific playbook
ansible-playbook -i inventory-vagrant.py playbooks/base-setup.yml

# Run on specific host
ansible-playbook -i inventory-vagrant.py playbooks/site.yml --limit lan-siem-lin
```

### Customizing VM Resources

Edit the `Vagrantfile` to customize memory, CPU, or other VM settings:

```ruby
INTERNAL_VMS = {
  "lan-siem-lin" => {
    :memory => 8192,  # Increase memory
    :cpus => 4,        # Increase CPUs
    # ...
  }
}
```

### Adding New VMs

To add a new VM to the automation:

1. Add VM definition to `INTERNAL_VMS` in `Vagrantfile`
2. Create Ansible host variables in `ansible/host_vars/`
3. Add to Ansible inventory if needed
4. Create or assign appropriate Ansible roles

## Integration with Manual Components

After automated provisioning, integrate with manually configured components:

1. **pfSense**: Ensure firewall rules allow communication with automated VMs
2. **Wazuh**: Configure agents on automated VMs to connect to Wazuh Manager
3. **GOAD**: Ensure GOAD VMs are on the same LAN network segment
4. **Metasploitable**: Ensure MS2/3 VMs are on the same DMZ network segment

## Documentation

- **Main README**: `../README.md`
- **Architecture**: `../ARCHITECTURE.md`
- **Inventory**: `../INVENTORY.md`
- **Setup Guides**: `../docs/SETUP/`
- **Ansible Documentation**: `ansible/README.md`
- **Ansible Documentation**: `ansible/README.md`

## Support

For issues or questions:

1. Check the troubleshooting section above
2. Review the detailed setup guides in `../docs/SETUP/`
3. Check Ansible logs: `ansible/ansible.log`
4. Open an issue on the project repository

## Notes

- **pfSense must be started first** before other VMs to provide routing
- **Network segments** must match between Vagrant configuration and pfSense setup
- **Wazuh Manager** is automatically installed on LAN-SIEM-LIN, but agents must be manually configured
- **DMZ-WEB01-LIN** is provisioned but requires manual Docker Compose setup
- **External VMs** (GOAD, Metasploitable) are not managed by this automation

---

**Last Updated:** V1 - Semi-automated deployment with Vagrant and Ansible
