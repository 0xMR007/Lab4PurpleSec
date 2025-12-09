<div align="center">
  <img src="../../assets/images/banners/Nginx-logo.png" alt="Nginx Logo"/>
</div>

# Web Server Tests

# Overview

This document details the **tests performed** to validate the web server and Nginx reverse proxy configuration, hosting several vulnerable applications (OWASP Juice Shop, WebGoat, NodeGoat, etc.). The tests cover:

- Nginx and Docker configuration validation.
- HTTP accessibility from the server itself and from a client machine.
- HTTP response compliance (codes, headers).

# Table of Contents

- [Web Server Tests](#web-server-tests)
- [Overview](#overview)
- [Table of Contents](#table-of-contents)
- [Tests Performed](#tests-performed)
  - [I. Nginx Configuration Validation](#i-nginx-configuration-validation)
  - [II. HTTP Accessibility Test](#ii-http-accessibility-test)
    - [From the Server](#from-the-server)
    - [From a Client Machine](#from-a-client-machine)
- [Conclusion](#conclusion)

# Tests Performed

## I. Nginx Configuration Validation

**Objective**: Verify that configuration files are present and Docker containers are started correctly.

**Commands executed**:

```bash
# Configuration file verification
cd /opt/webapps/
ls
```

**Expected result**: Presence of `docker-compose.yml` and `nginx.conf` files.

```bash
# Docker container verification
docker ps
```

**Expected result**: All containers (Nginx, Juice Shop, WebGoat, NodeGoat, etc.) must be in "`Up`" state.

![Docker-Compose-tests.png](/assets/images/Web-server-tests/Docker-Compose-tests.png)

## II. HTTP Accessibility Test

### From the Server

**Objective**: Validate that applications are accessible locally, with correct HTTP codes and headers.

**Commands executed**:

```bash
curl -I http://juice.lab/
curl -I http://webgoat.lab/WebGoat
curl -I http://nodegoat.lab/
```

Expected result: HTTP code 200, compliant headers.

Results obtained:

![Web-apps-curl-tests-server.png](/assets/images/Web-server-tests/Web-apps-curl-tests-server.png)

Then access via browser (still on the server):

![JuiceShop-test-browser-server.png](/assets/images/Web-server-tests/JuiceShop-test-browser-server.png)

*Access to OWASP Juice Shop application (via server)*

![Nodegoat-test-browser-server.png](/assets/images/Web-server-tests/Nodegoat-test-browser-server.png)

*Access to OWASP Node Goat application (via server)*

![Webgoat-test-browser-server.png](/assets/images/Web-server-tests/Webgoat-test-browser-server.png)

*Access to OWASP WebGoat application (via server)*

### From a Client Machine

**Objective**: Validate that applications are accessible from an external machine (e.g., `LAN-TEST-LIN`), still with correct HTTP codes and headers.

**Commands executed**:

```bash
curl -I http://juice.lab/
curl -I http://webgoat.lab/WebGoat
curl -I http://nodegoat.lab/
```

Expected result: HTTP code 200, compliant headers.

Results obtained:

![Web-apps-curl-tests-client-2.png](/assets/images/Web-server-tests/Web-apps-curl-tests-client-2.png)

![Web-apps-curl-tests-client-1.png](/assets/images/Web-server-tests/Web-apps-curl-tests-client-1.png)

Then access via browser (on the client machine this time):

![JuiceShop-test-browser-client.png](/assets/images/Web-server-tests/JuiceShop-test-browser-client.png)

*Access to OWASP Juice Shop application (via client)*

![Nodegoat-test-browser-client.png](/assets/images/Web-server-tests/Nodegoat-test-browser-client.png)

*Access to OWASP Node Goat application (via client)*

![Webgoat-test-browser-client.png](/assets/images/Web-server-tests/Webgoat-test-browser-client.png)

*Access to OWASP WebGoat application (via client)*

# Conclusion

The tests performed confirm that:

- **Nginx and Docker configuration** is correctly deployed, with all containers functional.
- **HTTP accessibility** is validated from the server and from a client machine, with compliant responses (code 200, correct headers).
- **The reverse proxy** works as expected, allowing access to vulnerable applications from the WAN.

