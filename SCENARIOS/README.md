# Scenarios

This directory contains documentation and resources for cybersecurity scenarios that can be performed in the **Lab4PurpleSec** environment.

> **Detection baseline**: Suricata (pfSense) and Wazuh currently run with **default rules only**. No custom detection rules have been written yet; the detection tables below are observations from the documented scenarios.

## Available Scenarios

The following scenarios are documented and can be executed in the lab:

### 1. Web Application Exploitation (WAN → DMZ)

- **Objective**: Exploit a vulnerable web application exposed in the DMZ to achieve remote code execution (RCE) and obtain a reverse shell.

- **Red Team skills**:
  - Web application testing
  - Vulnerability identification (RCE / command injection)
  - Enumeration
  - Reverse shell & basic post-exploitation

> **Note**: The Red Team skills above are examples and are not exhaustive.

**Blue Team - detection status (default rules)**

| Attack step | Default detection | Source | Custom rule |
|---|---|---|---|
| Reverse shell (WAN → DMZ) | Partial: 2 Suricata alerts forwarded to Wazuh | Suricata | Planned |
| Web exploitation (bWAPP) | Not detected by Wazuh; traces only in Nginx logs | Nginx | Planned |

**Known gaps:** Nginx request bodies and Docker context are not logged or forwarded to Wazuh.

---

### 2. Active Directory Attacks – Kerberoasting & AS-REP Roasting (LAN → AD)

- **Objective**: Enumerate an Active Directory environment, abuse Kerberos misconfigurations, recover credentials, and compromise a domain-joined workstation.

- **Red Team skills**:
  - Active Directory enumeration
  - Kerberos abuse (Kerberoasting, AS-REP Roasting)
  - Password / hash cracking

> **Note**: The Red Team skills above are examples and are not exhaustive.

**Blue Team - detection status (default rules)**

| Attack step | Default detection | Source | Custom rule |
|---|---|---|---|
| Aggressive network scan (Nmap) | Detected: large volume of Suricata alerts | Suricata | Not needed |
| Anonymous enumeration | Partial: "anonymous logon" alerts on the DC agent | Wazuh | Planned |
| Kerberoasting | Poorly detected on the DC (few or no alerts) | Wazuh (Windows events) | Planned |
| AS-REP Roasting | Poorly detected on the DC (few or no alerts) | Wazuh (Windows events) | Planned |
| Remote execution (psexec) / service creation | Detected on the workstation (critical Wazuh alerts, 1 Suricata alert) | Wazuh, Suricata | Not needed |

**Known gaps:** Kerberos activity (TGS/AS requests) is not covered by default rules.

---

## Next steps

Custom Wazuh and Suricata rules, then an ATT&CK mapping. The tables above will be updated as each rule is validated.

## Documentation

- [00-lab-overview.md](00-lab-overview.md) - Lab topology, components and scenario index.
- [scenario-1-web-exploitation.md](scenario-1-web-exploitation.md) - Scenario 1: web application exploitation (WAN → DMZ).
- [scenario-2-active-directory.md](scenario-2-active-directory.md) - Scenario 2: Active Directory attacks on GOAD (Kerberoasting & AS-REP Roasting).

For more information about the lab setup and architecture, refer to the main [README.md](../README.md) in the project root.