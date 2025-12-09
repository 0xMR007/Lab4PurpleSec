![VMware Logo](../../assets/images/banners/VMware-logo.avif)

# VM Installation

# Overview

This document details the installation and configuration of all virtual machines (VMs) necessary for deploying **Lab4PurpleSec**. All machines are installed manually "from scratch" from ISO images or via Vagrant for projects that support it. The document covers VMs from the WAN, LAN, and DMZ segments, with their recommended hardware configurations and installation steps specific to each machine.

# Table of Contents

1. [Overview](#overview)
2. [VM Summary](#vm-summary)
3. [General Installation Principle](#general-installation-principle)
4. [Required ISO Images](#required-iso-images)
5. [Installation by Segment](#installation-by-segment)
   - [WAN](#wan)
   - [LAN](#lan)
   - [DMZ](#dmz)
6. [Creating a LAN Segment in VMware Workstation Pro](#creating-a-lan-segment-in-vmware-workstation-pro)

# VM Summary

### DMZ Segment

| Hostname      | Interface | IP Address     | OS                                                  | Role/Description                             |
| ------------- | --------- | -------------- | --------------------------------------------------- | -------------------------------------------- |
| DMZ-MS2-LIN   | DMZ       | 192.168.20.104 | Ubuntu 8.04 (i386)                                  | Metasploitable2 vulnerable machine           |
| DMZ-MS3-LIN   | DMZ       | 192.168.20.106 | Ubuntu 14.04 (AMD64)                                | Metasploitable3 vulnerable machine (Linux)   |
| DMZ-MS3-WIN   | DMZ       | 192.168.20.107 | Windows Server 2008 R2 Standard Edition SP1 (AMD64) | Metasploitable3 vulnerable machine (Windows) |
| DMZ-WEB01-LIN | DMZ       | 192.168.20.105 | Debian 12 (AMD64)                                   | Vulnerable web server (with Docker compose)  |

### LAN Segment

| Hostname       | Interface | IP Address     | OS                                        | Role/Description                              |
| -------------- | --------- | -------------- | ----------------------------------------- | --------------------------------------------- |
| LAN-ATTACK-LIN | LAN       | 192.168.10.109 | Kali Linux (6.2.33)                       | Kali attack machine                           |
| LAN-DC01-WIN   | LAN       | 192.168.10.30  | Windows Server 2019 Datacenter Evaluation | Active Directory domain controller (mini.lab) |
| LAN-SIEM-LIN   | LAN       | 192.168.10.104 | Ubuntu 22.04 LTS                          | Wazuh Manager server                          |
| LAN-WS01-WIN   | LAN       | 192.168.10.31  | Windows 10 Enterprise Evaluation          | Windows 10 client workstation (mini.lab)      |
| LAN-TEST-LIN   | LAN       | 192.168.10.100 | Ubuntu 22.04.1                            | Test machine (administration)                 |

### WAN Segment

| Hostname       | Interface | IP Address    | OS                  | Role/Description          |
| -------------- | --------- | ------------- | ------------------- | ------------------------- |
| WAN-ATTACK-LIN | WAN       | DHCP (Bridge) | Kali Linux (6.2.33) | Kali attack machine (WAN) |

# General Installation Principle

> **Note**: This lab can be deployed using VirtualBox if needed, but VMware Workstation Pro was personally used for this documentation. When using VirtualBox, adapt network configurations accordingly (Internal Network instead of LAN Segments, Bridged Adapter for WAN, etc.).

## Installation

1. **Download the official ISO image**: Download the ISO image from the official source of the project or target operating system (see "Required ISO Images" section below).
2. **Assign interfaces to expected networks (WAN/LAN/DMZ) during installation on VMware**: In VMware, configure each network card of the virtual machine according to the network it should belong to (Bridged for WAN, LAN Segment for LAN/DMZ).
3. **Configure VMs according to associated hardware configurations below**: Adapt resources (CPU, RAM, storage) according to specific needs of each machine.
4. **Apply minimal configuration (language, network, user(s))**: During installation, select the language, configure the network (static IP or DHCP as appropriate), and create necessary users.

> **Important Note**: Before installation, it is recommended to verify the integrity of downloaded ISO images if checksums are provided by official sources. This step ensures that files have not been corrupted during download.

## Post-installation

1. **Configure network settings manually**: Configure the network interface (static IP or DHCP as appropriate) and update `/etc/hosts` file if needed. See `CONFIGS/hosts` for hostname-to-IP mappings.

> **Note**: The proposed hardware configurations are indicative and based on a tested reference configuration. Feel free to adapt them according to your needs and available resources.

# Required ISO Images

Below is the list of ISO images necessary for VM installation. All machines are installed manually from these images or via Vagrant for projects that support it.

## ISO Images for Direct Installation

- **pfSense (2.7.2)**: [https://atxfiles.netgate.com/mirror/downloads/](https://atxfiles.netgate.com/mirror/downloads/) — ISO image for firewall installation
- **Kali Linux**: [https://www.kali.org/get-kali/#kali-installer-images](https://www.kali.org/get-kali/#kali-installer-images) — ISO image for attack machines (WAN-ATTACK-LIN, LAN-ATTACK-LIN)
- **Debian 12**: [https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/](https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/) — ISO image for the Wazuh Manager server (LAN-SIEM-LIN)
- **Ubuntu 22.04 Desktop**: [https://releases.ubuntu.com/22.04/](https://releases.ubuntu.com/22.04/) — ISO image for the test machine (LAN-TEST-LIN)
- **Ubuntu 22.04 Server**: [https://releases.ubuntu.com/22.04/](https://releases.ubuntu.com/22.04/) — ISO image for the web server (DMZ-WEB01-LIN)

## Machines via Vagrant

- **Metasploitable2**: ZIP archive containing the VMX file available at [https://www.rapid7.com/products/metasploit/metasploitable/](https://www.rapid7.com/products/metasploit/metasploitable/) — To open in VMware (File > Open Virtual Machine).
- **Metasploitable3 (Linux and Windows)**: Installation via Vagrant from the official Rapid7 repository — See dedicated sections below for detailed instructions
- **GOAD MINILAB (DC01 and WS01)**: Installation via Vagrant from the official Orange Cyberdefense repository — See `Docs/SETUP/GOAD_setup.md` for complete instructions

# WAN

This section covers machines connected to the **WAN** network, simulating direct exposure to the Internet. These machines are often used for intrusion testing or attack scenarios.

## WAN-ATTACK-LIN

Linux machine dedicated to offensive testing from the WAN network. It can be used to launch scans, attacks, or simulate an external adversary.

### Hardware Configuration

| CPU Cores    | 2       |
| ------------ | ------- |
| RAM          | ≥ 4 GB  |
| Storage      | 50 GB   |
| Network Card | Bridged |

### Installation Steps

1. **Create a new virtual machine** in VMware by selecting the ISO associated with Kali Linux.
2. **Configure the network card in Bridged mode** to simulate a direct connection to the Internet (host LAN).
3. **Allocate hardware resources** according to the table above.
4. **Complete the installation** by following standard steps (partitioning, user, etc.).
5. **Update the system** after installation:

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

6. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.

### Expected Result

![WAN-ATTACK-LIN-Settings.png](/assets/images/VMs-settings/WAN-ATTACK-LIN-Settings.png)

# LAN

This section groups internal machines on the local network (LAN), simulating an enterprise environment. These machines can include servers, workstations, and monitoring tools.

## LAN-ATTACK-LIN

Linux machine dedicated to offensive testing from the LAN network. It allows simulating internal attacks or lateral movements.

### Hardware Configuration

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 4 GB                 |
| Storage      | 50 GB                  |
| Network Card | LAN Segment mode (LAN) |

For this machine, you can simply clone the previous one (WAN-ATTACK-LIN) and change the network card to LAN segment mode (LAN).

### Installation Steps

1. **Clone the WAN-ATTACK-LIN machine** (if it exists) or create a new virtual machine with the same parameters.
2. **Configure the network card mode** to use the dedicated LAN segment.
3. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.
4. **Verify connectivity** with other LAN machines.

### Expected Result

![LAN-ATTACK-LIN-Settings.png](/assets/images/VMs-settings/LAN-ATTACK-LIN-Settings.png)

## LAN-SIEM-LIN

Linux server hosting a SIEM solution (e.g., Wazuh, ELK). This machine centralizes logs and security alerts for the entire lab.

### Hardware Configuration

| CPU Cores    | 2                         |
| ------------ | ------------------------- |
| RAM          | ≥ 4 GB (8 GB recommended) |
| Storage      | 64 GB                     |
| Network Card | LAN Segment mode (LAN)    |

### Installation Step(s)

1. **Create a new virtual machine** in VMware by selecting the ISO associated with Ubuntu Server 22.04 LTS.
2. **Configure the network card mode** to use the dedicated LAN segment.
3. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.
4. Later: **install Wazuh** by following the [official documentation](https://documentation.wazuh.com/)

For the Wazuh server, it is recommended to have sufficient RAM as well as storage space.

### Expected Result

![LAN-SIEM-LIN-Settings.png](/assets/images/VMs-settings/LAN-SIEM-LIN-Settings.png)

## LAN-TEST-LIN

Linux machine used for various tests (e.g., vulnerabilities, system/network administration). It can serve as a target or test platform.

### Hardware Configuration

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 4 GB (here 7.9 GB)   |
| Storage      | 20 GB                  |
| Network Card | LAN Segment mode (LAN) |

### Installation Step(s)

1. **Create a new virtual machine** with Ubuntu 22.04 Desktop ISO.
2. **Configure the network card mode** to use the dedicated LAN segment.
3. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.
4. **Install necessary tools** (OpenSSH, Nmap, etc.) according to your needs.

### Expected Result

![LAN-TEST-LIN-Settings.png](/assets/images/VMs-settings/LAN-TEST-LIN-Settings.png)

## LAN-DC01-WIN

Windows domain controller (Active Directory) for the GOAD lab. This machine is essential for simulating an enterprise environment.

<aside>

This machine is part of the GOAD lab MINILAB version. Its installation is done via Vagrant with a provider (VMware, VirtualBox, etc.). The complete installation is detailed in `Docs/SETUP/GOAD_setup.md` which covers deployment and integration into the LAN.

</aside>

### Hardware Configuration (default via Vagrant)

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 3.9 GB               |
| Storage      | 60 GB                  |
| Network Card | LAN Segment mode (LAN) |

### Installation Step(s)

Follow the detailed instructions in `Docs/SETUP/GOAD_setup.md` for complete GOAD MINILAB deployment. Main steps are:

1. **Deployment via Vagrant**:
   - Follow the [official GOAD documentation](https://orange-cyberdefense.github.io/GOAD/installation/) to deploy the machine with Vagrant and VMware/VirtualBox.
   - After installation:
     - **Configure the network card mode** to use the dedicated LAN segment.
     - Remove other network cards.
     - Verify network connectivity and domain integration.

### Expected Result

![LAN-DC01-WIN-Settings.png](/assets/images/VMs-settings/LAN-DC01-WIN-Settings.png)

## LAN-WS01-WIN

Windows workstation integrated into the GOAD domain. Used to simulate a standard user workstation.

<aside>

This machine is part of the GOAD lab MINILAB version. Its installation is done via Vagrant with a provider (VMware, VirtualBox, etc.). The complete installation is detailed in `Docs/SETUP/GOAD_setup.md` which covers deployment and integration into the LAN.

</aside>

### Hardware Configuration (default via Vagrant)

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 3.9 GB               |
| Storage      | 60 GB                  |
| Network Card | LAN Segment mode (LAN) |

### Installation Step(s)

Follow the detailed instructions in `Docs/SETUP/GOAD_setup.md` for complete GOAD MINILAB deployment. Main steps are:

1. **Deployment via Vagrant**:
   - Deploy the machine by following the [official GOAD documentation](https://orange-cyberdefense.github.io/GOAD/installation/).
   - After installation:
     - **Configure the network card mode** to use the dedicated LAN segment.
     - Remove other network cards.
     - Verify that the machine automatically joins the domain after startup.

### Expected Result (same as DC)

![LAN-WS01-WIN-Settings.png](/assets/images/VMs-settings/LAN-WS01-WIN-Settings.png)

<aside>

**Note**: If GOAD machine installation via Vagrant does not work with the VMware provider, you can temporarily use the VirtualBox provider. Once installation and provisioning are complete, you can migrate the VMs to VMware if necessary. Consult `Docs/SETUP/GOAD_setup.md` for more details on this procedure.

</aside>

# DMZ

The DMZ (Demilitarized Zone) groups machines partially exposed to the virtual WAN (host LAN, not Internet!), such as web servers or services accessible from outside.

## DMZ-MS2-LIN

Linux machine hosting vulnerable services exposed in DMZ (FTP, SSH, web server, database, etc.).

### Hardware Configuration

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 1 GB                 |
| Storage      | 60 GB                  |
| Network Card | LAN Segment mode (DMZ) |

### Installation Step(s)

1. **Download the ZIP archive** from [https://www.rapid7.com/products/metasploit/metasploitable/](https://www.rapid7.com/products/metasploit/metasploitable/)
2. **Extract the archive** and locate the `.vmx` file (VMware configuration file)
3. **Open the VMX file** in VMware Workstation (File > Open Virtual Machine)
4. **Configure the network card mode** to use the DMZ LAN segment.
5. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.
6. **Start the machine** and verify its operation.
7. **Verify connectivity** to WAN and LAN networks.

### Expected Result

![DMZ-MS2-LIN-Settings.png](/assets/images/VMs-settings/DMZ-MS2-LIN-Settings.png)

## DMZ-WEB01-LIN

Linux web server exposed in DMZ that has several vulnerable web applications (OWASP) with Docker compose and Nginx reverse proxy.

### Hardware Configuration

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 2 GB                 |
| Storage      | 20 GB                  |
| Network Card | LAN Segment mode (DMZ) |

### Installation Step(s)

1. **Create a new virtual machine** in VMware by selecting the ISO associated with Ubuntu Server 22.04 LTS.
2. **Configure the network card mode** to use the DMZ LAN segment.
3. **Configure network settings** (static IP or DHCP) and update `/etc/hosts` if needed.
4. Follow the tool installation steps in `Docs/SETUP/Web_server_setup.md`

### Expected Result

![DMZ-WEB01-LIN-Settings.png](/assets/images/VMs-settings/DMZ-WEB01-LIN-Settings.png)

## DMZ-MS3-LIN

Vulnerable Linux machine containing several vulnerable services (FTP, SSH, HTTP, SMB, etc.).

### Hardware Configuration

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 2 GB                 |
| Storage      | 40 GB                  |
| Network Card | LAN Segment mode (DMZ) |

### Installation Step(s)

1. **Deployment via Vagrant**:
   - Clone the official repository: `git clone https://github.com/rapid7/metasploitable3.git`
   - Follow the repository instructions to deploy the Linux version with Vagrant.
   - After installation:
     - **Configure the network card mode** to use the DMZ LAN segment.
     - Remove other network cards.
     - Configure the static IP address (192.168.20.106) if necessary.
   - Consult the [official Metasploitable3 documentation](https://github.com/rapid7/metasploitable3) for complete details.

### Expected Result

![DMZ-MS3-LIN-Settings.png](/assets/images/VMs-settings/DMZ-MS3-LIN-Settings.png)

## DMZ-MS3-WIN

Windows machine exposed in DMZ with vulnerable services more specific to Windows servers (IIS, WampServer, etc.).

### Hardware Configuration (default via Vagrant)

| CPU Cores    | 2                      |
| ------------ | ---------------------- |
| RAM          | ≥ 4 GB                 |
| Storage      | 60 GB                  |
| Network Card | LAN Segment mode (DMZ) |

### Installation Step(s)

1. **Deployment via Vagrant**:
   - Clone the official repository: `git clone https://github.com/rapid7/metasploitable3.git`
   - Follow the repository instructions to deploy the Windows version with Vagrant.
   - After installation:
     - **Configure the network card mode** to use the DMZ LAN segment.
     - Remove other network cards.
     - Configure the static IP address (192.168.20.107) if necessary.
   - Consult the [official Metasploitable3 documentation](https://github.com/rapid7/metasploitable3) for complete details.

### Expected Result

![DMZ-MS3-WIN-Settings.png](/assets/images/VMs-settings/DMZ-MS3-WIN-Settings.png)

# Creating a LAN Segment in VMware Workstation Pro

> **Note**: This section describes the procedure for VMware Workstation Pro. If you are using VirtualBox, you can use Internal Networks instead of LAN Segments to achieve similar network isolation.

Creating a LAN segment in VMware Workstation Pro allows you to virtually isolate a group of machines so they can communicate with each other on a private network, with no direct access from outside or from the host. This feature is ideal for simulating an internal corporate network.

Here are the detailed steps to create and use a LAN segment:

1. **Open VMware Workstation Pro** on your machine.

2. **Access your VM’s network settings:**

   - Click on the _VM_ tab, then _Settings_.
   - Click on the network adapter you want to configure.

3. **Add a LAN segment:**

   - Click the _LAN Segments_ button.
   - Add a new LAN segment by clicking the _Add_ button.

4. **Configure VMs to use the LAN segment:**

   - On the network adapter, click the _LAN Segment_ button.
   - Select the segment you just created.
   - Click the _OK_ button.

5. **Repeat for all machines that need to be on a network segment (LAN/DMZ) in the lab.**

In this lab, there are 2 LAN segments:

- The LAN segment for the LAN
- The LAN segment for the DMZ

Once you have created the LAN segments, you should obtain something like this:

![Network-LAN-segment.png](/assets/images/VMs-settings/Network-LAN-segment.png)

**Important notes:**

- A LAN segment does not have a default gateway: to provide Internet access or to interconnect with other segments (DMZ, WAN), you must use a VM acting as a router/firewall (e.g., pfSense).
- LAN segments are particularly useful for isolating different subnets in testing environments and for preventing unwanted interaction with your physical network or other VMs.

> For more information, see the [official VMware documentation](https://techdocs.broadcom.com/us/en/vmware-cis/desktop-hypervisors/workstation-pro/25H2/using-vmware-workstation-pro/configuring-network-connections/configuring-lan-segments.html).
