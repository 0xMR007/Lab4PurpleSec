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

- **Blue Team**: Detection coverage for this scenario will be detailed in the "Detection status" section (coming soon).

> **Note**: The Red Team skills above are examples and are not exhaustive.

---

### 2. Active Directory Attacks – Kerberoasting & AS-REP Roasting (LAN → AD)

- **Objective**:  
  Enumerate an Active Directory environment, abuse Kerberos misconfigurations, recover credentials, and compromise a domain-joined workstation.

- **Red Team skills**:
  - Active Directory enumeration
  - Kerberos abuse (Kerberoasting, AS-REP Roasting)
  - Password / hash cracking

- **Blue Team**: Detection coverage for this scenario will be detailed in the "Detection status" section (coming soon).

> **Note**: The Red Team skills above are examples and are not exhaustive.

---

## Documentation

- [00-lab-overview.md](00-lab-overview.md) - Lab topology, components and scenario index.
- [scenario-1-web-exploitation.md](scenario-1-web-exploitation.md) - Scenario 1: web application exploitation (WAN → DMZ).
- [scenario-2-active-directory.md](scenario-2-active-directory.md) - Scenario 2: Active Directory attacks on GOAD (Kerberoasting & AS-REP Roasting).

> **Note**: The scenarios are documented in the Markdown files above. The previous `Scenarios-1-and-2-1.pdf` export is no longer bundled in the repository.

For more information about the lab setup and architecture, refer to the main [README.md](../README.md) in the project root.
