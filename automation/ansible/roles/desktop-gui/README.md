# Desktop GUI Role

This Ansible role installs and configures a graphical desktop environment on Ubuntu-based systems.

## Description

Installs a desktop environment (Gnome, XFCE, etc.) optimized for virtual machine usage, with automatic login and performance optimizations.

## Requirements

- Ubuntu 20.04 or later
- At least 4 GB RAM (6 GB recommended for Gnome)
- VirtualBox (for GUI display)

## Role Variables

### Main Configuration

| Variable                      | Default         | Description                                                       |
| ----------------------------- | --------------- | ----------------------------------------------------------------- |
| `desktop_gui_enabled`         | `false`         | Enable/disable desktop GUI installation                           |
| `desktop_gui_environment`     | `gnome-minimal` | Desktop environment to install (`gnome`, `gnome-minimal`, `xfce`) |
| `desktop_gui_display_manager` | `gdm3`          | Display manager (`gdm3`, `lightdm`)                               |

### Auto-Login

| Variable                        | Default   | Description            |
| ------------------------------- | --------- | ---------------------- |
| `desktop_gui_autologin_enabled` | `true`    | Enable automatic login |
| `desktop_gui_autologin_user`    | `vagrant` | User for auto-login    |

### Applications

| Variable                     | Default      | Description                            |
| ---------------------------- | ------------ | -------------------------------------- |
| `desktop_gui_install_apps`   | `true`       | Install additional GUI applications    |
| `desktop_gui_extra_packages` | See defaults | List of additional packages to install |

### Performance

| Variable                         | Default | Description                                  |
| -------------------------------- | ------- | -------------------------------------------- |
| `desktop_gui_disable_animations` | `true`  | Disable animations for better VM performance |
| `desktop_gui_disable_tracker`    | `true`  | Disable GNOME file indexing                  |

## Example Configuration

### In `host_vars/lan-test-lin.yml`:

```yaml
# Desktop GUI configuration
desktop_gui_enabled: true
desktop_gui_environment: "gnome-minimal"
desktop_gui_autologin_enabled: true
desktop_gui_autologin_user: "vagrant"
desktop_gui_install_apps: true
```

### In `Vagrantfile`:

```ruby
"lan-test-lin" => {
  :box => "ubuntu/jammy64",
  :ip => "192.168.10.100",
  :memory => 6144,  # Gnome requires more RAM
  :cpus => 2,
  :gui => true      # Enable VirtualBox GUI
}
```

## Usage

### In a Playbook

```yaml
- name: Configure desktop machines
  hosts: test_machines
  become: yes
  roles:
    - desktop-gui
```

### With Vagrant

```bash
# Provision with GUI
vagrant up lan-test-lin

# After provisioning, reboot to start GUI
vagrant reload lan-test-lin
```

## Desktop Environments

### Gnome Minimal (Recommended for VMs)

```yaml
desktop_gui_environment: "gnome-minimal"
```

- **Pros**: Lighter, faster in VMs, modern interface
- **RAM**: 4-6 GB recommended
- **Packages**: ~1.5 GB

### Gnome Full

```yaml
desktop_gui_environment: "gnome"
```

- **Pros**: Complete Ubuntu Desktop experience
- **RAM**: 6-8 GB recommended
- **Packages**: ~3 GB

### XFCE (Lightweight)

```yaml
desktop_gui_environment: "xfce"
```

- **Pros**: Very lightweight, fast in VMs
- **RAM**: 2-4 GB recommended
- **Packages**: ~800 MB

## Performance Optimizations

The role automatically applies VM-specific optimizations:

1. ✅ **Disables animations** for smoother experience
2. ✅ **Disables file indexing** (GNOME Tracker)
3. ✅ **Uses X11 instead of Wayland** for better compatibility
4. ✅ **Configures auto-login** to skip login screen
5. ✅ **Installs VirtualBox Guest Additions dependencies**

## Post-Installation

After provisioning:

1. **Reboot the VM**:

   ```bash
   vagrant reload lan-test-lin
   ```

2. **Access the GUI**:

   - VirtualBox GUI window will open
   - Auto-login will log you in as `vagrant` user
   - Desktop environment ready to use

3. **Install VirtualBox Guest Additions** (optional, for better integration):
   ```bash
   vagrant ssh lan-test-lin
   sudo apt install virtualbox-guest-additions-iso
   ```

## Troubleshooting

### GUI doesn't start after reboot

```bash
# Check display manager status
vagrant ssh lan-test-lin
sudo systemctl status gdm3

# Check graphical target
sudo systemctl get-default  # Should be graphical.target
```

### Low resolution / display issues

```bash
# Install VirtualBox Guest Additions
vagrant ssh lan-test-lin
sudo apt install virtualbox-guest-x11
sudo reboot
```

### High CPU/RAM usage

Try switching to a lighter desktop environment:

```yaml
desktop_gui_environment: "xfce"
```

## Dependencies

This role has no dependencies on other roles, but it's recommended to run it after:

- `common` (base system configuration)
- `linux-base` (system utilities)

## License

MIT

## Author

Lab4PurpleSec Project
