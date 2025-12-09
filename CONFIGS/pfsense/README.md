# pfSense Configuration

This directory contains the pfSense firewall configuration file for Lab4PurpleSec.

## config.xml

Complete pfSense configuration export that can be imported to quickly set up the firewall with all necessary rules, interfaces, and settings.

### ⚠️ Security Notice

**IMPORTANT:** The configuration file has been sanitized for security:

- ✅ **SSL certificates and private keys have been removed** - pfSense will automatically regenerate them on first boot
- ✅ **SSH private keys have been removed** - pfSense will automatically regenerate them on first boot
- ✅ **Default password hash is kept** - This is the default `admin:pfsense` password hash (intentional for lab purposes)

**You must change the default password after import!**

### What's Included

This configuration includes:

- **Network Interfaces:**

  - WAN (em0) - Bridge/DHCP
  - LAN (em1) - 192.168.10.1/24
  - DMZ (em2) - 192.168.20.1/24

- **Firewall Rules:**

  - WAN → DMZ (HTTP/HTTPS allowed)
  - WAN → LAN (blocked)
  - LAN → DMZ (all traffic allowed)
  - LAN → WAN (all traffic allowed)
  - DMZ → LAN (blocked, except Wazuh ports 1514, 1515)

- **NAT Rules:**

  - Port forwarding: WAN:80 → DMZ-WEB01-LIN:80

- **Suricata IDS/IPS:**

  - Configured on all three interfaces (WAN, LAN, DMZ)
  - Rule categories enabled
  - Alert logging configured

- **Host Aliases:**

  - DNS aliases for all lab machines (juice.lab, webgoat.lab, etc.)

- **DHCP Configuration:**
  - DHCP server enabled on LAN and DMZ segments

### Usage

#### Import Configuration

1. **Backup your current configuration** (if you have an existing pfSense installation):

   - Go to `Diagnostics > Backup/Restore` in the pfSense web interface
   - Create a full backup

2. **Import the configuration**:

   - Go to `Diagnostics > Backup/Restore` in the pfSense web interface
   - Select "Restore Configuration"
   - Upload the `config.xml` file
   - **Important:** Select "Full restore" to apply all settings
   - Click "Restore"

3. **After import**:
   - pfSense will automatically regenerate SSL certificates and SSH keys
   - **Change the default password immediately** (System > User Manager > admin)
   - Verify all network interfaces are correctly configured
   - Check firewall rules match your network setup
   - Verify NAT rules are active

#### Manual Configuration Alternative

If you prefer to configure pfSense manually, refer to `Docs/SETUP/pfsense_setup.md` for detailed step-by-step instructions.

### Customization

After importing, you may need to adjust:

- **Network interface assignments** (if your hardware differs from em0/em1/em2)
- **IP addresses** (if you use different subnets)
- **Firewall rules** (for custom scenarios)
- **Suricata rules** (for specific detection needs)
- **Host aliases** (if you add new machines)

### Troubleshooting

If the import fails or causes issues:

1. **Restore your previous backup** immediately
2. **Review error messages** in the pfSense logs (System > Logs)
3. **Check interface assignments** match your hardware
4. **Verify network segments** are configured correctly in your hypervisor
5. **Try importing section by section** (not recommended for beginners)
6. **Follow the manual configuration guide** in `Docs/SETUP/pfsense_setup.md`

### Post-Import Checklist

After successful import, verify:

- [ ] All three interfaces are assigned and active
- [ ] IP addresses are correct (192.168.10.1, 192.168.20.1)
- [ ] Firewall rules are present and enabled
- [ ] NAT rules are configured correctly
- [ ] Suricata is installed and running
- [ ] Host aliases are configured
- [ ] Default password has been changed
- [ ] SSL certificate has been regenerated (check System > Certificates)

### Security Best Practices

- ✅ **Always change default passwords** after import
- ✅ **Review firewall rules** to ensure they match your security requirements
- ✅ **Update Suricata rules** regularly
- ✅ **Keep pfSense updated** to the latest stable version
- ✅ **Never use this configuration in production** - it's designed for isolated lab environments only
- ✅ **Review and customize rules** based on your specific scenarios

### Configuration Details

For detailed information about:

- **Firewall rules**: See `ARCHITECTURE.md` and `Docs/SETUP/pfsense_setup.md`
- **NAT configuration**: See `Docs/SETUP/pfsense_setup.md`
- **Suricata setup**: See `Docs/SETUP/pfsense_setup.md`
- **Testing**: See `Docs/TESTS/pfSense.md`

---

**Important**: This configuration is for educational lab use only. Always review and customize security settings before using in any environment.
