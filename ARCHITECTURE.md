# Architecture

## Overview

This document describes the technical architecture of **Lab4PurpleSec**, designed to simulate a realistic network environment including a LAN segment, an exposed DMZ, and a virtual WAN.

## General Overview

The lab is structured around three network segments (WAN, DMZ, LAN), interconnected by a pfSense firewall, behind which vulnerable VMs, a SIEM, and an educational Active Directory environment are deployed.

## Network Architecture

The architecture is structured around two main vulnerable environments: Lab4PurpleSec-DMZ and GOAD-MINILAB.

These two environments are interconnected via a pfSense router/firewall that ensures segmentation and filtering between network zones.

### Lab4PurpleSec

Lab4PurpleSec is an environment dedicated to application and system vulnerability exploitation, hosting intentionally vulnerable machines (Metasploitable2/3), OWASP web applications in an isolated DMZ zone, as well as a vulnerable Active Directory environment (GOAD MINILAB).

![Homelab-light.png](/assets/images/Diagrams/Homelab-light.png)

### GOAD-MINILAB (by Orange Cyberdefense)

GOAD-MINILAB replicates a simplified Active Directory environment with a domain controller and a Windows client workstation (multiple if needed), allowing simulation of various types of Active Directory-oriented attacks.

![GOAD-MINILAB.png](/assets/images/Diagrams/GOAD-MINILAB.png)

## Network Configuration

This section details the IP topology, addressing plan, and filtering rules implemented between the different lab zones.

### Subnets

The lab is segmented into three distinct subnets to isolate network functions and limit attack propagation between zones.

> Cf. `Docs/SETUP/prereqs.md`

| Subnet          | Function                            |
| --------------- | ----------------------------------- |
| 192.168.1.0/24  | Virtual WAN (Bridge to host LAN)    |
| 192.168.10.0/24 | LAN (SIEM, AD, client workstations) |
| 192.168.20.0/24 | DMZ (Web, MS2/3)                    |

### IP Addressing

The following table presents the static addressing plan for all virtual machines in the lab, organized by network zone.

### DMZ

| Hostname      | IP Address     | Description                                  |
| ------------- | -------------- | -------------------------------------------- |
| DMZ-MS2-LIN   | 192.168.20.104 | Metasploitable2 vulnerable machine           |
| DMZ-MS3-LIN   | 192.168.20.106 | Metasploitable3 vulnerable machine (Linux)   |
| DMZ-MS3-WIN   | 192.168.20.107 | Metasploitable3 vulnerable machine (Windows) |
| DMZ-WEB01-LIN | 192.168.20.105 | Vulnerable web server (with Docker compose)  |

### LAN

| Hostname       | IP Address     | Description                                   |
| -------------- | -------------- | --------------------------------------------- |
| LAN-TEST-LIN   | 192.168.10.100 | Test machine (administration)                 |
| LAN-ATTACK-LIN | 192.168.10.109 | Kali attack machine                           |
| LAN-DC01-WIN   | 192.168.10.30  | Active Directory domain controller (mini.lab) |
| LAN-SIEM-LIN   | 192.168.10.104 | Wazuh Manager server                          |
| LAN-WS01-WIN   | 192.168.10.31  | Windows 10 client workstation (mini.lab)      |

## pfSense

The pfSense firewall is the core of network segmentation, managing three distinct interfaces and applying strict filtering rules to control flows between WAN, LAN, and DMZ.

> Cf. `Docs/SETUP/pfsense_setup.md`

### Interfaces

Three network interfaces are configured on pfSense to ensure connectivity and isolation between zones.

| Interface | Name | IP Address            | Role                |
| --------- | ---- | --------------------- | ------------------- |
| em0       | WAN  | 192.168.1.X/24 (DHCP) | Simulates Internet  |
| em1       | LAN  | 192.168.10.1/24       | Private LAN segment |
| em2       | DMZ  | 192.168.20.1/24       | DMZ segment         |

### Rules

The following firewall rules implement a restrictive security policy allowing only flows necessary for lab operation.

### WAN

WAN rules allow HTTP/HTTPS access to the DMZ while blocking all direct access to the LAN from outside.

![pfSense-WAN-rules.png](/assets/images/pfSense-setup/pfSense-WAN-rules.png)

| Interface | Action | Protocol | Link              |
| --------- | ------ | -------- | ----------------- |
| WAN       | Allow  | HTTP     | WAN → DMZ (proxy) |
| WAN       | Allow  | HTTPS    | WAN → DMZ (proxy) |
| WAN       | Block  | All      | WAN → LAN         |

### LAN

![pfSense-LAN-rules.png](/assets/images/pfSense-setup/pfSense-LAN-rules.png)

The LAN segment has full access to the DMZ and WAN to allow reconnaissance and exploitation activities from the attack machine (simulating a compromised LAN machine).

| Interface | Action | Protocol | Link      |
| --------- | ------ | -------- | --------- |
| LAN       | Allow  | All      | LAN → DMZ |
| LAN       | Allow  | All      | LAN → WAN |

### DMZ

![pfSense-DMZ-rules.png](/assets/images/pfSense-setup/pfSense-DMZ-rules.png)

The DMZ can communicate with the WAN and with the SIEM for log forwarding, but cannot initiate connections to the LAN to limit pivoting risks.

| Interface | Action | Protocol | Link                         | Description                |
| --------- | ------ | -------- | ---------------------------- | -------------------------- |
| DMZ       | Allow  | All      | DMZ → WAN                    | WAN access authorized      |
| DMZ       | Allow  | TCP      | DMZ → LAN (ports 1514, 1515) | Wazuh agent communications |
| DMZ       | Block  | All      | DMZ → LAN                    | LAN access denied          |

These rules can of course be adapted to the expected scenario. However, they add a touch of realism to the lab.

### NAT/Port Forwarding Rules (Nginx Reverse Proxy)

A NAT rule redirects incoming HTTP traffic from the WAN to the vulnerable web server (with Nginx reverse proxy under Docker) hosted in the DMZ. This allows access to various web services from the WAN.

| Interface | Protocol | Link      | Destination Port | NAT IP         | NAT Port(s) | Description           |
| --------- | -------- | --------- | ---------------- | -------------- | ----------- | --------------------- |
| WAN       | TCP      | WAN → DMZ | 80 (HTTP)        | 192.168.20.105 | 80 (HTTP)   | NAT HTTP -> DMZ-WEB01 |

### Host Aliases

DNS aliases are configured on pfSense to facilitate access to various vulnerable services by hostname rather than IP address.

![pfSense-aliases.png](/assets/images/pfSense-setup/pfSense-aliases.png)

## Nginx Reverse Proxy

An Nginx reverse proxy is deployed on DMZ-WEB01-LIN to expose all vulnerable web services via dedicated virtual hosts, simplifying access and management of different applications.

### Vulnerable Web Services

The table below references all intentionally vulnerable web applications accessible via the reverse proxy, covering a wide spectrum of technologies and OWASP vulnerabilities.

| Machine       | Virtual Host      | Port | Service         | Description                                                                |
| ------------- | ----------------- | ---- | --------------- | -------------------------------------------------------------------------- |
| DMZ-WEB01-LIN | juice.lab         | 3000 | Juice Shop      | OWASP Juice Shop – vulnerable web application                              |
| DMZ-WEB01-LIN | webgoat.lab       | 8080 | WebGoat         | OWASP WebGoat – vulnerable Java web application                            |
| DMZ-WEB01-LIN | webwolf.lab       | 9090 | WebWolf         | WebGoat attack application                                                 |
| DMZ-WEB01-LIN | bwapp.lab         | 80   | bWAPP           | bWAPP – vulnerable PHP web application                                     |
| DMZ-WEB01-LIN | nodegoat.lab      | 4000 | NodeGoat        | NodeGoat – vulnerable Node.js application                                  |
| DMZ-WEB01-LIN | vampi.lab         | 5000 | VAmPI (API)     | Vulnerable REST API                                                        |
| DMZ-MS2-LIN   | ms2.lab           | 80   | Web (MS2)       | Metasploitable2 – Vulnerable web services (phpMyAdmin, Webdav, DVWA, etc…) |
| DMZ-MS2-LIN   | ms2-8180.lab      | 8180 | Web (MS2 alt)   | Metasploitable2 – Old Apache Tomcat web server                             |
| DMZ-MS3-WIN   | ms3win.lab        | 80   | Web (MS3 Win)   | Metasploitable3 (Windows) – web service (demo)                             |
| DMZ-MS3-WIN   | ms3win-8282.lab   | 8282 | Web (MS3 Win)   | Metasploitable3 (Windows) – More recent Apache Tomcat web server           |
| DMZ-MS3-WIN   | ms3win-8484.lab   | 8484 | Web (MS3 Win)   | Metasploitable3 (Windows) – Jenkins portal                                 |
| DMZ-MS3-WIN   | ms3win-4848.lab   | 4848 | Admin Console   | Metasploitable3 (Windows) – Oracle GlassFish admin console                 |
| DMZ-MS3-WIN   | ms3win-8585.lab   | 8585 | Web (MS3 Win)   | Metasploitable3 (Windows) – WampServer web server                          |
| DMZ-MS3-LIN   | ms3linux.lab      | 80   | Web (MS3 Linux) | Metasploitable3 (Linux) – Vulnerable web services (chat app, drupal, etc…) |
| DMZ-MS3-LIN   | ms3linux-8080.lab | 8080 | Web (MS3 Linux) | Metasploitable3 (Linux) – Old Continuum web service                        |

See `Docs/SETUP/Web_server_setup.md` for more details.

## Typical Flows

### Flow #1 (WAN → DMZ)

Exploit an OWASP vulnerability on a DMZ VM from WAN, pivot to LAN via pivoting + AD credentials (in this case, allow DMZ → LAN flow).

### Flow #2 (LAN → DMZ)

Exploit an FTP vulnerability on a DMZ VM from LAN, then exploit another DMZ machine.

### Flow #3 (LAN → LAN AD)

Exploit an AD vulnerability on a client workstation from the LAN, then exploit the DC via this same machine.
