# Scenarios

This directory contains documentation and resources for cybersecurity scenarios that can be performed in the **Lab4PurpleSec** environment.

## Available Scenarios

The following scenarios are documented and can be executed in the lab:

### 1. Web Application Exploitation (WAN → DMZ)

- **Objective**:  
  Exploit a vulnerable web application exposed in the DMZ to achieve remote code execution (RCE) and obtain a reverse shell.

- **Red Team skills**:
  - Web application testing
  - Vulnerability identification (RCE / command injection)
  - Enumeration
  - Reverse shell & basic post-exploitation

- **Blue Team skills**:
  - Network traffic analysis
  - IDS alert analysis (Suricata)
  - Web server log analysis (Nginx)
  - SIEM investigation and correlation (Wazuh)

> **Note**: These skills are just examples and are not exhaustive.

---

### 2. Active Directory Attacks – Kerberoasting & AS-REP Roasting (LAN → AD)

- **Objective**:  
  Enumerate an Active Directory environment, abuse Kerberos misconfigurations, recover credentials, and compromise a domain-joined workstation.

- **Red Team skills**:
  - Active Directory enumeration
  - Kerberos abuse (Kerberoasting, AS-REP Roasting)
  - Password / hash cracking

- **Blue Team skills**:
  - Windows event log analysis
  - Kerberos authentication monitoring
  - Detection of abnormal authentication behavior
  - Endpoint alert analysis (Wazuh)

> **Note**: These skills are just examples and are not exhaustive.

---

## Documentation

- `Scenarios-1-and-2.pdf` — Detailed documentation for scenarios 1 and 2.

For more information about the lab setup and architecture, refer to the main [README.md](../README.md) in the project root.