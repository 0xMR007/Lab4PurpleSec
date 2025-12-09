<div align="center">
  <img src="../../assets/images/banners/Wazuh-logo.png" alt="Wazuh Logo" width="500" />
</div>

# Wazuh Tests

# Overview

This document presents the **tests performed** to validate the configuration and operation of **Wazuh** and its integration with **Suricata** on pfSense. The tests cover:

- Verification of Wazuh agent connections.
- Monitoring of system logs and security events.
- Intrusion detection via Suricata (e.g., Nmap scans, SSH brute-force).
- Alert correlation in the Wazuh dashboard.

**Objective**: Validate that Wazuh collects, analyzes, and correctly alerts on suspicious activities in the Lab4PurpleSec environment.

# Table of Contents

- [Wazuh Tests](#wazuh-tests)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
  - [I. Agent Connection Verification](#i-agent-connection-verification)
  - [II. System Log Monitoring](#ii-system-log-monitoring)
    - [SSH Connection](#ssh-connection)
    - [sudo Attempt](#sudo-attempt)
  - [III. pfSense and Suricata Monitoring Test](#iii-pfsense-and-suricata-monitoring-test)
    - [SSH Connection (Failed)](#ssh-connection-failed)
    - [Nmap Installation](#nmap-installation)
    - [Aggressive Nmap Scan](#aggressive-nmap-scan)
  - [IV. Brute-Force Incident Simulation](#iv-brute-force-incident-simulation)
    - [Hydra Installation](#hydra-installation)
    - [SSH Brute-Force](#ssh-brute-force)
- [Conclusion](#conclusion)

# Prerequisites

Before performing the following tests, ensure the prerequisites below:

- The following machines are installed and configured:
  - FW-PFSENSE
  - DMZ-WEB01-LIN
  - DMZ-MS2-LIN
  - LAN-ATTACK-LIN
  - LAN-SIEM-LIN
  - LAN-TEST-LIN
- **At least one Wazuh agent** is added and configured.
- The pfSense agent has been installed and configured
- Suricata has been configured on pfSense
- Wazuh agents are correctly configured and connected to the manager

## I. Agent Connection Verification

- **Objective**: Ensure that each Wazuh agent (Linux/Windows machines, pfSense) appears as "Connected/Active" in the Manager interface.
- **How**: Go to "Agents" on the Dashboard, verify the status of each added agent.
- **Expected result**: "Connected" status.

After adding all **Lab4PurpleSec** agents, you should obtain a result similar to the following, with 7 agents:

![Wazuh-agents-list.png](/assets/images/Wazuh-tests/Wazuh-agents-list.png)

## II. System Log Monitoring

- **Objective**: Validate that system security/base logs are correctly forwarded to the Wazuh server (auth logs, sudo, system modifications, etc.).
- **How**: On the agent you want to test, generate an event to forward to Wazuh (e.g., SSH connection, sudo attempt).
- **Verify**: The Wazuh dashboard under _Threat Intelligence_ > _Threat Hunting_ for real-time forwarding.

To monitor recent logs from one minute on the DMZ-WEB01-LIN agent, you can refer to the following capture:

![DMZ-WEB01-LIN-dashboard.png](/assets/images/Wazuh-tests/DMZ-WEB01-LIN-dashboard.png)

Then go to _Events_ to obtain more information on events forwarded by Wazuh:

![DMZ-WEB01-LIN-events-dashboard.png](/assets/images/Wazuh-tests/DMZ-WEB01-LIN-events-dashboard.png)

Let's then perform some actions on the concerned agent:

### SSH Connection

Command executed:

```bash
ssh webadmin@vuln-web.lab
```

Execution in terminal (LAN-TEST-LIN):

![SSH-login-terminal.png](/assets/images/Wazuh-tests/SSH-login-terminal.png)

Result obtained on Wazuh side:

![SSH-login-event.png](/assets/images/Wazuh-tests/SSH-login-event.png)

The SSH connection is correctly returned in Wazuh events.

> Note: "Unknown problem somewhere in the system." Alerts
>
> These low-level alerts are common on Linux and related to non-critical system errors (e.g., `RTKit`, `pipewire`).
>
> They do not signal a real threat and can be ignored in a lab context.
>
> In production, appropriate filtering of Wazuh rules is advised to reduce these default alerts.
>
> This situation illustrates the richness of collected data and the future need to optimize alert tuning/adjustment.
>
> In our case, you can simply apply the filter highlighted in red on the screenshot above, to display events relevant to our tests.

### sudo Attempt

Command executed:

```bash
sudo whoami
```

Execution in terminal (LAN-TEST-LIN):

![sudo-whoami-terminal.png](/assets/images/Wazuh-tests/sudo-whoami-terminal.png)

Result obtained on Wazuh side:

![sudo-whoami-event.png](/assets/images/Wazuh-tests/sudo-whoami-event.png)

The `sudo` execution has been correctly returned in Wazuh events.

## III. pfSense and Suricata Monitoring Test

- **Objective**: Verify that Wazuh correctly collects logs of system and network events from pfSense, as well as Suricata alerts.
- **How**:
  - Generate network traffic by:
    - Simulating a failed SSH connection.
    - Performing an aggressive Nmap scan from an external VM (WAN) or internal (LAN) to a segment monitored by Suricata (e.g., DMZ).
  - In Wazuh, search for these alerts in the dashboard.
- **Expected result**: System and network alerts (Suricata) visible in the Wazuh dashboard.

Tests will be performed on the following machines:

- DMZ-MS2-LIN
- FW-PFSENSE

### SSH Connection (Failed)

Command executed:

```bash
ssh root@pfsense.Lab4PurpleSec
```

Execution in terminal (LAN-TEST-LIN):

![SSH-failed-login-terminal.png](/assets/images/Wazuh-tests/SSH-failed-login-terminal.png)

Result obtained on Wazuh side (pfSense agent):

![SSH-failed-login-events-dashboard.png](/assets/images/Wazuh-tests/SSH-failed-login-events-dashboard.png)

The failed SSH connection to pfSense is correctly returned in Wazuh events.

### Nmap Installation

You can install Nmap on Ubuntu/Debian with the commands:

```bash
sudo apt update
sudo apt install nmap
```

Execution in terminal (LAN-TEST-LIN):

![Nmap-install.png](/assets/images/Wazuh-tests/Nmap-install.png)

Here, Nmap is already installed on LAN-TEST-LIN.

### Aggressive Nmap Scan

Command executed:

```bash
nmap -A metasploitable2
```

Execution in terminal (LAN-TEST-LIN):

![DMZ-MS2-LIN-Nmap-scan.png](/assets/images/Wazuh-tests/DMZ-MS2-LIN-Nmap-scan.png)

Result obtained on Wazuh side (pfSense agent):

![Suricata-alerts-Wazuh-dashboard.png](/assets/images/Wazuh-tests/Suricata-alerts-Wazuh-dashboard.png)

Suricata alerts are correctly returned in Wazuh events. A simple Nmap scan (still aggressive), triggered no less than 130 Suricata alerts!

## IV. Brute-Force Incident Simulation

- **Objective**: Ensure detection and correlation of suspicious events.
- **How**:
  - Simulate multiple failed SSH connections (brute-force).
  - Observe detection, correlation, and alert raising by Wazuh.
- **Expected result**: "brute-force" alert detected and forwarded to the dashboard.

### Hydra Installation

You can install Hydra on Ubuntu/Debian with the commands:

```bash
sudo apt update
sudo apt install hydra
```

Or simply use the LAN-ATTACK-LIN machine which already has `hydra`:

![Hydra-LAN-ATTACK-LIN.png](/assets/images/Wazuh-tests/Hydra-LAN-ATTACK-LIN.png)

Same for `seclists` wordlists:

```bash
sudo apt update
sudo apt install seclists
# Or
sudo snap install seclists
```

### SSH Brute-Force

Command executed:

```bash
hydra -L /usr/share/wordlists/metasploit/unix_users.txt -P /usr/share/wordlists/metasploit/unix_passwords.txt vuln-web.lab ssh
```

Execution in terminal (LAN-ATTACK-LIN):

![SSH-bruteforce-terminal.png](/assets/images/Wazuh-tests/SSH-bruteforce-terminal.png)

Result obtained on Wazuh side (DMZ-WEB01-LIN agent):

![SSH-bruteforce-events.png](/assets/images/Wazuh-tests/SSH-bruteforce-events.png)

SSH connection attempts are correctly forwarded to the Wazuh dashboard.

# Conclusion

The tests performed confirm that:

- ✅ **Wazuh agents** (including pfSense) are correctly connected and forward their logs.
- ✅ **System events** (SSH, `sudo`) are detected and displayed in the Wazuh dashboard.
- ✅ **Suricata** generates relevant alerts for network scans and intrusion attempts (still to be optimized).
- ✅ **Brute-force attacks** are detected and correlated by Wazuh.
