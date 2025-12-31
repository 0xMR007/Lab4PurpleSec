# Lab4PurpleSec - VM Orchestration Guide

> **⚠️ Security Warning**: This lab contains intentionally vulnerable services. **Never** connect these machines to a production network. Always change default passwords after installation. This environment is designed for isolated, educational use only.

> **📜 License Notice**: The use of this project (including for CTFs, commercial projects, training, or any other purpose) is subject to the terms and conditions of the MIT License. See `LICENSE` for full details. For more information, see the [License section](../README.md#license) in the main README.

> **Note**: This is a V1. Feedback and contributions are welcome.

## Overview

This document describes how to orchestrate the deployment of all VMs in the **Lab4PurpleSec** environment, including both automated VMs (managed by this Vagrantfile) and external VMs (managed by other repositories or manual installation).

## Prerequisites

> **Note**: For detailed hardware requirements and license information, see the main [README.md](../README.md#prerequisites).

**Quick Summary:**

- **Minimum:** 16 GB RAM, 4-core CPU, 150 GB storage (limited scenarios)
- **Recommended:** 32 GB RAM, 6+ core CPU, 200+ GB storage (full lab experience)
- **Optimal:** 64 GB RAM, 8+ core CPU, 500+ GB storage (maximum performance)

**Important:** You don't need to run all VMs simultaneously - scenarios are designed to be executed step-by-step. RAM is the most important resource to consider here (for virtualisation, CPU/GPU power is not as important as RAM).

### VirtualBox Configuration

#### VM Installation Directory

VMs created by Vagrant are installed in VirtualBox's default machine directory:

- **Windows:** `C:\Users\<username>\VirtualBox VMs\`
- **Linux/macOS:** `~/VirtualBox VMs/`

**Customizing the Installation Directory:**

You can change the default VirtualBox machine directory:

1. Open VirtualBox
2. Go to `File > Settings > General`
3. Set "Default Machine Folder" to your preferred location
4. Ensure you have sufficient disk space at the new location

**Note:** The directory must be accessible and have write permissions. For large deployments, consider using a drive with more free space.

#### VirtualBox Services

**IMPORTANT:** Before deploying VMs, ensure VirtualBox services are running:

1. **Launch VirtualBox GUI** - This ensures all VirtualBox services are started

**Common Issues:**

- If Vagrant fails to start VMs, launch VirtualBox GUI first
- On Windows, ensure VirtualBox is installed with administrator privileges
- If you see "VBoxManage not found" errors, verify VirtualBox executable is in your PATH
- Restart VirtualBox services if VMs fail to start: Close VirtualBox completely and reopen it

**Troubleshooting VirtualBox Services:**

```bash
# Check VirtualBox installation
VBoxManage --version

# List running VMs
VBoxManage list runningvms

# If services are not running, launch VirtualBox GUI
# On Windows: Start VirtualBox from Start Menu
# On Linux: virtualbox (from terminal)
# On macOS: Open VirtualBox from Applications
```

## Pre-Deployment Checklist

Before starting the deployment, ensure:

- [ ] VirtualBox is installed and services are running
- [ ] VirtualBox GUI has been launched at least once
- [ ] Sufficient disk space available (check default VM directory)
- [ ] RAM and CPU resources meet your chosen configuration
- [ ] Network adapters are available (for bridged networks)
- [ ] All required ISO images are downloaded (see `../docs/SETUP/prereqs.md`)

## Deployment Order

**IMPORTANT:** The deployment order is critical for proper network connectivity and service dependencies.

### Recommended Deployment Sequence

1. **pfSense Firewall (FW-PFSENSE)** - **MUST BE FIRST**

   - Provides routing and network connectivity for all other VMs
   - See: `../docs/SETUP/pfsense_setup.md`

2. **Internal VMs (via Vagrant)**

   - Deploy all internal VMs using this Vagrantfile
   - See: `README.md` for Quick Start

3. **External VMs (GOAD, Metasploitable)**

   - Deploy after internal VMs are running
   - Configure network settings to match lab segments

4. **Manual Configuration**
   - Configure Wazuh agents
   - Set up web server applications
   - Final verification and testing

## Internal VMs (Automated)

These VMs are automatically provisioned and configured by this Vagrantfile:

- **LAN-SIEM-LIN** (192.168.10.104): Ubuntu 22.04 with Wazuh Manager
- **LAN-TEST-LIN** (192.168.10.100): Ubuntu 22.04 Desktop with GUI
- **LAN-ATTACK-LIN** (192.168.10.109): Kali Linux attack machine (LAN segment)
- **WAN-ATTACK-LIN** (DHCP): Kali Linux attack machine (WAN segment, bridged)
- **DMZ-WEB01-LIN** (192.168.20.105): Debian 12 web server with Docker

**Deployment:**

```bash
cd automation
vagrant up
```

See `README.md` for detailed instructions.

## External VMs

The following VMs are **NOT** managed by this Vagrantfile and must be deployed separately:

### 1. GOAD MINILAB (LAN-DC01-WIN, LAN-WS01-WIN)

**Purpose:** Active Directory environment for AD attack scenarios

**Repository:** https://github.com/Orange-Cyberdefense/GOAD

**Deployment:**

```bash
# Clone GOAD repository
git clone https://github.com/Orange-Cyberdefense/GOAD.git
cd GOAD

# Deploy MINILAB
py goad.py -m vm
```

**Network Configuration:**

- **Network Segment:** LAN (`lab-lan` internal network)
- **IP Addresses:**
  - DC01: 192.168.10.30
  - WS01: 192.168.10.31
- **Gateway:** 192.168.10.1 (pfSense)

**Integration Steps:**

1. After GOAD deployment, configure VM network adapters in VirtualBox/VMware
2. Set network adapter to use `lab-lan` internal network
3. Verify connectivity: `ping 192.168.10.1` (pfSense gateway)
4. Verify DNS resolution within AD domain (see `../docs/TESTS/GOAD-MINILAB.md`)

**Documentation:**

- Official GOAD: https://orange-cyberdefense.github.io/GOAD/
- Lab4PurpleSec integration: `../docs/SETUP/GOAD_setup.md`

---

### 2. Metasploitable3 (DMZ-MS3-LIN, DMZ-MS3-WIN)

**Purpose:** Intentionally vulnerable Linux and Windows machines for penetration testing practice

**Repository:** https://github.com/rapid7/metasploitable3

**Deployment:**

```bash
# Clone Metasploitable3 repository
git clone https://github.com/rapid7/metasploitable3.git
cd metasploitable3

# Deploy both VMs
vagrant up
```

**Network Configuration:**

- **Network Segment:** DMZ (`lab-dmz` internal network)
- **IP Addresses:**
  - MS3-LIN: 192.168.20.106
  - MS3-WIN: 192.168.20.107
- **Gateway:** 192.168.20.1 (pfSense)

**Integration Steps:**

1. After Metasploitable3 deployment, configure VM network adapters
2. Set network adapter to use `lab-dmz` internal network
3. Verify connectivity: `ping 192.168.20.1` (pfSense gateway)
4. Verify connectivity to DMZ-WEB01-LIN: `ping 192.168.20.105`

**Documentation:**

- Official Metasploitable3: https://github.com/rapid7/metasploitable3
- Lab4PurpleSec integration: `../docs/SETUP/VMs_installation.md`

---

### 3. Metasploitable2 (DMZ-MS2-LIN)

**Purpose:** Legacy intentionally vulnerable Linux machine

**Download:** https://www.rapid7.com/products/metasploit/metasploitable/

**Deployment:**

1. Download Metasploitable2 ZIP archive
2. Extract ZIP archive
3. Open OVA/VMX file in VirtualBox or VMware

**Network Configuration:**

- **Network Segment:** DMZ (`lab-dmz` internal network)
- **IP Address:** 192.168.20.104
- **Gateway:** 192.168.20.1 (pfSense)

**Integration Steps:**

1. Import VM into VirtualBox/VMware
2. Configure network adapter to use `lab-dmz` internal network
3. Start VM and verify connectivity
4. Default credentials: `msfadmin:msfadmin` (change after first login!)

**Documentation:**

- Official Metasploitable2: https://www.rapid7.com/products/metasploit/metasploitable/
- Lab4PurpleSec integration: `../docs/SETUP/VMs_installation.md`

---

### 4. pfSense Firewall (FW-PFSENSE)

**Purpose:** Network firewall, router, and IDS/IPS (Suricata)

**Installation:** Manual from ISO image

**Network Configuration:**

- **WAN Interface:** Bridged network (connects to host network)
- **LAN Interface:** `lab-lan` internal network (192.168.10.1/24)
- **DMZ Interface:** `lab-dmz` internal network (192.168.20.1/24)

**Deployment:**

1. Download pfSense ISO: https://atxfiles.netgate.com/mirror/downloads/
2. Create VM with 3 network adapters (WAN, LAN, DMZ)
3. Install from ISO
4. Configure interfaces and firewall rules

**Documentation:**

- Official pfSense: https://www.pfsense.org/
- Lab4PurpleSec setup: `../docs/SETUP/pfsense_setup.md`

**IMPORTANT:** pfSense **MUST** be started **BEFORE** all other VMs to provide routing and network connectivity.

---

## Network Segments

The lab uses three network segments:

### WAN Segment

- **Type:** Bridged network (connects to host network)
- **Purpose:** Simulates Internet connection
- **VMs:**
  - WAN-ATTACK-LIN (Kali Linux)

### LAN Segment

- **Network:** `lab-lan` (192.168.10.0/24)
- **Gateway:** 192.168.10.1 (pfSense)
- **Purpose:** Internal network with AD environment and SIEM
- **VMs:**
  - LAN-SIEM-LIN (192.168.10.104) - Wazuh Manager
  - LAN-TEST-LIN (192.168.10.100) - Test machine
  - LAN-ATTACK-LIN (192.168.10.109) - Attack machine
  - LAN-DC01-WIN (192.168.10.30) - GOAD Domain Controller
  - LAN-WS01-WIN (192.168.10.31) - GOAD Workstation

### DMZ Segment

- **Network:** `lab-dmz` (192.168.20.0/24)
- **Gateway:** 192.168.20.1 (pfSense)
- **Purpose:** Demilitarized zone with vulnerable web services
- **VMs:**
  - DMZ-WEB01-LIN (192.168.20.105) - Web server
  - DMZ-MS2-LIN (192.168.20.104) - Metasploitable2
  - DMZ-MS3-LIN (192.168.20.106) - Metasploitable3 Linux
  - DMZ-MS3-WIN (192.168.20.107) - Metasploitable3 Windows

---

## Verification Checklist

After deploying all VMs, verify:

- [ ] pfSense is running and accessible (192.168.10.1, 192.168.20.1)
- [ ] All internal VMs are running (`vagrant status`)
- [ ] GOAD VMs are on `lab-lan` network
- [ ] Metasploitable VMs are on `lab-dmz` network
- [ ] Network connectivity between segments (ping tests)
- [ ] Wazuh Manager is accessible (https://192.168.10.104)
- [ ] Web server is accessible (http://192.168.20.105)
- [ ] Firewall rules are configured correctly
- [ ] All services are running as expected

---

## Troubleshooting

### VMs Cannot Reach Each Other

1. **Verify pfSense is running** - It must be started first
2. **Check network adapter configuration** - Ensure correct internal network is selected
3. **Verify IP addresses** - Check that IPs match expected values
4. **Check firewall rules** - Ensure pfSense allows required traffic

### External VMs Not on Correct Network

1. **Power off VM**
2. **Edit VM settings** in VirtualBox
3. **Change network adapter** to correct internal network (`lab-lan` or `lab-dmz`)
4. **Start VM** and verify IP configuration

### Network Adapter Not Found

1. **Verify internal networks exist** in VirtualBox
2. **Create networks manually** if needed:
   - VirtualBox: `File > Host Network Manager > Create`

---

## Additional Resources

- **Main README:** `../README.md`
- **Automation README:** `README.md`
- **Setup Guides:** `../docs/SETUP/`
- **Architecture:** `../ARCHITECTURE.md`
- **Inventory:** `../INVENTORY.md`

---

**Last Updated:** V1 - Initial release
