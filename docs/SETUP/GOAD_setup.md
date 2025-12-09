<div align="center">
  <img src="../../assets/images/banners/GOAD-logo.png" alt="GOAD Logo"/>
</div>

# GOAD Setup

# Overview

This document describes the installation and integration steps for **GOAD (Game Of Active Directory) MINILAB version** lab. A test environment dedicated to offensive security on Active Directory.

This guide describes GOAD MINILAB deployment via Vagrant and its integration into the Lab4PurpleSec LAN segment.

# Table of Contents

- [GOAD Setup](#goad-setup)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
- [Installation Performed](#installation-performed)
  - [Installation Steps](#installation-steps)
  - [Post-Installation Verification](#post-installation-verification)
- [Notes and Tips](#notes-and-tips)
- [Security](#security)

## Prerequisites

- Windows 10/11 or Linux Ubuntu/Debian (tested on: Windows 11 25H2)
- 32 GB RAM minimum (16 GB possible with swap)
- 100 GB free disk space
- VirtualBox 7.x and/or VMware Workstation 17.x
- Python 3.10+
- Vagrant 2.4+

# Installation Performed

This section details the procedure to install and integrate GOAD MINILAB into the Lab4PurpleSec LAN segment. Deployment is done via Vagrant, which automates installation and configuration of necessary Windows machines.

> **Note**: This procedure uses Vagrant to automate deployment. For more information on deployment options, consult the [official GOAD documentation](https://orange-cyberdefense.github.io/GOAD/installation/).

## Installation Steps

1. **Clone the GOAD GitHub Repository**

   ```bash
   git clone https://github.com/Orange-Cyberdefense/GOAD.git
   cd GOAD
   ```

2. **Install Dependencies**
   - For Windows: [Install Visual C++ 2019](https://aka.ms/vs/17/release/vc_redist.x64.exe)
   - **Vagrant**: [Download and Installation](https://developer.hashicorp.com/vagrant/install)
   - **Vagrant Plugins**:
     ```bash
     vagrant.exe plugin install vagrant-reload vagrant-vbguest winrm winrm-fs winrm-elevated
     ```
   - **VirtualBox**: [Download and Installation](https://www.virtualbox.org/wiki/Downloads)
3. **Launch Python Dependencies Installation:**

   On Windows:

   ```powershell
   python -m venv .env
   source .env\Scripts\activate        # In CMD: .env\Scripts\activate.bat
   pip install -r noansible_requirements.yml
   ```

   On Linux:

   ```bash
   sudo apt install python<version>-venv
   ./goad.sh
   ```

   Then launch the interactive Python script with provisioning:

   ```powershell
   py goad.py -m vm
   ```

   - This command automatically downloads and configures MINILAB VMs.
   - **Estimated duration**: 30 to 60 minutes depending on your Internet connection and resources.

4. **Configure Network Cards for LAN Integration**
   - Once VMs are created and provisioned, configure network cards:
     - Remove default network cards created by Vagrant
     - Add a new network card configured in "LAN Segment" mode (LAN) for VMware
   - Configure static IP address according to addressing plan (see `INVENTORY.md`)
     - For DC01: 192.168.10.30
     - For WS01: 192.168.10.31
5. **Launch VMs in Order**
   - Start each VM in the following order:
     1. `DC01` (domain controller) — Wait for AD services to be completely started
     2. `WS01` (workstation) — Wait for the machine to join the domain
   - Verify that network services are operational.
6. **Verify Proper Operation**
   - **Domain**: Verify that VMs are properly joined to the `mini.lab` domain.
   - **Network Tests**:
     - Ping between VMs.
     - Access to shares and services (e.g., `\\\\DC01\\SYSVOL`).
   - **Security Tests**:
     - Use tools like `nmap` to validate connectivity and exposed services.

## Post-Installation Verification

Execute these commands to confirm the lab is functional:

```bash
# From WS01
ping dc
# From DC01
Get-ADUser -Filter * | Select -First 3
```

# Notes and Tips

- **Common Problems**:
  - If VMs do not start in VMware, verify hardware compatibility (OS version, allocated resources).
  - In case of domain error, verify network settings (DNS, static IP).
- **Possible Optimizations**:
  - Increase RAM/CPU allocated to VMs via GOAD configuration files if you encounter slowness.
  - Create snapshots after complete installation to facilitate restorations.
  - If you use VirtualBox initially, you can migrate VMs to VMware after provisioning if necessary.

# Security

> ⚠️ **Warning**: these machines are intentionally vulnerable.
>
> - Never connect the lab to a production network or the Internet.
> - Use only an isolated internal network (LAN Segment in VMware).
> - Immediately change default passwords after installation.
> - Consult GOAD terms of use before deployment.
