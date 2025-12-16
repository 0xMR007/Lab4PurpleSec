# Docker Role - Configuration Files

This directory contains the configuration files for Docker deployment.

## 📁 Files

1. **`docker-compose.yml`** - Docker Compose configuration file
2. **`nginx.conf`** - Nginx reverse proxy configuration

## 🔄 Synchronization

These files are **copies** from `CONFIGS/web-server/`.

To update:
1. Modify the files in `CONFIGS/web-server/`
2. Copy them here:
   ```powershell
   copy "..\..\..\..\CONFIGS\web-server\docker-compose.yml" .\docker-compose.yml
   copy "..\..\..\..\CONFIGS\web-server\nginx.conf" .\nginx.conf
   ```
3. Re-provision the VM:
   ```powershell
   vagrant provision dmz-web01-lin
   ```

## ℹ️ Note

The files in this directory are used by Ansible during provisioning.
The source of truth is found in `CONFIGS/web-server/`.
