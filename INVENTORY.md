# Inventory

# Overview

This document inventories the lab configuration, its educational objectives, network segmentation, and the assortment of vulnerable machines and attack/defense tools set up for **Lab4PurpleSec**.

# Inventory

The lab consists of several machines distributed across DMZ, LAN, and WAN segments to simulate a realistic enterprise architecture.

Each VM has a specific role: vulnerable target, attack machine, monitoring, AD machines, etc.

The following information summarizes all hosts, their interfaces, IP addresses, operating systems, and their role in the lab.

## Host List

This section lists each lab host, by network segment, with their interfaces, OS, IP address, and a brief description.

### DMZ Segment

| Hostname      | Interface | IP Address     | OS                                                  | Role/Description                             |
| ------------- | --------- | -------------- | --------------------------------------------------- | -------------------------------------------- |
| DMZ-MS2-LIN   | DMZ       | 192.168.20.104 | Ubuntu 8.04 (i386)                                  | Metasploitable2 vulnerable machine           |
| DMZ-MS3-LIN   | DMZ       | 192.168.20.106 | Ubuntu 14.04 (AMD64)                                | Metasploitable3 vulnerable machine (Linux)   |
| DMZ-MS3-WIN   | DMZ       | 192.168.20.107 | Windows Server 2008 R2 Standard Edition SP1 (AMD64) | Metasploitable3 vulnerable machine (Windows) |
| DMZ-WEB01-LIN | DMZ       | 192.168.20.105 | Debian 12 (AMD64)                                   | Vulnerable web server (with Docker compose)  |

### LAN Segment

| Hostname       | Interface | IP Address     | OS                                        | Role/Description                              |
| -------------- | --------- | -------------- | ----------------------------------------- | --------------------------------------------- |
| LAN-ATTACK-LIN | LAN       | 192.168.10.109 | Kali Linux (6.2.33)                       | Kali attack machine                           |
| LAN-DC01-WIN   | LAN       | 192.168.10.30  | Windows Server 2019 Datacenter Evaluation | Active Directory domain controller (mini.lab) |
| LAN-SIEM-LIN   | LAN       | 192.168.10.104 | Ubuntu 22.04 LTS                          | Wazuh Manager server                          |
| LAN-WS01-WIN   | LAN       | 192.168.10.31  | Windows 10 Enterprise Evaluation          | Windows 10 client workstation (mini.lab)      |
| LAN-TEST-LIN   | LAN       | 192.168.10.100 | Ubuntu 22.04.1                            | Test machine (administration)                 |

### WAN Segment

| Hostname       | Interface | IP Address    | OS                  | Role/Description          |
| -------------- | --------- | ------------- | ------------------- | ------------------------- |
| WAN-ATTACK-LIN | WAN       | DHCP (Bridge) | Kali Linux (6.2.33) | Kali attack machine (WAN) |

### pfSense

| Hostname   | Interface | IP Address      | Description                           |
| ---------- | --------- | --------------- | ------------------------------------- |
| FW-PFSENSE | WAN       | DHCP (Bridge)   | pfSense router/firewall WAN interface |
| FW-PFSENSE | LAN       | 192.168.10.1/24 | pfSense router/firewall LAN interface |
| FW-PFSENSE | DMZ       | 192.168.20.1/24 | pfSense router/firewall DMZ interface |

## Services

Each machine exposes a series of vulnerable services by default.

Below is the structured list of accessible ports/services for each VM in the lab.

### DMZ-WEB01-LIN

| **Port** | **Service**  | **Description**                                                                |
| -------- | ------------ | ------------------------------------------------------------------------------ |
| 22       | SSH          | Secure remote access for admin, potentially brute-force target.                |
| 80       | HTTP (nginx) | Main web server, Nginx proxy, vulnerable web applications for OWASP exercises. |

> **Note**: The Nginx reverse proxy is configured to expose all vulnerable web applications via dedicated virtual hosts, simplifying access and management of different applications. See `ARCHITECTURE.md` for more details. Below is the list of vulnerable web applications accessible via the reverse proxy (if accessed from the WAN).

### Vulnerable Web Services

The table below references all intentionally vulnerable web applications accessible via the reverse proxy, covering a wide spectrum of technologies and OWASP vulnerabilities.

| Machine       | Virtual Host      | Port | Service         | Description                                                                |
| ------------- | ----------------- | ---- | --------------- | -------------------------------------------------------------------------- |
| DMZ-WEB01-LIN | juice.lab         | 3000 | Juice Shop      | OWASP Juice Shop – vulnerable web application                              |
| DMZ-WEB01-LIN | webgoat.lab       | 8080 | WebGoat         | OWASP WebGoat – vulnerable Java web application                            |
| DMZ-WEB01-LIN | webwolf.lab       | 9090 | WebWolf         | WebGoat attack application                                                 |
| DMZ-WEB01-LIN | bwapp.lab         | 80   | bWAPP           | bWAPP – vulnerable PHP web application                                     |
| DMZ-WEB01-LIN | nodegoat.lab      | 4000 | NodeGoat        | NodeGoat – vulnerable Node.js application                                  |
| DMZ-WEB01-LIN | vampi.lab         | 5000 | VAmPI (API)     | Vulnerable REST API                                                        |
| DMZ-MS2-LIN   | ms2.lab           | 80   | Web (MS2)       | Metasploitable2 – Vulnerable web services (phpMyAdmin, Webdav, DVWA, etc…) |
| DMZ-MS2-LIN   | ms2-8180.lab      | 8180 | Web (MS2 alt)   | Metasploitable2 – Old Apache Tomcat web server                             |
| DMZ-MS3-WIN   | ms3win.lab        | 80   | Web (MS3 Win)   | Metasploitable3 (Windows) – web service (demo)                             |
| DMZ-MS3-WIN   | ms3win-8282.lab   | 8282 | Web (MS3 Win)   | Metasploitable3 (Windows) – More recent Apache Tomcat web server           |
| DMZ-MS3-WIN   | ms3win-8484.lab   | 8484 | Web (MS3 Win)   | Metasploitable3 (Windows) – Jenkins portal                                 |
| DMZ-MS3-WIN   | ms3win-4848.lab   | 4848 | Admin Console   | Metasploitable3 (Windows) – Oracle GlassFish admin console                 |
| DMZ-MS3-WIN   | ms3win-8585.lab   | 8585 | Web (MS3 Win)   | Metasploitable3 (Windows) – WampServer web server                          |
| DMZ-MS3-LIN   | ms3linux.lab      | 80   | Web (MS3 Linux) | Metasploitable3 (Linux) – Vulnerable web services (chat app, drupal, etc…) |
| DMZ-MS3-LIN   | ms3linux-8080.lab | 8080 | Web (MS3 Linux) | Metasploitable3 (Linux) – Old Continuum web service                        |

### DMZ-MS2-LIN

| **Port**    | **Service**   | **Description**                                                                 |
| ----------- | ------------- | ------------------------------------------------------------------------------- |
| 21          | FTP           | File transfer service, vulnerable to exploitation (anonymous login, RCE).       |
| 22          | SSH           | Secure remote access, brute-force and weak key attacks possible.                |
| 23          | Telnet        | Plain text remote console, login recovery by sniffing or brute-force.           |
| 25          | SMTP          | Email server, exploitable for user enumeration and relay attacks.               |
| 53          | DNS           | Local name resolution, often a vector for domain spoofing/fuzzing.              |
| 80          | HTTP (WebDAV) | Web server with multiple vulnerable apps (phpMyAdmin, DVWA, etc.), upload/RCE.  |
| 111         | RPCbind       | Remote Unix services                                                            |
| 139/445     | Samba (SMB)   | Vulnerable file sharing                                                         |
| 512/513/514 | r-Services    | Legacy Unix remote services, shell or login access via weak protocols.          |
| 1099        | Java RMI      | Java network interface, remote code execution.                                  |
| 1524        | Bindshell     | Backdoor shell for direct root access, demonstrates persistent access.          |
| 2049        | NFS           | Network file sharing, local escalation and data extraction.                     |
| 3306        | MySQL         | Exposed database, brute-force and credential extraction.                        |
| 5432        | PostgreSQL    | Vulnerable database, demonstrates database exploitation.                        |
| 5900        | VNC           | Remote graphical control, easy desktop VM access without strong authentication. |
| 6000        | X11           | Remote display server, often usable for local attacks or listening.             |
| 6667/6697   | IRC           | Chat server susceptible to backdooring, C&C/DDoS attacks.                       |
| 8009        | AJP13         | Java web/backend protocol, Java application exploitation testing.               |
| 8180        | Apache Tomcat | Java web application, demonstrates RCE/JSP upload exploitation.                 |

### DMZ-MS3-LIN

| **Port** | **Service**   | **Description**                                                                     |
| -------- | ------------- | ----------------------------------------------------------------------------------- |
| 21       | FTP (ProFTPD) | FTP service with known vulnerabilities, upload/deposit of backdoors possible.       |
| 22       | SSH           | Remote administration, test weak passwords/SSH key attacks.                         |
| 80       | Apache HTTP   | Web server hosting vulnerable business apps (Drupal, Payroll, etc.).                |
| 445      | Samba (SMB)   | Network file sharing, vector for lateral movement Windows/Linux (credential reuse). |
| 3306     | MySQL         | Weakly secured database, brute-force and information extraction.                    |
| 8080     | Jetty (HTTP)  | Jetty Java backend application.                                                     |

### DMZ-MS3-WIN

| **Port**    | **Service**           | **Description**                                                         |
| ----------- | --------------------- | ----------------------------------------------------------------------- |
| 21          | FTP                   | Windows FTP, default configuration, vector for payload/exploit deposit. |
| 22          | SSH                   | Remote access, demonstrates brute-force possible on Windows.            |
| 80          | HTTP (IIS)            | IIS web server, hosting vulnerable PHP/ASP applications, upload/RCE.    |
| 135/139/445 | Windows RPC/SMB       | Sharing and administration services, lateral movement and exploitation. |
| 3306        | MySQL                 | Windows database, authentication weaknesses and injections.             |
| 3389        | RDP                   | Remote desktop, attack surface via weak accounts or RDP exploits.       |
| 4848        | GlassFish Admin       | Oracle GlassFish administration console                                 |
| 7676        | GlassFish HTTP        | GlassFish HTTP server                                                   |
| 8009        | AJP13                 | AJP (Apache JServ Protocol)                                             |
| 8080        | Tomcat HTTP           | Apache Tomcat web server                                                |
| 8181        | GlassFish HTTPS       | GlassFish HTTPS server                                                  |
| 8383        | GlassFish Admin HTTPS | Secure GlassFish administration console                                 |
| 9200        | JSON Ultron           | Management or monitoring API, exposed endpoint testing.                 |
| 49152+      | Windows RPC dynamic   | Windows administration ports, lateral movement testing, AD exploits.    |

### LAN-DC01-WIN

| **Port**        | **Service**      | **Description**                                  |
| --------------- | ---------------- | ------------------------------------------------ |
| 53/tcp          | domain           | Domain controller DNS service (Active Directory) |
| 88/tcp          | kerberos-sec     | Kerberos authentication for AD                   |
| 135/tcp         | msrpc            | Microsoft RPC, used by many Windows services     |
| 139/tcp         | netbios-ssn      | File sharing via NetBIOS/SMB                     |
| 389/tcp         | ldap             | LDAP, Active Directory directory                 |
| 445/tcp         | microsoft-ds     | SMB service used for file sharing                |
| 464/tcp         | kpasswd5         | Kerberos password change                         |
| 593/tcp         | http-rpc-epmap   | RPC over HTTP, endpoint mapping                  |
| 636/tcp         | ldapssl          | Secure LDAP (SSL/TLS)                            |
| 3268/tcp        | globalcatLDAP    | Global Catalog LDAP for AD                       |
| 3269/tcp        | globalcatLDAPssl | Secure Global Catalog LDAP (SSL/TLS)             |
| 3389/tcp        | ms-wbt-server    | Remote desktop (RDP)                             |
| 5357/tcp        | wsdapi           | Web Services for Devices API                     |
| 5985/tcp        | wsman            | Windows Remote Management (HTTP)                 |
| 5986/tcp        | wsmans           | Secure Windows Remote Management (HTTPS)         |
| 9389/tcp        | adws             | AD Web Services                                  |
| 47001/tcp       | winrm            | Windows Remote Management                        |
| 49664-49674/tcp | unknown          | Dynamic RPC ports used by Windows                |
| 49677/tcp       | unknown          | Dynamic RPC port                                 |
| 49688/tcp       | unknown          | Dynamic RPC port                                 |
| 49823/tcp       | unknown          | Dynamic RPC port                                 |
| 50000/tcp       | ibm-db2          | IBM DB2 service                                  |

### LAN-WS01-WIN

| **Port**        | **Service**   | **Description**                                             |
| --------------- | ------------- | ----------------------------------------------------------- |
| 135/tcp         | msrpc         | Microsoft RPC, used by many Windows services                |
| 139/tcp         | netbios-ssn   | File sharing via NetBIOS/SMB                                |
| 445/tcp         | microsoft-ds  | SMB service used for file sharing                           |
| 3389/tcp        | ms-wbt-server | Remote desktop (RDP)                                        |
| 5040/tcp        | unknown       | Windows-specific application/service port                   |
| 5985/tcp        | wsman         | Windows Remote Management (HTTP)                            |
| 5986/tcp        | wsmans        | Secure Windows Remote Management (HTTPS)                    |
| 7680/tcp        | pando-pub     | Windows update distribution service (Delivery Optimization) |
| 47001/tcp       | winrm         | Windows Remote Management                                   |
| 49664-49672/tcp | unknown       | Dynamic RPC ports used by Windows                           |

### LAN-SIEM-LIN

| **Port** | **Service**       | **Description**                          |
| -------- | ----------------- | ---------------------------------------- |
| 22       | SSH               | SSH admin access to SIEM server.         |
| 443      | HTTPS / Wazuh     | HTTPS web access to SIEM/Wazuh dashboard |
| 1514     | Wazuh Agent (TCP) | Wazuh agent communication port (TCP)     |
| 1515     | Wazuh Agent (UDP) | Wazuh agent communication port (UDP)     |
| 55000    | Wazuh Manager     | Wazuh manager communication port         |
