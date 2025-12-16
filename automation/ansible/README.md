# Ansible Configuration

## Directory Structure

```
ansible/
├── ansible.cfg          # Ansible configuration
├── inventory.yml        # Inventory file (actually in parent directory)
├── playbooks/          # Playbooks directory
│   ├── site.yml
│   ├── base-setup.yml
│   └── applications.yml
├── roles/               # Roles directory
│   ├── common/
│   ├── linux-base/
│   └── ...
├── group_vars/          # Group variables
└── host_vars/           # Host variables
```

## Running Ansible

### From WSL (Recommended on Windows)

```bash
# Set UTF-8 locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Navigate to ansible directory
cd automation/ansible

# Run playbook
ansible-playbook -i ../inventory.yml playbooks/site.yml
```

### From Linux/macOS

```bash
cd automation/ansible
ansible-playbook -i ../inventory.yml playbooks/site.yml
```

## Configuration Notes

- **Inventory**: Located in parent directory (`../inventory.yml`)
- **Roles**: Located in parent directory (`../roles`)
- **Playbooks**: Located in `playbooks/` subdirectory

This structure allows running Ansible from the `ansible/` directory while keeping inventory and roles accessible.

## Inventories Explained

This project provides multiple inventory files for different use cases. Understanding which inventory to use is important for successful Ansible execution.

### Available Inventories

1. **`../inventory.yml`** (Static Inventory - Recommended for Manual Execution)

   - **Location:** `automation/inventory.yml`
   - **Use Case:** Manual Ansible execution from host machine
   - **Features:**
     - Uses Vagrant SSH port forwarding (127.0.0.1:port)
     - References Vagrant-generated SSH keys in `.vagrant/machines/.../private_key`
     - Ports are static but may need adjustment (check with `vagrant ssh-config`)
     - In case of a public key error, you can use the Powershell script to change the permissions of the private key file. See `Scripts/set-ssh-perms.ps1`.
   - **Usage:**
     ```bash
     cd automation/ansible
     ansible-playbook -i ../inventory.yml playbooks/site.yml
     ```

2. **`inventory-vagrant.yml`** (Static Inventory - Alternative)

   - **Location:** `automation/ansible/inventory-vagrant.yml`
   - **Use Case:** Alternative static inventory with different key paths
   - **Features:**
     - Uses Vagrant SSH port forwarding (127.0.0.1:port)
     - References `~/.vagrant.d/insecure_private_key` (Vagrant default)
     - Ports are static but may need adjustment
   - **Usage:**
     ```bash
     cd automation/ansible
     ansible-playbook -i inventory-vagrant.yml playbooks/site.yml
     ```

3. **`inventory-vagrant.py`** (Dynamic Inventory - Recommended)

   - **Location:** `automation/ansible/inventory-vagrant.py`
   - **Use Case:** Automatic discovery of Vagrant VMs and SSH configuration
   - **Features:**
     - Automatically queries `vagrant ssh-config` for current ports and keys
     - Always up-to-date with current Vagrant state
     - Handles port changes automatically
     - Works best when VMs are running
   - **Usage:**
     ```bash
     cd automation/ansible
     ansible-playbook -i inventory-vagrant.py playbooks/site.yml
     ```
   - **Requirements:** Python 3, Vagrant must be in PATH

4. **`inventory-local.yml`** (For ansible_local Provisioning)
   - **Location:** `automation/ansible/inventory-local.yml`
   - **Use Case:** Used internally by Vagrant's `ansible_local` provisioner
   - **Features:**
     - Runs from inside the VM
     - Uses `localhost` or VM hostname
     - Not intended for manual execution
   - **Note:** This inventory is used automatically by Vagrant during provisioning

### Which Inventory Should I Use?

**For Manual Ansible Execution:**

- **Recommended:** `inventory-vagrant.py` (dynamic, always current)
- **Alternative:** `../inventory.yml` (static, may need port updates)

**For Vagrant Provisioning:**

- Automatically uses `inventory-local.yml` via `ansible_local`
- No manual action required

### Updating Static Inventories

If you use a static inventory and ports change:

1. **Get current ports:**

   ```bash
   vagrant ssh-config
   ```

2. **Update inventory file** with correct ports:

   ```yaml
   ansible_port: 2200 # Update this value
   ```

3. **Or use dynamic inventory** to avoid this step:
   ```bash
   ansible-playbook -i inventory-vagrant.py playbooks/site.yml
   ```

### Inventory Structure

All inventories follow the same structure:

- **Groups:** `dmz`, `lan`, `wan`, `web_servers`, `siem`, `attack_machines`
- **Hosts:** Only internal VMs (not external VMs like GOAD or Metasploitable)
- **SSH Configuration:** Port forwarding via 127.0.0.1:port

**Note:** External VMs (GOAD, Metasploitable, pfSense) are NOT included in Ansible inventories as they are managed separately.

## Testing Connection

Before running playbooks, test the connection to VMs:

```bash
# Test ping to all VMs
ansible all -i ../inventory.yml -m ping

# Test specific VM
ansible dmz-web01-lin -i ../inventory.yml -m ping
```

**Important:** The inventory uses SSH port forwarding (127.0.0.1:port) because VMs are on internal networks not accessible from Windows host.

See `TEST_CONNECTION.md` for detailed connection testing guide.

## Troubleshooting

### Script Inventory Error: "python3\r: No such file or directory"

**Problem:** The Python inventory script has Windows line endings (CRLF) instead of Unix (LF).

**Solution:**

```bash
# In WSL, convert line endings
dos2unix inventory-vagrant.py

# Or with sed
sed -i 's/\r$//' inventory-vagrant.py
```

**Note:** A `.gitattributes` file has been added to prevent this issue in the future.

### Connection Refused or Timeout

**Problem:** Ansible can't connect to VMs.

**Solution:**

1. Verify VMs are running: `vagrant status`
2. Check SSH ports: `vagrant ssh-config`
3. Verify inventory uses port forwarding (127.0.0.1:port), not static IPs
4. Use dynamic inventory: `ansible-playbook -i inventory-vagrant.py playbooks/site.yml`

### Public Key Error

**Problem:** The public key is not allowed to connect to the VM.

**Solution:**

1. Check the permissions of the private key file (under .vagrant/machines/<vm>/virtualbox/private_key).
2. Use the Powershell script to change the permissions of the private key file. See `Scripts/set-ssh-perms.ps1`.

See `TEST_CONNECTION.md` for detailed troubleshooting.

### Roles Not Found

If you get "role 'common' was not found":

1. Check you're in the `ansible/` directory
2. Verify `ansible.cfg` has correct `roles_path = ../roles`
3. Check roles exist: `ls -la ../roles/`

### World-Writable Directory Warning

This warning appears when running from WSL on Windows filesystems. It's safe to ignore, but you can:

- Run from a Linux filesystem (not `/mnt/`)
- Or the warning is suppressed in `ansible.cfg`

### Inventory Not Found

Make sure you're using the correct inventory path:

```bash
ansible-playbook -i ../inventory.yml playbooks/site.yml
```

The inventory is in the parent directory (`automation/inventory.yml`).

---

**Last Updated:** V1 - Configuration corrected for WSL/Windows compatibility
