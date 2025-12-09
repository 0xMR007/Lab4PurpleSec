# Configuration Files

This directory contains configuration files and templates for various Lab4PurpleSec components.

## Directory Structure

```
CONFIGS/
├── hosts                    # Static hosts file for /etc/hosts
├── pfsense/                # pfSense firewall configuration
│   └── config.xml          # Complete pfSense configuration (sanitized)
└── web-server/             # Web server configuration files
    ├── docker-compose.yml  # Docker Compose configuration
    └── nginx.conf          # Nginx reverse proxy configuration
```

## Configuration Files

### hosts

The `hosts` file contains static hostname-to-IP mappings for all lab machines. This file can be used to populate `/etc/hosts` on Linux machines for consistent name resolution.

**Usage:**

```bash
# Copy to /etc/hosts (backup first!)
sudo cp /etc/hosts /etc/hosts.backup
sudo cat CONFIGS/hosts >> /etc/hosts
```

**Note:** You can manually copy this file to `/etc/hosts` on each Linux machine, or configure DNS resolution according to your needs.

### pfsense/

Contains the pfSense firewall configuration file.

**config.xml** - Complete pfSense configuration export including:

- Network interface configuration (WAN, LAN, DMZ)
- Firewall rules
- NAT/port forwarding rules
- Suricata IDS/IPS configuration
- Host aliases
- DHCP settings

**⚠️ Security Notice:**

- SSL certificates and private keys have been removed (pfSense will regenerate them)
- SSH private keys have been removed (pfSense will regenerate them)
- Default password hash is kept (intentional for lab purposes)

**Usage:**
See `pfsense/README.md` for detailed import instructions.

### web-server/

Contains configuration files for the vulnerable web server (DMZ-WEB01-LIN).

**docker-compose.yml** - Docker Compose configuration defining:

- OWASP Juice Shop container
- OWASP WebGoat container
- bWAPP container
- NodeGoat container
- VAmPI container
- Network configuration
- Volume mounts

**nginx.conf** - Nginx reverse proxy configuration including:

- Virtual host definitions for each application
- Proxy pass rules
- Upstream server definitions
- SSL/TLS configuration (if applicable)

**Usage:**
See `Docs/SETUP/Web_server_setup.md` for detailed deployment instructions.

## Using Configuration Files

### Option 1: Manual Configuration

Follow the setup guides in `Docs/SETUP/` which reference these configuration files and explain how to use them.

### Option 2: Direct Import

Some configuration files (like `pfsense/config.xml`) can be directly imported into their respective systems. **Always backup existing configurations before importing.**

## Customization

These configuration files are provided as working examples. You can:

- ✅ Modify IP addresses to match your network
- ✅ Add additional services or applications
- ✅ Adjust firewall rules for custom scenarios
- ✅ Customize virtual hosts and routing

## Security Considerations

- **Never commit sensitive data** (passwords, keys, tokens) to these files
- **Review all configurations** before importing
- **Change default passwords** after deployment
- **Keep configurations updated** with security best practices

## File Formats

- **XML** - pfSense configuration
- **YAML** - Docker Compose configuration
- **Nginx config** - Nginx server configuration
- **Plain text** - Hosts file

## Backup Recommendations

Before modifying or importing configurations:

1. **Backup existing configurations**
2. **Test in isolated environment first**
3. **Document any customizations**
4. **Version control your changes** (if using Git)

---

**Note**: These configuration files are designed for isolated lab environments. Do not use them in production without thorough security review and customization.
