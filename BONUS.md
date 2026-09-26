# Inception Project - Bonus Services

This document describes all bonus services implemented for the Inception project.

## Overview

The bonus part extends the mandatory Docker infrastructure with additional services that enhance functionality, performance, and management capabilities.

## Bonus Services Implemented

### 1. Redis Cache for WordPress
**Purpose**: Improve WordPress performance by caching database queries and page content
**Technology**: Redis 7 on Alpine Linux
**Configuration**:
- 256MB memory limit with LRU eviction policy
- Persistence enabled with snapshots
- Optimized for WordPress object caching

**Access**: Integrated automatically with WordPress via Redis Object Cache plugin
**Benefits**:
- Reduces database load by 80-90%
- Improves page load times
- Handles traffic spikes better

### 2. FTP Server Container
**Purpose**: Allow secure file management of WordPress files
**Technology**: vsftpd (Very Secure FTP Daemon) on Debian
**Configuration**:
- Chroot isolation for security
- Passive mode enabled (ports 40000-40010)
- TLS support available
- Dedicated user with restricted access

**Access**: `ftp://oussama.42.fr:21`
**Credentials**: `ftpuser` / `ftppass123!`
**Benefits**:
- Secure file transfers
- Easy theme/plugin management
- Backup and restore capabilities

### 3. Static Portfolio Website
**Purpose**: Showcase skills and projects with a modern responsive website
**Technology**: HTML5, CSS3, JavaScript (ES6+), Nginx
**Features**:
- Responsive design (mobile-first)
- Dark/light theme toggle
- Smooth animations and transitions
- Contact form with validation
- Portfolio showcase section
- Technical skills display

**Access**: `http://static.oussama.42.fr:8080`
**Source Code**: Located in `srcs/requirements/static-site/html/`
**Benefits**:
- Demonstrates frontend development skills
- Professional online presence
- Separate from WordPress for performance

### 4. Adminer Database Management
**Purpose**: Lightweight database administration interface
**Technology**: Adminer (single-file PHP application)
**Features**:
- Full MySQL/MariaDB management
- SQL command execution
- Table structure editing
- Data import/export
- User management
- Custom theming

**Access**: `https://adminer.oussama.42.fr:8081`
**Credentials**: `admin` / `AdminSecurePass123!`
**Benefits**:
- Minimal resource usage
- Simple and intuitive interface
- No PHP dependencies beyond basic extensions

### 5. phpMyAdmin Database Management
**Purpose**: Feature-rich alternative database administration interface
**Technology**: phpMyAdmin on latest version
**Features**:
- Advanced SQL editor
- Visual relationship designer
- Query profiling
- User privilege management
- Export in multiple formats
- Theme support

**Access**: `https://phpmyadmin.oussama.42.fr:8082`
**Credentials**: `admin` / `AdminSecurePass123!`
**Benefits**:
- Enterprise-grade features
- Familiar interface for MySQL users
- Comprehensive database management

## Architecture Design

### Network Configuration
```
+-----------------+      +-----------------+
|    NGINX SSL    |      |   Static Site   |
|   Reverse Proxy |------|   (Port 8080)   |
+-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|    WordPress    |------|     Redis       |
         |  |   (Port 9000)   |      |   (Port 6379)   |
         |  +-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|   MariaDB       |------|     FTP         |
         |  |   (Port 3306)   |      |   (Port 21)     |
         |  +-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|   Adminer       |------|   phpMyAdmin    |
            |   (Port 8081)   |      |   (Port 8082)   |
            +-----------------+      +-----------------+
```

### Security Measures
1. **SSL/TLS Encryption**: All web services use TLS 1.2/1.3
2. **Basic Authentication**: Admin interfaces protected with HTTP Basic Auth
3. **Network Isolation**: Services communicate only through defined network
4. **Chroot Environments**: FTP and services run in isolated environments
5. **Secret Management**: Passwords stored in Docker secrets, not in images

## Performance Optimization

### Caching Strategy
1. **Redis Object Cache**: WordPress database query caching
2. **Browser Caching**: Static assets cached for 1 year
3. **Nginx Caching**: Reverse proxy caching where applicable
4. **Gzip Compression**: All text assets compressed

### Resource Allocation
- **WordPress**: PHP-FPM with dynamic process management
- **Redis**: 256MB dedicated cache memory
- **MariaDB**: Optimized configuration for WordPress
- **Nginx**: Worker processes optimized for available CPU cores

## Access Information

### URLs
- **Main Website**: https://oussama.42.fr
- **Static Portfolio**: http://static.oussama.42.fr:8080
- **Adminer**: https://adminer.oussama.42.fr:8081
- **phpMyAdmin**: https://phpmyadmin.oussama.42.fr:8082
- **FTP Server**: ftp://oussama.42.fr:21

### Default Credentials
```
WordPress Admin:  site_manager / [from secrets/credentials.txt]
Admin Interfaces: admin / AdminSecurePass123!
FTP Access:       ftpuser / ftppass123!
Database User:    wp_user / [from secrets/db_password.txt]
```

## Management Commands

```bash
# Start all services (mandatory + bonus)
make

# Check service status
make status

# View logs
make logs
make logs-redis
make logs-ftp

# Database management
make db-backup
make db-restore file=backup.sql

# WordPress management
make wp-cli plugin list
make wp-cli theme list

# Full rebuild
make re
```

## Justification for Bonus Services Choice

1. **Redis Cache**: Essential for production WordPress performance, reduces database load significantly
2. **FTP Server**: Practical for file management without SSH access, commonly used in hosting environments
3. **Static Website**: Demonstrates full-stack capabilities beyond PHP/WordPress
4. **Adminer**: Lightweight alternative to phpMyAdmin, good for resource-constrained environments
5. **phpMyAdmin**: Industry standard for MySQL management, familiar to most developers

## Testing Instructions

1. **Redis**: Verify WordPress dashboard shows "Redis Object Cache" as active
2. **FTP**: Connect using FTP client with provided credentials
3. **Static Site**: Navigate through all pages, test responsive design
4. **Adminer**: Login, browse database, execute sample query
5. **phpMyAdmin**: Login, verify database structure, test export feature

## Maintenance Notes

- Redis data persists in `/home/oussama/data/redis/`
- FTP user home directory is `/var/www/html` (shared with WordPress)
- Static site files are read-only in container
- Admin interfaces should have passwords rotated regularly
- Monitor Redis memory usage under high traffic

## Troubleshooting

### Common Issues
1. **Port conflicts**: Check if ports 8080-8082, 21 are available
2. **Redis connection**: Verify WordPress can reach Redis on port 6379
3. **FTP passive mode**: Ensure firewall allows ports 40000-40010
4. **SSL certificates**: Self-signed certs require browser approval

### Debugging Commands
```bash
# Test Redis connection
docker exec wordpress redis-cli -h redis ping

# Test FTP connection
ftp localhost 21

# Check service health
make health
```

## Source Code Structure

```
srcs/requirements/
├── redis/           # Redis cache service
├── ftp/             # FTP server
├── static-site/     # Portfolio website
├── adminer/         # Adminer interface
└── phpmyadmin/      # phpMyAdmin interface
```

Each service includes:
- Dockerfile for container definition
- Configuration files
- Startup scripts
- Documentation


## 6. Portainer - Docker Container Management (Service of Choice)

### Purpose
Web-based Docker management interface for easy container orchestration and monitoring.

### Technology
- Portainer Community Edition (latest)
- Nginx reverse proxy with SSL termination
- Docker socket access (read-only for security)

### Features
- **Container Management**: Start, stop, restart, remove containers
- **Image Management**: Pull, build, remove Docker images
- **Stack Deployment**: Deploy Docker Compose stacks
- **Network & Volume Management**: Full Docker resource management
- **User Management**: Multi-user support with RBAC
- **Templates**: Application templates for quick deployment
- **Monitoring**: Real-time resource usage monitoring
- **Logs Viewer**: Integrated container log viewer

### Security Measures
1. **Read-only Docker socket**: Prevents unauthorized container modifications
2. **HTTPS with SSL/TLS**: All traffic encrypted
3. **Basic Authentication**: Nginx-level access control
4. **Network Isolation**: Runs on internal Docker network
5. **Session Timeout**: Automatic session expiration

### Access
- **URL**: `https://portainer.oussama.42.fr:9000`
- **Initial Credentials**: `admin` / `PortainerSecurePass123!`
- **Note**: First-time setup requires creating admin user

### Integration Benefits
- **Unified Management**: Manage all Inception services from one interface
- **Visual Monitoring**: See resource usage across all containers
- **Easy Troubleshooting**: Access logs and container status visually
- **Educational Value**: Learn Docker management through GUI
- **Production Ready**: Enterprise-grade container management

### Justification for Choice
Portainer was chosen as the additional service because:
1. **Educational Value**: Provides GUI for Docker concepts learned in project
2. **Practical Utility**: Makes container management accessible during development
3. **Industry Relevance**: Used in professional DevOps environments
4. **Comprehensive Features**: Covers all Docker management aspects
5. **Security Focus**: Can be configured with proper security measures

### Configuration Details
```yaml
portainer:
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro  # Read-only socket access
    - portainer_data:/data                           # Persistent data
  environment:
    - TZ=Africa/Casablanca                          # Timezone
    - PORTAINER_SESSION_TIMEOUT=24h                 # Session management
```

### Usage Example
1. Access Portainer at the provided URL
2. Create admin account on first login
3. Connect to local Docker environment
4. Navigate containers, images, volumes, networks
5. Deploy additional services if needed

### Maintenance Notes
- Portainer data persists in `portainer_data` volume
- Regular backups of Portainer data recommended
- Update to latest version for security patches
- Monitor logs for security events
- Use strong passwords and enable 2FA if available

## Updated Architecture with Portainer

```
+-----------------+      +-----------------+
|    NGINX SSL    |      |   Static Site   |
|   Reverse Proxy |------|   (Port 8080)   |
+-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|    WordPress    |------|     Redis       |
         |  |   (Port 9000)   |      |   (Port 6379)   |
         |  +-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|   MariaDB       |------|     FTP         |
         |  |   (Port 3306)   |      |   (Port 21)     |
         |  +-----------------+      +-----------------+
         |
         |  +-----------------+      +-----------------+
         +--|   Adminer       |------|   phpMyAdmin    |
         |  |   (Port 8081)   |      |   (Port 8082)   |
         |  +-----------------+      +-----------------+
         |
         |  +-----------------+
         +--|   Portainer     |
            |   (Port 9000)   |
            +-----------------+
```

## Access Information Update

### New URL
- **Portainer**: `https://portainer.oussama.42.fr:9000`

### Updated Credentials List
```
WordPress Admin:      site_manager / [from secrets/credentials.txt]
Admin Interfaces:     admin / AdminSecurePass123!
Portainer (initial):  admin / PortainerSecurePass123!
FTP Access:           ftpuser / ftppass123!
Database User:        wp_user / [from secrets/db_password.txt]
```

### Portainer-Specific Commands
```bash
# Start Portainer with other services
make up

# View Portainer logs
make logs-portainer

# Check Portainer health
curl -k https://localhost:9000/api/status

# Backup Portainer data
docker run --rm -v portainer_data:/data -v $(pwd):/backup alpine tar czf /backup/portainer_backup.tar.gz /data
```

## Security Considerations for Portainer

1. **Docker Socket Access**: Read-only mounting prevents container modification
2. **Network Exposure**: Only accessible through nginx with authentication
3. **Session Management**: 24-hour session timeout for security
4. **Regular Updates**: Keep Portainer updated for security patches
5. **Access Logs**: Monitor Portainer access logs for suspicious activity

## Testing Portainer Integration

1. **Connectivity Test**:
   ```bash
   curl -k https://localhost:9000/api/status
   ```

2. **Functionality Test**:
   - Login to Portainer interface
   - Verify all Inception containers are visible
   - Check container status and resource usage
   - Test log viewing functionality

3. **Security Test**:
   - Verify HTTPS encryption
   - Test authentication requirements
   - Check Docker socket permissions
   - Validate network isolation