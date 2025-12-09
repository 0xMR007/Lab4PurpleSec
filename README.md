![Lab4PurpleSec](/assets/images/icons/Lab4PurpleSec-icon-7-5.png)

# Lab4PurpleSec

> **Note**: This project was previously named "Lab4OffSec" and has been renamed to "Lab4PurpleSec" to better reflect its Purple Team focus.

![🇫🇷 Version française disponible ici](/README_FR.md)

Table of Contents

- [Lab4PurpleSec](#lab4purplesec)
  - [Overview](#overview)
    - [Project Goals](#project-goals)
  - [TL;DR](#tldr)
  - [Network Architecture](#network-architecture)
    - [Lab4PurpleSec](#lab4purplesec-1)
    - [GOAD-MINILAB](#goad-minilab)
  - [Repository Structure](#repository-structure)
  - [Quick Start](#quick-start)
    - [Manual (for now, future automation planned)](#manual-for-now-future-automation-planned)
    - [Future Automation](#future-automation)
  - [Possible Scenarios](#possible-scenarios)
    - [1. Pivoting — WAN → DMZ → LAN](#1-pivoting--wan--dmz--lan)
    - [2. OWASP Web Exploit → Persistence (webshell)](#2-owasp-web-exploit--persistence-webshell)
    - [3. Kerberoasting (AD) — reconnaissance \& ticket recovery](#3-kerberoasting-ad--reconnaissance--ticket-recovery)
  - [Component Installation](#component-installation)
  - [Contributions](#contributions)
  - [License](#license)
  - [Legal Notice](#legal-notice)
  - [Credits](#credits)

## Overview

Lab4PurpleSec is an evolving cybersecurity homelab designed for Red Team and Blue Team training in a near-enterprise environment, integrating network/web pentesting, Active Directory, detection, SIEM, and IDS/IPS.

Project intended for students and cybersecurity enthusiasts!

### Project Goals

**Lab4PurpleSec** does not provide pre-built virtual machines (OVA/OVF). Installation is done entirely "from scratch" by following the detailed guides provided. This approach:

- **Encourages learning**: Understanding each installation and configuration step
- **Ensures reproducibility**: Each user builds their environment identically (yet still customizable)
- **Strengthens understanding**: Mastery of systems, networks, and configurations
- **Facilitates customization**: Easy adaptation according to specific needs

## TL;DR

**Lab4PurpleSec** includes the following features:

- Segmented architecture (WAN, DMZ, LAN, AD)
- pfSense firewall, Suricata IDS/IPS, Wazuh SIEM
- Vulnerable machines (OWASP, Metasploitable, Windows DC)
- Detailed installation and configuration guides

## Network Architecture

### Lab4PurpleSec

Lab4PurpleSec is an environment dedicated to application and system vulnerability exploitation, hosting intentionally vulnerable machines (Metasploitable2/3), OWASP web applications in an isolated DMZ zone, as well as a vulnerable Active Directory environment (GOAD MINILAB).

![Homelab-light.png](/assets/images/Diagrams/Homelab-light.png)

### GOAD-MINILAB

GOAD-MINILAB replicates a simplified Active Directory environment with a domain controller and a Windows client workstation (multiple if needed), allowing simulation of various types of Active Directory-oriented attacks.

![GOAD-MINILAB.png](/assets/images/Diagrams/GOAD-MINILAB.png)

## Repository Structure

This section presents the organization of the **Lab4PurpleSec** repository and describes the role of each directory and main file. This structure enables clear navigation between installation guides, configurations, tests, and project resources.

```
Lab4PurpleSec/
├─ README.md                      — General project overview and quick start instructions.
├─ ARCHITECTURE.md                — Information on architecture, interfaces, network flows, and diagrams.
├─ /assets/                       — Directory containing visual resources such as images or diagrams.
├─ INVENTORY.md                   — Descriptive list of virtual machines and their main characteristics.
├─ Docs/
│  ├─ README.md
│  ├─ SETUP/
│  │   ├─ prereqs.md              — Hardware and software requirements for environment deployment.
│  │   ├─ VMs_installation.md     — Instructions for installing and configuring virtual machines.
│  │   ├─ pfsense_setup.md        — Documentation on pfSense installation and configuration.
│  │   ├─ Web_server_setup.md     — Guide for installing and configuring the web server.
│  │   ├─ Wazuh_setup.md          — Instructions for installing and configuring Wazuh and its agents.
│  │   └─ GOAD_setup.md           — Procedure for deploying the GOAD Active Directory environment.
│  └─ TESTS/
│     ├─ Web_server.md            — Documentation of verifications for the web server.
│     ├─ pfSense.md               — Documentation of verifications for pfSense and Suricata.
│     ├─ Wazuh.md                 — Documentation of verifications for Wazuh.
│     └─ GOAD-MINILAB.md          — Documentation of verifications for GOAD MINILAB.
├─ CONFIGS/
│  ├─ web-server/                 — Configuration files related to the web server.
│  └─ pfsense/                    — Configuration files for pfSense.
├─ LICENSE                        — Information on license and usage rights.
└─ .gitignore                     — List of files and directories excluded from version control.
```

## Quick Start

> **⚠️ Security Warning**: This lab contains intentionally vulnerable services. **Never** connect these machines to a production network. Always change default passwords after installation. This environment is designed for isolated, educational use only.

### Manual (for now, future automation planned)

1. Prerequisites (See `Docs/SETUP/prereqs.md`):
   - Hypervisor (VMware Workstation / VirtualBox / Hyper-V)
     > **Note**: This lab can be deployed using VirtualBox if needed, but VMware Workstation Pro was personally used for this documentation.
   - ISO images necessary for operating system installation
   - Internet connection to download dependencies and tools
2. Install VMs (excluding GOAD-MINILAB).
3. Create 3 networks / interfaces on the hypervisor (cf. `Docs/SETUP/prereqs.md`):
   1. Example for pfSense VM (3 network cards):
      - Virtual WAN: Bridge/Bridged mode (DHCP)
      - LAN: LAN Segment on 192.168.10.0/24
      - DMZ: LAN Segment on 192.168.20.0/24
4. Deploy pfSense (cf. `Docs/SETUP/pfsense_setup.md`):
   1. Configure the previous interfaces.
   2. Assign IP addresses on the interfaces.
   3. Access the pfSense web interface and verify the previous configurations.
   4. Add firewall rules.
   5. Configure the NAT rule for the Nginx reverse proxy.
5. Deploy Suricata on pfSense (cf. `Docs/SETUP/pfsense_setup.md`).
6. Deploy Wazuh Manager (SIEM) then agents on targets (Linux/Windows). See `Docs/SETUP/Wazuh_setup.md`.
7. Set up GOAD and Windows client machines, then integrate into the LAN. See `Docs/SETUP/GOAD_setup.md`.
8. Run verification tests from `Docs/TESTS/` to ensure everything is properly configured.

You can now enjoy **Lab4PurpleSec** as you wish!

You can:

- Add/Remove machines, tools, technologies freely.
- Modify the parameters of different lab machines according to your scenario.
- Use the lab as is.
- Perform various Purple Team scenarios.

> **Note**: The pfSense VM/router (FW-PFSENSE) must be started systematically for the lab to function.

### Future Automation

To further simplify deployment and ensure reproducibility, a future version of **Lab4PurpleSec** will include automation scripts leveraging Infrastructure as Code principles. This will allow users to provision and configure the entire lab environment with minimal manual steps. The specific DevOps technologies and tools to be used are yet to be defined.

In the meantime, all installation and configuration must be performed manually by following the detailed documentation provided.

If you want to contribute to the project, feel free to open an issue or a pull request.

## Possible Scenarios

### 1. Pivoting — WAN → DMZ → LAN

**Objective:** Obtain initial access on a web VM in DMZ then pivot to a LAN/AD machine.

**Skills / tools:** Reconnaissance, Tunneling (SSH/SOCKS, proxychains), pivoting.

**Expected results:** web logs + IDS alerts + Wazuh alerts.

**Point to consider:** Adapt pfSense rules (simulating a misconfiguration).

### 2. OWASP Web Exploit → Persistence (webshell)

**Objective:** Exploit a web vulnerability (upload, RCE or LFI) on a DMZ service and establish limited persistence.

**Skills / tools:** web app testing, BurpSuite, OWASP Top 10, webshell, command injection, file upload, HTTP.

**Expected results:** web logs + IDS alerts + webshell capture.

### 3. Kerberoasting (AD) — reconnaissance & ticket recovery

**Objective:** Recover Kerberos service tickets to attack service accounts.

**Skills / tools:** AD enumeration, Kerberos tickets, hash cracking.

**Expected results:** AD logs + IDS alerts + Wazuh logs showing abnormal activity, timeline.

## Component Installation

All **Lab4PurpleSec** components are installed manually from official sources:

- **GOAD MINILAB**: Installation via Vagrant according to official documentation ([https://orange-cyberdefense.github.io/GOAD/installation/](https://orange-cyberdefense.github.io/GOAD/installation/)) and integration into the LAN according to `Docs/SETUP/GOAD_setup.md`
- **Metasploitable2/3**: Installation via Vagrant from official Rapid7 repositories or using ISO/VMX images available on their respective sites
- **Other VMs**: Installation from official ISO images (Kali Linux, Debian, Ubuntu, Windows, pfSense)

Consult `Docs/SETUP/prereqs.md` for the complete list of required ISO images and `Docs/SETUP/VMs_installation.md` for detailed installation guides.

> **⚠️ Security Warning**: The created machines contain intentionally vulnerable services — **never** connect them to a production network. Immediately change default passwords after installation. This lab is designed for isolated, educational use only.

## Contributions

**_Lab4PurpleSec_** is an open-source educational project. Contributions and constructive feedback are welcome!

- **Contributing Guidelines**: See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute
- **Report Issues**: Use the [GitHub issue templates](.github/ISSUE_TEMPLATE/) for bug reports, feature requests, or documentation issues

## License

This project is licensed under the MIT License.

## Legal Notice

The logos and trademarks cited or represented in this project are the property of their respective holders.

The use of these logos is strictly informative and non-commercial.

## Credits

Special thanks to Orange Cyberdefense for developing GOAD ([https://orange-cyberdefense.github.io/GOAD](https://orange-cyberdefense.github.io/GOAD)/).
