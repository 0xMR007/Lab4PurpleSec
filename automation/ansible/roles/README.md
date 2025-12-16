# Ansible Roles Documentation

## Overview

This directory contains Ansible roles for automating the configuration of Lab4PurpleSec components.

## Base Roles

### common

Applies common configuration to all hosts:
- User management and SSH keys
- NTP configuration
- Timezone setup
- Basic packages installation
- SSH configuration
- /etc/hosts updates

**Usage:**
```yaml
roles:
  - common
```

**Variables:** See `common/defaults/main.yml`

### linux-base

Applies Linux-specific base configuration:
- Network tools installation
- Docker installation and configuration
- Firewall helpers (UFW/firewalld)
- System utilities

**Usage:**
```yaml
roles:
  - linux-base
```

**Variables:** See `linux-base/defaults/main.yml`

### windows-base

Windows-specific base configuration (placeholder for future use):
- WinRM configuration
- PowerShell execution policy
- Windows updates (optional)
- Chocolatey (optional)

**Usage:**
```yaml
roles:
  - windows-base
```

**Variables:** See `windows-base/defaults/main.yml`

## Application Roles

### nginx

Installs and configures Nginx reverse proxy.

**Features:**
- Nginx installation
- Virtual host configuration
- Reverse proxy setup
- SSL/TLS support (optional)

**Usage:**
```yaml
roles:
  - nginx
```

**Variables:** See `nginx/defaults/main.yml`

**Example configuration:**
```yaml
nginx_enabled: true
nginx_config_file: "../../CONFIGS/web-server/nginx.conf"
```

### docker

Deploys Docker applications using docker-compose.

**Features:**
- Docker Compose file deployment
- Image pulling
- Service management
- Volume management

**Usage:**
```yaml
roles:
  - docker
```

**Variables:** See `docker/defaults/main.yml`

**Example configuration:**
```yaml
docker_enabled: true
docker_compose_file: "../../CONFIGS/web-server/docker-compose.yml"
docker_compose_dir: "/opt/docker-compose"
```

**Note:** Docker installation is handled by `linux-base` role. This role focuses on application deployment.

### wazuh

Installs and configures Wazuh SIEM Manager and agents.

**Features:**
- Wazuh Manager installation
- Wazuh Agent installation
- Wazuh Dashboard installation
- Configuration management
- Service management

**Usage:**
```yaml
roles:
  - wazuh
```

**Variables:** See `wazuh/defaults/main.yml`

**Example configuration:**
```yaml
wazuh_manager_enabled: true
wazuh_manager_ip: "192.168.10.104"
wazuh_dashboard_enabled: true
wazuh_agent_enabled: false
```

**Important:** Wazuh requires significant resources (4GB+ RAM recommended).

### suricata

Installs and configures Suricata IDS/IPS.

**Features:**
- Suricata installation
- Configuration deployment
- Rule updates
- Service management

**Usage:**
```yaml
roles:
  - suricata
```

**Variables:** See `suricata/defaults/main.yml`

**Note:** Suricata is typically installed on pfSense, not on VMs. This role is provided for potential VM-based deployment or testing.

## Role Structure

Each role follows the standard Ansible role structure:

```
role-name/
├── tasks/
│   └── main.yml          # Main tasks
├── handlers/
│   └── main.yml          # Handlers (service restarts, etc.)
├── defaults/
│   └── main.yml          # Default variables
├── templates/            # Jinja2 templates (if needed)
│   └── template.j2
└── README.md            # Role-specific documentation (if needed)
```

## Using Roles in Playbooks

### Example: Base Setup

```yaml
---
- name: Base system setup
  hosts: all
  become: yes
  roles:
    - common
    - linux-base
```

### Example: Web Server Setup

```yaml
---
- name: Web server configuration
  hosts: web_servers
  become: yes
  roles:
    - docker
    - nginx
```

### Example: SIEM Setup

```yaml
---
- name: SIEM configuration
  hosts: siem
  become: yes
  roles:
    - wazuh
```

## Variable Precedence

Variables can be defined at multiple levels (in order of precedence):

1. **Command line** (`-e` or `--extra-vars`)
2. **Host variables** (`host_vars/hostname.yml`)
3. **Group variables** (`group_vars/group.yml`)
4. **Role defaults** (`roles/role-name/defaults/main.yml`)

## Best Practices

1. **Use role defaults** for standard configuration
2. **Override in host_vars** for host-specific settings
3. **Use group_vars** for segment-specific settings (DMZ, LAN, etc.)
4. **Keep secrets out of playbooks** - use Ansible Vault for sensitive data
5. **Test roles individually** before combining in playbooks
6. **Document custom variables** in role README files

## Troubleshooting

### Role Not Executing

- Check if role is listed in playbook
- Verify host is in correct group
- Check variable conditions (when: clauses)

### Variables Not Working

- Verify variable precedence
- Check variable names match exactly
- Use `-v` flag to see variable values

### Services Not Starting

- Check handlers are triggered
- Verify service names are correct
- Check system logs for errors

## Next Steps

- Review role-specific documentation in each role directory
- Test roles individually using test playbooks
- Customize variables for your environment
- See `../TESTING.md` for testing procedures

---

**Last Updated:** Phase F - Application roles implemented

