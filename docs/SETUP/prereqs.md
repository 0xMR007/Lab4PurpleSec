<div align="center">
  <img src="../../assets/images/banners/VMware-logo.avif" alt="VMware Logo"/>
</div>

# Prerequisites

# Overview

This section presents the general prerequisites necessary to deploy/use the **Lab4PurpleSec** lab.

You will find all useful information to prepare your environment.

# Table of Contents

- [Prerequisites](#prerequisites)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites-1)
  - [Hardware](#hardware)
  - [Software](#software)
    - [Installation Note](#installation-note)
- [Reference Configuration](#reference-configuration)
  - [Hardware](#hardware-1)
  - [Software](#software-1)

# Prerequisites

This section describes the minimum hardware and software requirements necessary for lab deployment and operation. Recommended versions and official sources are specified to ensure reproducibility and stability of environments.

## Hardware

- 16 GB RAM minimum recommended (32 GB recommended for multi-VM comfort)
- 4-core CPU minimum (i5/i7 or equivalent)
- 150 GB free disk space (with my settings, the lab takes up 130 GB)
- Reliable Internet connection

## Software

- Hypervisor:
  - VMware Workstation Pro (Broadcom account required): [https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware Workstation Pro&freeDownloads=true](https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware%20Workstation%20Pro&freeDownloads=true)
  - VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)

> **Note**: This lab can be deployed using VirtualBox if needed, but VMware Workstation Pro was personally used for this documentation.
- Required ISO images:
  - **pfSense (2.7.2)**: [https://atxfiles.netgate.com/mirror/downloads/](https://atxfiles.netgate.com/mirror/downloads/) — ISO image for firewall installation
  - **Kali Linux**: [https://www.kali.org/get-kali/#kali-installer-images](https://www.kali.org/get-kali/#kali-installer-images) — ISO image for attack machines
  - **Metasploitable2**: [https://www.rapid7.com/products/metasploit/metasploitable/](https://www.rapid7.com/products/metasploit/metasploitable/) — ZIP archive containing the VMX file (to open in VMware) or installation via Vagrant from the official repository
  - **Metasploitable3 (Linux and Windows)**: Installation via Vagrant from the official Rapid7 repository — See `Docs/SETUP/VMs_installation.md` for detailed instructions
  - **Debian 12**: [https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/](https://cdimage.debian.org/cdimage/archive/12.11.0/amd64/iso-cd/) — ISO image for the Wazuh Manager server
  - **Ubuntu 22.04 Desktop**: [https://releases.ubuntu.com/22.04/](https://releases.ubuntu.com/22.04/) — ISO image for the test machine
  - GOAD MINILAB: Installation via Vagrant from the official Orange Cyberdefense repository: [https://github.com/Orange-Cyberdefense/GOAD](https://github.com/Orange-Cyberdefense/GOAD) — See `Docs/SETUP/GOAD_setup.md` for LAN integration

### Installation Note

> **Manual installation required**: All virtual machines must be installed manually from ISO images or via Vagrant for projects that support it (Metasploitable3, GOAD). Consult `Docs/SETUP/VMs_installation.md` for detailed installation guides for each machine.

# Reference Configuration

The following configuration was used to validate the documentation and provided scenarios:

> **Note**: A similar configuration is strongly recommended for a manual installation of **Lab4PurpleSec** for maximum compatibility.

## Hardware

- CPU: i5-12400F
- GPU: AMD RX6750 XT
- RAM: 32 GB (DDR4)
- Storage: 2 x 1 TB SSDs

## Software

- OS: Windows 11 Pro (25H2)
- Hypervisor: VMware Workstation Pro (free for personal use)

> **Note**: While this lab can be deployed using VirtualBox if needed, VMware Workstation Pro was personally used for this documentation and all provided configurations.
