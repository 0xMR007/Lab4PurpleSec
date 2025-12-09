<div align="center">
  <img src="../../assets/images/banners/Nginx-logo.png" alt="Nginx Logo"/>
</div>

# Web Server Setup

# Overview

This document explains how to configure the **web server** in the DMZ, using **Docker Compose** and **Nginx** as a reverse proxy to host several vulnerable web applications (OWASP Juice Shop, WebGoat, bWAPP, etc.). This configuration is designed for a lab environment dedicated to offensive security testing, in addition to an already configured pfSense firewall.

# Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Docker Compose](#docker-compose)
4. [Nginx Configuration](#nginx-configuration)
5. [Place Configuration Files](#place-configuration-files)
6. [Test Configuration](#test-configuration)
7. [Hosts File Configuration](#hosts-file-configuration-wan-side)

# Prerequisites

Before starting, ensure the following are in place:

- Have installed and configured the pfSense VM
- Have installed the web server (DMZ-WEB01-LIN)
- A dedicated user (ex: `webadmin`) with necessary permissions to manage containers and configuration files.

# Steps

## Docker Compose

This section details Docker container configuration to host vulnerable web applications, as well as Nginx reverse proxy setup.

### I. Docker Compose Installation

If not already done, install Docker Compose by following the [official documentation](https://docs.docker.com/compose/install/).

### **II. Create `docker-compose.yml` File**

After installing Docker Compose, create a file named `docker-compose.yml`.

This file defines the following services:

- **Nginx reverse proxy**: Routes traffic from WAN to applications based on hostnames.
- **Vulnerable web applications**: Juice Shop, WebGoat, bWAPP, NodeGoat, VAmPI.
- **Databases**: MongoDB containers for NodeGoat.

Content of the `docker-compose.yml` file:

```yaml
services:
  # ------------------------------
  # Nginx Server (reverse proxy)
  # ------------------------------
  proxy:
    image: nginx:alpine
    container_name: webapps-proxy
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - juice-shop
      - webgoat
      - bwapp
      - nodegoat
      - vampi
    networks:
      - default

  # ------------------------------
  # NodeGoat
  # ------------------------------
  nodegoat-db:
    image: mongo:4.4
    container_name: nodegoat-db
    restart: unless-stopped
    volumes:
      - nodegoat-db-data:/data/db

  nodegoat:
    build: ./nodegoat
    container_name: nodegoat
    depends_on:
      - nodegoat-db
    environment:
      - DB_HOST=nodegoat-db
      - DB_PORT=27017
      - VIRTUAL_HOST=nodegoat.lab
    volumes:
      - nodegoat-data:/usr/src/app/data
    restart: unless-stopped

  # ------------------------------
  # Juice Shop
  # ------------------------------
  juice-shop:
    image: bkimminich/juice-shop
    container_name: juice-shop
    environment:
      - VIRTUAL_HOST=juice.lab
    restart: unless-stopped

  # ------------------------------
  # WebGoat
  # ------------------------------
  webgoat:
    image: webgoat/webgoat
    container_name: webgoat
    environment:
      - VIRTUAL_HOST=webgoat.lab
      - VIRTUAL_PORT=8080
      - TZ=Europe/Paris
      - WEBGOAT_CONTEXT_PATH=/WebGoat
    expose:
      - "8080"
      - "9090"
    volumes:
      - webgoat-data:/home/webgoat
    restart: unless-stopped

  # ------------------------------
  # bWAPP
  # ------------------------------
  bwapp:
    image: raesene/bwapp
    container_name: bwapp
    environment:
      - VIRTUAL_HOST=bwapp.lab
    restart: unless-stopped
    volumes:
      - bwapp-data:/var/www/html

  # ------------------------------
  # VAmPI (Vulnerable API)
  # ------------------------------
  vampi:
    image: erev0s/vampi
    container_name: vampi
    environment:
      - VIRTUAL_HOST=vampi.lab
      - VIRTUAL_PORT=5000
    expose:
      - "5000"
    restart: unless-stopped

# ------------------------------
# Volumes
# ------------------------------
volumes:
  nodegoat-data:
  nodegoat-db-data:
  bwapp-data:
  webgoat-data:
```

### III. Start Containers

To start all containers defined in the `docker-compose.yml` file

```bash
docker compose up -d
```

## Nginx Configuration

This section describes Nginx reverse proxy configuration, which routes requests to applications based on defined hostnames.

### **I. Create `nginx.conf` File**

This file configures Nginx to:

- **Route traffic** to each application based on `server_name`.
- **Manage HTTP headers** for seamless integration.
- **Support external applications** (Metasploitable2, Metasploitable3).

> **Note**: These hostnames are arbitrary and can be replaced by any name you want. This is an example of the configuration for the lab.

Content of the `nginx.conf` file:

```bash
user  nginx;
worker_processes  auto;

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    # Logs (optional)
    access_log  /var/log/nginx/access.log;
    error_log   /var/log/nginx/error.log;

    # ------------------------------
    # 1. Juice Shop (default port)
    # ------------------------------
    server {
        listen 80;
        server_name juice.lab;
        location / {
            proxy_pass http://juice-shop:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }

    # ------------------------------
    # 2. WebGoat (default port)
    # ------------------------------
    server {
        listen 80;
        server_name webgoat.lab;

        location / {
            proxy_pass http://webgoat:8080/;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cookie_path /WebGoat /;
            proxy_redirect off;
        }
    }

    # ------------------------------
    # 3. WebWolf (default port)
    # ------------------------------
    server {
        listen 80;
        server_name webwolf.lab;

        location / {
            proxy_pass http://webgoat:9090/;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cookie_path /WebWolf /;
            proxy_redirect off;
        }
    }

    # ------------------------------
    # 4. bWAPP
    # ------------------------------
    server {
        listen 80;
        server_name bwapp.lab;
        location / {
            proxy_pass http://bwapp;
        }
    }

    # ------------------------------
    # 5. NodeGoat
    # ------------------------------
    server {
        listen 80;
        server_name nodegoat.lab;
        location / {
            proxy_pass http://nodegoat:4000;
        }
    }

    # ------------------------------
    # 6. VAmPI
    # ------------------------------
    server {
        listen 80;
        server_name vampi.lab;
        location / {
            proxy_pass http://vampi:5000;
        }
    }

    # ------------------------------
    # 7. Metasploitable2
    # ------------------------------
    server {
        listen 80;
        server_name ms2.lab;
        location / {
            proxy_pass http://192.168.20.104:80;
            proxy_set_header Host $host;
        }
    }

    server {
        listen 80;
        server_name ms2-8180.lab;
        location / {
            proxy_pass http://192.168.20.104:8180;
            proxy_set_header Host $host;
        }
    }

    # ------------------------------
    # 8. Metasploitable3 Linux
    # ------------------------------
    server {
        listen 80;
        server_name ms3linux.lab;
        location / {
            proxy_pass http://192.168.20.106:80;
            proxy_set_header Host $host;
        }
    }

    server {
        listen 80;
        server_name ms3linux-8080.lab;
        location / {
            proxy_pass http://192.168.20.106:8080;
            proxy_set_header Host $host;
        }
    }

    # ------------------------------
    # 9. Metasploitable3 Windows
    # ------------------------------
    server {
        listen 80;
        server_name ms3win.lab;
        location / { proxy_pass http://192.168.20.107:80; proxy_set_header Host $host; }
    }

    server {
        listen 80;
        server_name ms3win-8282.lab;
        location / { proxy_pass http://192.168.20.107:8282; proxy_set_header Host $host; }
    }

    server {
        listen 80;
        server_name ms3win-8484.lab;
        location / { proxy_pass http://192.168.20.107:8484; proxy_set_header Host $host; }
    }

    server {
        listen 80;
        server_name ms3win-4848.lab;
        location / { proxy_pass https://192.168.20.107:4848; proxy_set_header Host $host; }
    }

    server {
        listen 80;
        server_name ms3win-8585.lab;
        location / { proxy_pass http://192.168.20.107:8585; proxy_set_header Host $host; }
    }
}
```

## Place Configuration Files

- Create a `/opt/webapps` directory and place the `docker-compose.yml` and `nginx.conf` files there.
- Ensure the `webadmin` user has necessary permissions:

```bash
sudo chown -R webadmin:webadmin /opt/webapps
```

## Test Configuration

- Verify that containers are started:

```bash
docker ps
```

- Test access to applications via configured hostnames (e.g., `http://juice.lab`, `http://webgoat.lab`).

Consult test files in `Docs/TESTS/Web_server.md` to validate connectivity and proper reverse proxy operation.

> NodeGoat uses MongoDB in the `nodegoat-db` container.
>
> If the database is not correctly initialized (especially the counters collection), NodeGoat crashes, causing a 502 error via the Nginx proxy.
>
> To fix this error, initialize the `counters` collection in MongoDB.
>
> You can directly fix the NodeJS source code:
>
> ```bash
> docker exec -it nodegoat sh
>
> vi /home/node/app/app/data/user-dao.js
> ```
>
> Then fix the similar part:
>
> ```jsx
> this.getNextSequence = (name, callback) => {
>   db.collection("counters").findAndModify(
>     {
>       _id: name,
>     },
>     [],
>     {
>       $inc: {
>         seq: 1,
>       },
>     },
>     {
>       new: true,
>     },
>     (err, data) =>
>       err ? callback(err, null) : callback(null, data.value.seq)
>   );
> };
> ```

### **WAN-Side `hosts` File Configuration**

**Objective**: Allow resolution of vulnerable application domain names from the WAN network, by associating each hostname with the **public IP address** of your web server (DMZ-WEB01-LIN).

### **1. Why Modify the `hosts` File?**

- Vulnerable web applications (Juice Shop, WebGoat, etc.) are accessible via **virtual domain names** (e.g., `juice.lab`, `webgoat.lab`).
- Without this configuration, requests to these domain names would fail, as they are not resolved by a public DNS.
- This step is **mandatory** to access applications from the WAN (or from a machine external to the lab).

### **2. Configuration**

1. **Open the `hosts` file**:
   - **On Linux**:
     ```bash
     sudo nano /etc/hosts
     ```
   - **On Windows**:
     - Open `Notepad` as administrator.
     - Go to `C:\Windows\System32\drivers\etc\hosts`.
2. **Add the following entries** (replace `<WAN_IP_ADDRESS>` with your **WAN IP** of the pfSense machine):

   ```
   # Vulnerable web applications (adapt with your WAN IP of the pfSense machine)
   <WAN_IP_ADDRESS> juice.lab nodegoat.lab bwapp.lab vampi.lab webgoat.lab webwolf.lab
   <WAN_IP_ADDRESS> ms2.lab ms2-8180.lab
   <WAN_IP_ADDRESS> ms3linux.lab ms3linux-8080.lab
   <WAN_IP_ADDRESS> ms3win.lab ms3win-8282.lab ms3win-8484.lab ms3win-4848.lab ms3win-8585.lab

   ```

   **Example** (if WAN IP of the pfSense machine is `192.168.1.100`):

   ```
   192.168.1.100 juice.lab nodegoat.lab bwapp.lab vampi.lab webgoat.lab webwolf.lab
   192.168.1.100 ms2.lab ms2-8180.lab
   192.168.1.100 ms3linux.lab ms3linux-8080.lab
   192.168.1.100 ms3win.lab ms3win-8282.lab ms3win-8484.lab ms3win-4848.lab ms3win-8585.lab

   ```

3. **Save the file** and restart the network service if necessary:

   - **Linux**:

     ```bash
     sudo systemctl restart networking  # or `sudo systemctl restart NetworkManager`

     ```

   - **Windows**:
     - Run `ipconfig /flushdns` in a command prompt (admin).

### **3. Configuration Verification**

- **Test DNS resolution** from your WAN machine:
  ```bash
  ping juice.lab
  ```
  - **Expected result**: The command should return the configured WAN IP of the pfSense machine (e.g., `192.168.1.100`).
- **Access applications** via a browser:
  - Open `http://juice.lab` or `http://webgoat.lab` in a browser.
  - **Expected result**: Applications should display without resolution errors.

### **4. Troubleshooting**

- **Resolution problem**:
  - Verify that the `hosts` file has been modified with **correct permissions** (admin/root).
  - Ensure the **WAN IP** is correct (that of `FW-PFSENSE` WAN interface).
- **Blocked access**:
  - Verify **NAT rules** on pfSense (port 80 must be redirected to `DMZ-WEB01-LIN`).
  - Ensure **Nginx** is running on the server:
    ```bash
    # Verify that the `webapps-proxy` container is "Up"
    docker ps
    ```

### **5. Important Notes**

- **Security**:
  - This configuration is **reserved for a lab environment**. In production, use a **real DNS** or a service like `dnsmasq` to manage resolution.
  - The `.lab` domain names are arbitrary and can be replaced by others (e.g., `.test`, `.local`).
- **Persistence**:
  - `hosts` file modifications are **local** to each machine. For access from multiple WAN machines, repeat this configuration on each of them.
- **Alternative**:
  - To avoid manually modifying each machine, configure a **local DNS server** (e.g., `dnsmasq`) to automatically resolve these domain names.

For machines in the LAN segment, you can use the following `hosts` file:

```
# LAN
192.168.10.100 test.lab LAN-TEST-LIN
192.168.10.104 siem.lab LAN-SIEM-LIN
192.168.10.109 attack.lab LAN-ATTACK-LIN
192.168.10.30 minilab.dc LAN-DC01-WIN
192.168.10.31 minilab.ws01 LAN-WS01-WIN

# DMZ
192.168.20.105 vuln-web.lab DMZ-WEB01-LIN
192.168.20.105 juice.lab bwapp.lab nodegoat.lab webgoat.lab vampi.lab
192.168.20.104 metasploitable2 ms2 DMZ-MS2-LIN
192.168.20.106 metasploitable3-lin ms3-lin DMZ-MS3-LIN
192.168.20.107 metasploitable3-win ms3-win DMZ-MS3-WIN

# pfSense (LAN)
192.168.10.1 pfsense.lab pfsense.Lab4PurpleSec
```

# Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/install/)
- [Configure Nginx as Reverse Proxy](https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-reverse-proxy-on-ubuntu-22-04)
