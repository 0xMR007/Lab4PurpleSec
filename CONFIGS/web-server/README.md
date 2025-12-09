# Web Server Configuration

This directory contains configuration files for the vulnerable web server (DMZ-WEB01-LIN) that hosts multiple OWASP vulnerable applications via Docker Compose and Nginx reverse proxy.

## Files

### docker-compose.yml

Docker Compose configuration file that defines:

- **OWASP Juice Shop** - Modern vulnerable web application
- **OWASP WebGoat** - Java-based vulnerable web application
- **bWAPP** - PHP-based vulnerable web application
- **NodeGoat** - Node.js vulnerable application
- **VAmPI** - Vulnerable REST API

**Features:**

- All containers on the same Docker network
- Persistent volumes for application data
- Health checks for container monitoring
- Resource limits for lab environment

**Usage:**

```bash
# Navigate to the directory containing docker-compose.yml
cd /path/to/Lab4PurpleSec/CONFIGS/web-server

# Start all containers
docker-compose up -d

# View container status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all containers
docker-compose down
```

### nginx.conf

Nginx reverse proxy configuration that routes requests to the appropriate Docker containers based on virtual hostnames.

**Virtual Hosts Configured:**

- `juice.lab` → Juice Shop (port 3000)
- `webgoat.lab` → WebGoat (port 8080)
- `webwolf.lab` → WebWolf (port 9090)
- `bwapp.lab` → bWAPP (port 80)
- `nodegoat.lab` → NodeGoat (port 4000)
- `vampi.lab` → VAmPI (port 5000)

**Features:**

- Virtual host-based routing
- Proxy pass configuration
- Header forwarding
- Upstream server definitions

**Usage:**

```bash
# Copy to Nginx configuration directory
sudo cp nginx.conf /etc/nginx/sites-available/Lab4PurpleSec
sudo ln -s /etc/nginx/sites-available/Lab4PurpleSec /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx
```

## Deployment

For complete deployment instructions, see:

- **Setup Guide**: `Docs/SETUP/Web_server_setup.md`
- **Test Guide**: `Docs/TESTS/Web_server.md`

## Customization

### Adding New Applications

1. Add container definition to `docker-compose.yml`
2. Add virtual host to `nginx.conf`
3. Update `/etc/hosts` or DNS configuration
4. Restart services

### Modifying Ports

If you need to change application ports:

1. Update port mapping in `docker-compose.yml`
2. Update proxy_pass in `nginx.conf`
3. Restart Docker containers and Nginx

### Network Configuration

The Docker Compose file creates a custom network. To modify:

- Edit `networks:` section in `docker-compose.yml`
- Ensure Nginx can reach containers on this network

## Troubleshooting

### Containers Not Starting

```bash
# Check Docker logs
docker-compose logs

# Verify Docker is running
sudo systemctl status docker

# Check available disk space
df -h
```

### Nginx Not Routing

```bash
# Test Nginx configuration
sudo nginx -t

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log

# Verify virtual hosts are enabled
ls -la /etc/nginx/sites-enabled/
```

### Applications Not Accessible

1. Verify containers are running: `docker-compose ps`
2. Check firewall rules on pfSense
3. Verify NAT rules are configured
4. Test connectivity: `curl -H "Host: juice.lab" http://<pfSense-WAN-IP>`

## Security Notes

- These applications are **intentionally vulnerable** for educational purposes
- **Never** expose these services to the internet
- Keep containers updated to latest versions
- Monitor logs for suspicious activity
- Use Wazuh to collect Docker container logs

## Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [OWASP WebGoat](https://owasp.org/www-project-webgoat/)

---

**Remember**: These are vulnerable applications for learning. Always run them in isolated lab environments.
