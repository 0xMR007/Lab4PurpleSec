<div align="center">
  <img src="../../assets/images/banners/Wazuh-logo.png" alt="Wazuh Logo"/>
</div>

# Wazuh Setup

# Overview

This document describes the installation and configuration steps for **Wazuh**, an open-source intrusion detection and log management solution (SIEM). This guide covers Wazuh server installation, first connection to the dashboard, adding an agent on a target machine for local monitoring, as well as adding a Wazuh agent on pfSense for network monitoring of the 3 interfaces.

Example of Wazuh dashboard (Threat Hunting):

![Wazuh-dashboard.png](/assets/images/Wazuh-setup/Wazuh-dashboard.png)

# Table of Contents

- [Wazuh Setup](#wazuh-setup)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Prerequisites](#prerequisites)
  - [Steps](#steps)
- [Wazuh Installation](#wazuh-installation)
- [First Connection to Manager](#first-connection-to-manager)
- [Adding a Wazuh Agent](#adding-a-wazuh-agent)
  - [**Steps**](#steps-1)
  - [Installation Video (GIF)](#installation-video-gif)
- [Adding Wazuh Agent on pfSense](#adding-wazuh-agent-on-pfsense)
  - [Installation Steps](#installation-steps)
    - [1. Enable SSH Access and Install Necessary Tools](#1-enable-ssh-access-and-install-necessary-tools)
    - [2. System Preparation for Wazuh Agent](#2-system-preparation-for-wazuh-agent)
    - [3. Agent Configuration](#3-agent-configuration)
    - [4. Suricata Integration](#4-suricata-integration)
    - [5. Docker Container Monitoring (DMZ-WEB01-LIN)](#5-docker-container-monitoring-dmz-web01-lin)
- [Resources](#resources)

# Prerequisites

Before starting, ensure that:

- **pfSense** is installed and correctly configured (firewall rules) to allow communication between VMs.
- **At least one VM** is available to install the Wazuh agent (e.g., `DMZ-WEB01-LIN`, `LAN-SIEM-LIN`).

## Steps

- Wazuh installation via official website
- Connection to manager
- Adding a Wazuh agent

# Wazuh Installation

This section details Wazuh server installation on the LAN-SIEM-LIN machine (Ubuntu 22.04 Server).

First, install the latest version of Wazuh.

> Version installed at **Lab4PurpleSec** creation: 4.13.1

Installation command:

```bash
curl -sO https://packages.wazuh.com/4.14/wazuh-install.sh && sudo bash ./wazuh-install.sh -a
```

- The `a` option installs all components (Wazuh manager, Filebeat, Dashboard).
- **Estimated duration**: 10 to 20 minutes depending on machine resources.

**Result**:

- If installation succeeds, a `wazuh-install-files.tar` file is generated. This file contains sensitive information (passwords, SSH keys, certificates).
- **Place this file in a secure location** and restrict permissions:

  ```bash
  sudo chmod 600 wazuh-install-files.tar

  # Move the file under /root (for example)
  sudo mv wazuh-install-files.tar /root/
  ```

# First Connection to Manager

**Objective**: Access the Wazuh web interface to configure and monitor agents.

**Steps**:

1. Retrieve credentials from the `wazuh-install-files.tar` archive:

   ```bash
   sudo tar -xvf wazuh-install-files.tar
   ```

2. Connect to the web interface at the address (via LAN-TEST-LIN for example):
   `https://<WAZUH_DASHBOARD_IP_ADDRESS>`
   ![Wazuh-login-page.png](/assets/images/Wazuh-setup/Wazuh-login-page.png)
3. Use default credentials (present in the archive):

   - **Username**: `admin`
   - **Password**: `<ADMIN_PASSWORD>`

   ![Wazuh-dashboard.png](/assets/images/Wazuh-setup/Wazuh-dashboard.png)

> Note:
> If you have not extracted the archive, the default password is generally displayed at the end of installation. Also, you are not supposed to have the 7 agents present in the capture above after server installation (see red box).

# Adding a Wazuh Agent

**Objective**: Deploy a Wazuh agent on a target machine to collect and send logs to the server.

## **Steps**

1. Once connected to the Wazuh web interface, open the side panel at the top right.
2. Then go to the _Agents Management > Summary_ tab
3. Click on _Deploy new agent_
4. Select the parameters of the machine that will have the agent (OS, architecture)
5. Enter the Wazuh server IP address, i.e., that of LAN-SIEM-LIN
6. Then enter the agent name (e.g., DMZ-WEB01-LIN)
7. Copy the provided installation command and execute it on the future Wazuh agent
8. Once installation is complete, do the same with the following commands (Wazuh agent service start + enable at machine startup).
9. **Verify the connection** from the manager web interface (Agents tab).

## Installation Video (GIF)

![Wazuh-agent-installation.gif](/assets/images/Wazuh-setup/Wazuh-agent-installation.gif)

> Note: Don't mind the agent named `lan-relay-lin` it was just a test agent. It is not part of the Lab4PurpleSec environment.

# Adding Wazuh Agent on pfSense

**Objective**: Install and configure a Wazuh agent on pfSense to forward system logs, network events, and Suricata alerts to the Wazuh server.

This enables complete monitoring of the 3 network segments with Wazuh and Suricata.

## Installation Steps

### 1. Enable SSH Access and Install Necessary Tools

1. **Enable SSH access** on pfSense (_Services > SSH_).
2. Connect via SSH to pfSense or access the VM console.

By default, the user is `root` with the web interface password `pfsense`.

### 2. System Preparation for Wazuh Agent

1. Check available disk space and ensure there is at least 300 MB free.
2. Modify pfSense configuration files to allow FreeBSD package installation:

```bash
nano /usr/local/etc/pkg/repos/pfSense.conf
```

Change 'no' to 'yes':

```bash
FreeBSD: { enabled: yes }
```

Do the same with the following file:

```bash
nano /usr/local/etc/pkg/repos/FreeBSD.conf
```

Change 'no' to 'yes':

```bash
FreeBSD: { enabled: yes }
```

1. Then update the pkg cache:

```bash
pkg update
```

2. Search for the official `wazuh-agent` package:

```bash
pkg search wazuh-agent
```

3. Next, install the previously displayed package:

```bash
# Replace X.XX.X with the obtained version
pkg install wazuh-agent-X.XX.X
```

4. Then restore default settings of previous files:

```bash
nano /usr/local/etc/pkg/repos/pfSense.conf
FreeBSD: { enabled: no }
nano /usr/local/etc/pkg/repos/FreeBSD.conf
FreeBSD: { enabled: no }

# Cleanup
pkg clean
pkg update
```

### 3. Agent Configuration

1. Copy the `/etc/localtime` file to `/var/ossec/etc/`

```bash
cp /etc/localtime /var/ossec/etc/
```

2. Then modify the agent configuration file:

```bash
nano /var/ossec/etc/ossec.conf
```

3. Add the Wazuh server IP address (LAN-SIEM-LIN) in it:

```xml
<server>
		<address>WAZUH-MANAGER-IP-ADDRESS</address>
</server>

<!-- If the server has IP 192.168.10.104 -->
<server>
		<address>192.168.10.104</address>
</server>
```

4. Enable the Wazuh agent at pfSense machine startup:

```bash
# Enable Wazuh agent at startup
sysrc wazuh_agent_enable="YES"

# Create a symbolic link to services to not delete any files
ln -s /usr/local/etc/rc.d/wazuh-agent /usr/local/etc/rc.d/wazuh-agent.sh
```

5. Then start the Wazuh agent:

```bash
service wazuh-agent start
```

After startup, verify its execution:

```bash
service wazuh-agent status
```

**Result obtained**:

![pfSense-Wazuh-status.png](/assets/images/Wazuh-setup/pfSense-Wazuh-status.png)

A new agent under the pfSense machine name should appear as below:

![pfSense-agent.png](/assets/images/Wazuh-setup/pfSense-agent.png)

### 4. Suricata Integration

**Objective**: Configure the Wazuh agent to monitor Suricata logs from the 3 interfaces (WAN, LAN, DMZ).

Steps:

1. **Modify the agent configuration file**:

```bash
nano /var/ossec/etc/ossec.conf
```

2. **Add the following section** under `<!-- Log analysis -->` to analyze Suricata logs:

```xml
<!-- Suricata EVE JSON -->
<localfile>
  <log_format>json</log_format>
  <location>/var/log/suricata/*/eve.json</location>
</localfile>
```

This allows the Wazuh agent to read and forward Suricata logs from the 3 interfaces.

3. Restart the agent:

```bash
service wazuh-agent stop
service wazuh-agent start

# Verification
service wazuh-agent status
```

You can also add pfSense logs (system and firewall):

```xml
<!-- pfSense system logs -->
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/system.log</location>
</localfile>

<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/filter.log</location>
</localfile>
```

### 5. Docker Container Monitoring (DMZ-WEB01-LIN)

**Objective**: Configure the Wazuh agent to monitor logs of Docker containers hosted on DMZ-WEB01-LIN (Juice Shop, WebGoat, NodeGoat, etc.).

> **Note**: Enabling Docker containers monitoring can generate a lot of noise. You can use custom rules to filter out the noise.

Steps:

1. **Edit the Wazuh agent configuration file**:

   ```bash
   sudo nano /var/ossec/etc/ossec.conf
   ```

2. **Add the following section** to monitor Docker container logs (JSON format):

   ```xml
   <!-- Docker log monitoring -->
   <localfile>
     <log_format>json</log_format>
     <location>/var/lib/docker/containers/*/*.log</location>
   </localfile>
   ```

3. **Restart the agent** to apply changes:

   ```bash
   sudo systemctl restart wazuh-agent
   ```

4. **Verify the agent status**:

   ```bash
   sudo systemctl status wazuh-agent
   ```

# Resources

[Wazuh Quick start](https://documentation.wazuh.com/current/quickstart.html)

[Integrating pfSense with Wazuh](https://benheater.com/integrating-pfsense-with-wazuh/)
