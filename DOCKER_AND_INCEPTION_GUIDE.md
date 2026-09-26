# Docker & Inception Project Complete Guide

## Table of Contents
1. [Introduction to Docker](#introduction-to-docker)
2. [Docker Core Concepts](#docker-core-concepts)
3. [Docker Components Deep Dive](#docker-components-deep-dive)
4. [Inception Project Overview](#inception-project-overview)
5. [Mandatory Services Explained](#mandatory-services-explained)
6. [Bonus Services Explained](#bonus-services-explained)
7. [Dockerfile Implementation](#dockerfile-implementation)
8. [Docker Compose Configuration](#docker-compose-configuration)
9. [Network Architecture](#network-architecture)
10. [Volume Management](#volume-management)
11. [Security Implementation](#security-implementation)
12. [Project Structure](#project-structure)
13. [Deployment Guide](#deployment-guide)
14. [Troubleshooting](#troubleshooting)
15. [Best Practices](#best-practices)

---

## 1. Introduction to Docker

### What is Docker?
Docker is a platform for developing, shipping, and running applications in containers. Containers are lightweight, standalone, executable packages that include everything needed to run an application: code, runtime, system tools, system libraries, and settings.

### Why Docker?
- **Consistency**: Same environment from development to production
- **Isolation**: Applications run in isolated containers
- **Portability**: Run anywhere Docker is installed
- **Efficiency**: Containers share the host OS kernel
- **Scalability**: Easy to scale applications horizontally

### Docker vs Virtual Machines
```
Virtual Machine:          Container:
+----------------+       +----------------+
|    App A       |       |    App A       |
+----------------+       +----------------+
|    Bins/Libs   |       |    Bins/Libs   |
+----------------+       +----------------+
| Guest OS       |       | Docker Engine  |
+----------------+       +----------------+
| Hypervisor     |       | Host OS        |
+----------------+       +----------------+
| Hardware       |       | Hardware       |
+----------------+       +----------------+
```

### Key Benefits:
1. **Lightweight**: Containers share the host kernel
2. **Fast**: Start in milliseconds vs minutes for VMs
3. **Portable**: Build once, run anywhere
4. **Secure**: Isolation at process level
5. **Efficient**: Better resource utilization

---

## 2. Docker Core Concepts

### 2.1 Docker Images
- **Definition**: Read-only templates with instructions for creating containers
- **Components**: Base image + layers of changes
- **Storage**: Stored in registries (Docker Hub, private registries)
- **Lifecycle**: Build → Push → Pull → Run

### 2.2 Docker Containers
- **Definition**: Runnable instances of images
- **Characteristics**: Isolated, lightweight, ephemeral
- **Lifecycle**: Create → Start → Stop → Remove
- **State**: Can be running or stopped

### 2.3 Docker Registry
- **Public**: Docker Hub (hub.docker.com)
- **Private**: Self-hosted registries
- **Function**: Store and distribute Docker images

### 2.4 Docker Engine
- **Components**:
  - Docker Daemon (dockerd): Background service
  - Docker Client (docker): CLI interface
  - REST API: For programmatic access

---

## 3. Docker Components Deep Dive

### 3.1 Dockerfile
A text file containing instructions for building Docker images.

**Basic Structure:**
```dockerfile
# Base image
FROM debian:bookworm

# Metadata
LABEL maintainer="oussama"

# Install packages
RUN apt-get update && apt-get install -y package

# Copy files
COPY source destination

# Set working directory
WORKDIR /app

# Expose ports
EXPOSE 80

# Define entry point
CMD ["command", "args"]
```

**Common Instructions:**
- `FROM`: Base image
- `RUN`: Execute commands
- `COPY/ADD`: Add files
- `ENV`: Set environment variables
- `EXPOSE`: Document ports
- `CMD/ENTRYPOINT`: Default commands

### 3.2 Docker Compose
Tool for defining and running multi-container applications.

**Key Features:**
- Define services in YAML file
- Configure networks and volumes
- Set environment variables
- Manage dependencies
- Scale services

**Compose File Structure:**
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "80:80"
  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: secret
```

### 3.3 Docker Volumes
Persistent data storage for containers.

**Types of Volumes:**
1. **Named Volumes**: Managed by Docker
2. **Bind Mounts**: Mount host directories
3. **tmpfs Mounts**: In-memory storage

**Volume Use Cases:**
- Database data persistence
- Configuration files
- Log files
- Shared data between containers

### 3.4 Docker Networks
Isolated communication channels between containers.

**Network Types:**
1. **Bridge**: Default network for containers
2. **Host**: Share host network namespace
3. **Overlay**: Multi-host networking
4. **Macvlan**: Assign MAC addresses
5. **None**: No networking

**Network Features:**
- DNS resolution by container name
- Isolated communication
- Custom IP addressing
- Network segmentation

---

## 4. Inception Project Overview

### Project Purpose
The Inception project is a system administration exercise that teaches Docker orchestration by building a complete web infrastructure with multiple interconnected services.

### Project Requirements
- Virtual Machine environment
- Docker containers for each service
- Custom Dockerfiles
- Docker Compose orchestration
- SSL/TLS encryption
- Persistent storage
- Network isolation

### Technology Stack
- **Base OS**: Debian Bookworm / Alpine Linux
- **Web Server**: NGINX with SSL/TLS
- **CMS**: WordPress with PHP-FPM
- **Database**: MariaDB
- **Bonus Services**: Redis, FTP, Adminer, Portainer

---

## 5. Mandatory Services Explained

### 5.1 NGINX Web Server
**Purpose**: Reverse proxy and SSL termination
**Configuration**:
- TLS 1.2/1.3 only
- Port 443 only (entry point)
- Reverse proxy to WordPress
- SSL certificate generation
- Security headers

**Dockerfile Implementation:**
```dockerfile
FROM debian:bookworm
RUN apt-get update && apt-get install -y nginx openssl
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=MA/ST=RABAT/L=RABAT/O=42/CN=oussama.42.fr"
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
```

### 5.2 WordPress
**Purpose**: Content Management System
**Configuration**:
- PHP-FPM for processing
- MariaDB backend
- Auto-installation script
- Environment-based configuration
- Two users (admin + regular)

**Key Features:**
- Automatic setup on first run
- Database connection management
- User creation automation
- Volume persistence for uploads

### 5.3 MariaDB
**Purpose**: Database server for WordPress
**Configuration**:
- Custom initialization script
- User and database creation
- Root password setup
- Volume persistence
- Network binding

**Security Features:**
- Environment variable passwords
- Root password setup
- Database user creation
- Network isolation

---

## 6. Bonus Services Explained

### 6.1 Redis Cache
**Purpose**: Improve WordPress performance
**Configuration**:
- 256MB memory limit
- LRU eviction policy
- Persistence enabled
- WordPress object caching

**Benefits:**
- 80-90% database query reduction
- Faster page loads
- Better traffic handling
- Reduced server load

### 6.2 FTP Server
**Purpose**: File management for WordPress
**Technology**: vsftpd (Very Secure FTP Daemon)
**Features**:
- Chroot isolation
- Passive mode (ports 40000-40010)
- Dedicated user account
- WordPress directory access

**Use Cases:**
- Theme/plugin management
- File backups
- Media upload management
- Development workflows

### 6.3 Static Portfolio Website
**Purpose**: Showcase skills and projects
**Technology**: HTML5, CSS3, JavaScript
**Features**:
- Responsive design
- Dark/light theme toggle
- Interactive animations
- Contact form
- Portfolio showcase

**Implementation:**
- Nginx serving static files
- Modern frontend stack
- Performance optimized
- Separate from WordPress

### 6.4 Adminer
**Purpose**: Database management interface
**Features**:
- Lightweight PHP application
- Full MySQL/MariaDB support
- SQL command execution
- Table structure editing
- Data import/export

**Advantages:**
- Minimal resource usage
- Single file deployment
- Intuitive interface
- Security features

### 6.5 Portainer (Your Choice)
**Purpose**: Docker management interface
**Features**:
- Container management GUI
- Image management
- Network/volume management
- Stack deployment
- Resource monitoring

**Why Chosen:**
- Educational value
- Industry standard
- Comprehensive features
- Security focus
- Practical utility

---

## 7. Dockerfile Implementation

### 7.1 Common Patterns Across Services

**Base Image Selection:**
```dockerfile
FROM debian:bookworm  # Stable, well-supported
# OR
FROM alpine:latest    # Lightweight, security-focused
```

**Package Installation:**
```dockerfile
RUN apt-get update && apt-get install -y \
    package1 \
    package2 \
    && rm -rf /var/lib/apt/lists/*
```

**Configuration Copy:**
```dockerfile
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh
```

**Entry Point Design:**
```dockerfile
ENTRYPOINT ["/script.sh"]
# OR
CMD ["nginx", "-g", "daemon off;"]
```

### 7.2 Security Best Practices

1. **Minimal Base Images**: Use Alpine when possible
2. **Non-root Users**: Run services as non-root
3. **Package Updates**: Keep packages updated
4. **Secret Management**: Use Docker secrets
5. **Layer Optimization**: Combine RUN commands

### 7.3 Performance Optimization

1. **Layer Caching**: Order commands strategically
2. **Multi-stage Builds**: Reduce final image size
3. **.dockerignore**: Exclude unnecessary files
4. **Image Scanning**: Check for vulnerabilities

---

## 8. Docker Compose Configuration

### 8.1 Complete docker-compose.yml Structure

```yaml
version: '3.8'  # Compose file version

services:  # Container definitions
  service-name:
    build: ./path  # Build from Dockerfile
    image: custom-name  # Image name
    container_name: name  # Container name
    restart: always  # Restart policy
    networks:  # Network connections
      - network-name
    depends_on:  # Service dependencies
      - other-service
    environment:  # Environment variables
      VAR: value
    secrets:  # Docker secrets
      - secret-name
    volumes:  # Persistent storage
      - volume-name:/path
    ports:  # Port mappings
      - "host:container"

networks:  # Network definitions
  network-name:
    driver: bridge

volumes:  # Volume definitions
  volume-name:
    driver: local

secrets:  # Secret definitions
  secret-name:
    file: ./path/file.txt
```

### 8.2 Key Configuration Elements

**Service Dependencies:**
```yaml
depends_on:
  - database
  - cache
  - redis
```

**Environment Variables:**
```yaml
environment:
  - DATABASE_HOST=mariadb
  - DATABASE_NAME=wordpress
  - REDIS_HOST=redis
```

**Volume Mounts:**
```yaml
volumes:
  - wordpress_data:/var/www/html  # Named volume
  - ./config:/app/config  # Bind mount
```

**Network Configuration:**
```yaml
networks:
  inception-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### 8.3 Your Project's Compose File

**Services Breakdown:**
1. **mariadb**: Database with secrets and volumes
2. **wordpress**: CMS with Redis integration
3. **nginx**: SSL termination and reverse proxy
4. **redis**: Cache service with persistence
5. **ftp**: File transfer service
6. **static-site**: Portfolio website
7. **adminer**: Database management
8. **portainer**: Docker management

**Network Design:**
- All services on `inception-net`
- Isolated from host network
- DNS resolution by service name
- Custom subnet (172.20.0.0/16)

---

## 9. Network Architecture

### 9.1 Network Design

```
Internet → NGINX (SSL) → Services
            ↑
        [Firewall]
            ↑
        [Router]
            ↑
       [Host VM]
            ↑
    [Docker Network]
            ↑
+-------------------------------+
| Container 1 | Container 2 | ... |
+-------------------------------+
```

### 9.2 Communication Flow

1. **External Access**: HTTPS → NGINX → Services
2. **Internal Communication**: Service name resolution
3. **Database Access**: WordPress → MariaDB
4. **Cache Access**: WordPress → Redis
5. **Admin Access**: NGINX → Admin interfaces

### 9.3 Security Isolation

- **External Exposure**: Only NGINX on port 443
- **Internal Network**: Isolated Docker network
- **Service Segregation**: Each service isolated
- **Firewall Rules**: Port restrictions

---

## 10. Volume Management

### 10.1 Volume Types in Your Project

**Named Volumes:**
```yaml
mariadb_data:  # Database storage
  driver: local
  driver_opts:
    type: none
    o: bind
    device: /home/oussama/data/mariadb

wordpress_data:  # WordPress files
  driver: local
  driver_opts:
    type: none
    o: bind
    device: /home/oussama/data/wordpress

redis_data:  # Redis persistence
  driver: local
  driver_opts:
    type: none
    o: bind
    device: /home/oussama/data/redis

portainer_data:  # Portainer config
  name: portainer_data
```

### 10.2 Volume Purposes

1. **mariadb_data**: Database files, user data, configurations
2. **wordpress_data**: Themes, plugins, uploads, configurations
3. **redis_data**: Cache data, persistence files
4. **portainer_data**: User data, configurations, templates

### 10.3 Volume Management Commands

**List Volumes:**
```bash
docker volume ls
```

**Inspect Volume:**
```bash
docker volume inspect mariadb_data
```

**Backup Volume:**
```bash
docker run --rm -v mariadb_data:/data -v $(pwd):/backup alpine tar czf /backup/mariadb_backup.tar.gz /data
```

**Restore Volume:**
```bash
docker run --rm -v mariadb_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/mariadb_backup.tar.gz"
```

---

## 11. Security Implementation

### 11.1 SSL/TLS Configuration

**NGINX SSL Setup:**
```nginx
ssl_certificate /etc/ssl/certs/nginx.crt;
ssl_certificate_key /etc/ssl/private/nginx.key;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
```

**Certificate Generation:**
```bash
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout nginx.key \
  -out nginx.crt \
  -subj "/C=MA/ST=RABAT/L=RABAT/O=42/CN=oussama.42.fr"
```

### 11.2 Authentication

**Basic Authentication:**
```nginx
auth_basic "Restricted Area";
auth_basic_user_file /etc/nginx/.htpasswd;
```

**Password File Creation:**
```bash
echo "admin:$(openssl passwd -crypt password)" > /etc/nginx/.htpasswd
```

### 11.3 Docker Security

**Read-only Docker Socket:**
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock:ro
```

**Non-root Execution:**
```dockerfile
USER www-data
RUN chown -R www-data:www-data /var/www/html
```

**Secret Management:**
```yaml
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### 11.4 Network Security

- **Firewall**: Only necessary ports open
- **Network Policies**: Isolated Docker network
- **Service Isolation**: Each service in own container
- **Access Control**: Basic authentication for admin interfaces

---

## 12. Project Structure

```
Inception_1337/
├── Makefile                    # Build and management commands
├── README.md                   # Project documentation
├── USER_DOC.md                 # User documentation
├── DEV_DOC.md                  # Developer documentation
├── BONUS.md                    # Bonus services documentation
├── DOCKER_AND_INCEPTION_GUIDE.md  # This guide
├── verify_bonus.sh             # Configuration verification
├── secrets/                    # Password files (gitignored)
│   ├── credentials.txt         # WordPress passwords
│   ├── db_password.txt         # Database password
│   └── db_root_password.txt    # Database root password
└── srcs/                       # Source files
    ├── .env                    # Environment variables
    ├── docker-compose.yml      # Service orchestration
    └── requirements/           # Service configurations
        ├── mariadb/            # Database service
        │   ├── Dockerfile
        │   ├── conf/maria.conf
        │   └── tools/script.sh
        ├── nginx/              # Web server
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        ├── wordpress/          # CMS
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/script.sh
        ├── redis/              # Cache service
        │   ├── Dockerfile
        │   └── conf/redis.conf
        ├── ftp/                # FTP server
        │   ├── Dockerfile
        │   ├── conf/vsftpd.conf
        │   └── tools/script.sh
        ├── static-site/        # Portfolio website
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── html/ (website files)
        ├── adminer/            # Database management
        │   ├── Dockerfile
        │   └── conf/adminer.css
        └── portainer/          # Docker management (your choice)
            ├── Dockerfile
            └── README.md
```

### 12.1 Directory Purposes

**Root Level:**
- `Makefile`: Automation and management
- `*.md`: Comprehensive documentation
- `secrets/`: Secure password storage
- `srcs/`: All service configurations

**Service Directories:**
- `Dockerfile`: Container definition
- `conf/`: Service configurations
- `tools/`: Startup and setup scripts
- Service-specific files

---

## 13. Deployment Guide

### 13.1 Prerequisites

**System Requirements:**
- Virtual Machine (required by project)
- Docker Engine installed
- Docker Compose installed
- Sufficient disk space
- Port 443 available

**Software Installation:**
```bash
# Install Docker
sudo apt-get update
sudo apt-get install docker.io

# Install Docker Compose
sudo apt-get install docker-compose

# Add user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

### 13.2 Initial Setup

**Clone and Prepare:**
```bash
# Navigate to project
cd Inception_1337

# Create secret files (use secure passwords)
echo "SecurePassword123!" > secrets/db_password.txt
echo "SecureRootPass456!" > secrets/db_root_password.txt
echo "WordPressPass789!" > secrets/credentials.txt

# Make scripts executable
chmod +x verify_bonus.sh
chmod +x srcs/requirements/*/tools/*.sh
```

**Verify Configuration:**
```bash
./verify_bonus.sh
```

### 13.3 Building and Running

**Full Deployment:**
```bash
make  # or make up
```

**Step-by-Step:**
```bash
# Create data directories
make create_dirs

# Build and start all services
docker-compose -f srcs/docker-compose.yml --env-file srcs/.env up -d --build

# Check status
make status

# View logs
make logs
```

### 13.4 Service Access

**Main Services:**
- WordPress: https://oussama.42.fr
- Adminer: https://adminer.oussama.42.fr:8081
- Portainer: https://portainer.oussama.42.fr:9000
- Static Site: http://static.oussama.42.fr:8080
- FTP: ftp://oussama.42.fr:21

**Credentials:**
- WordPress Admin: site_manager / [from credentials.txt]
- Admin Interfaces: admin / AdminSecurePass123!
- Portainer: admin / PortainerSecurePass123! (initial)
- FTP: ftpuser / ftppass123!
- Database: wp_user / [from db_password.txt]

### 13.5 Management Commands

**Basic Operations:**
```bash
make start      # Start services
make stop       # Stop services
make restart    # Restart services
make down       # Stop and remove
make clean      # Clean Docker system
make fclean     # Full clean (removes data)
make re         # Rebuild from scratch
```

**Monitoring:**
```bash
make status     # Service status
make logs       # View all logs
make logs-nginx # View NGINX logs
make health     # Health checks
```

**Database Operations:**
```bash
make db-backup                  # Backup database
make db-restore file=backup.sql # Restore database
```

**WordPress Management:**
```bash
make wp-cli                     # WordPress CLI
make wp-cli plugin list         # List plugins
make wp-cli theme list          # List themes
```

---

## 14. Troubleshooting

### 14.1 Common Issues

**Port Conflicts:**
```bash
# Check used ports
netstat -tulpn | grep -E ':443|:8080|:8081|:9000|:21'
```

**Container Startup Failures:**
```bash
# Check specific service logs
docker logs nginx
docker logs wordpress --tail 50

# Check Docker Compose logs
docker-compose -f srcs/docker-compose.yml logs
```

**Network Issues:**
```bash
# Test service connectivity
docker exec wordpress ping mariadb
docker exec wordpress nc -zv mariadb 3306
```

**Volume Issues:**
```bash
# Check volume permissions
ls -la /home/oussama/data/

# Recreate volumes
docker-compose -f srcs/docker-compose.yml down -v
make create_dirs
make up
```

### 14.2 Service-Specific Troubleshooting

**WordPress Database Connection:**
```bash
# Test database connection
docker exec mariadb mariadb-admin ping
docker exec wordpress wp db check --path=/var/www/html
```

**Redis Connection:**
```bash
# Test Redis connection
docker exec wordpress redis-cli -h redis ping
# Expected: PONG
```

**FTP Connection:**
```bash
# Test FTP connection
ftp localhost 21
# Username: ftpuser
# Password: ftppass123!
```

**SSL Certificate Issues:**
```bash
# Check certificate
openssl x509 -in srcs/requirements/nginx/ssl/nginx.crt -text -noout

# Test SSL connection
curl -vk https://localhost
```

### 14.3 Performance Issues

**High Memory Usage:**
```bash
# Check container resource usage
docker stats

# Check specific service
docker exec wordpress free -m
docker exec mariadb mariadb -e "SHOW PROCESSLIST;"
```

**Slow Response Times:**
```bash
# Check Redis cache
docker exec wordpress wp redis info --path=/var/www/html

# Check database queries
docker exec mariadb mariadb -e "SHOW STATUS LIKE 'Questions';"
```

---

## 15. Best Practices

### 15.1 Docker Best Practices

**Image Building:**
1. Use specific version tags
2. Minimize layer count
3. Use multi-stage builds
4. Remove unnecessary files
5. Scan for vulnerabilities

**Container Management:**
1. Use restart policies
2. Implement health checks
3. Set resource limits
4. Use logging drivers
5. Regular updates

**Security:**
1. Run as non-root user
2. Use read-only filesystems
3. Implement network policies
4. Regular security updates
5. Secret management

### 15.2 Project-Specific Best Practices

**Configuration Management:**
1. Use environment variables
2. Separate configuration from code
3. Version control configurations
4. Document all settings
5. Regular backups

**Monitoring:**
1. Implement logging
2. Set up alerts
3. Monitor resource usage
4. Regular health checks
5. Performance metrics

**Maintenance:**
1. Regular updates
2. Backup procedures
3. Disaster recovery plan
4. Documentation updates
5. Security audits

### 15.3 Development Workflow

**Local Development:**
1. Use development environment
2. Implement CI/CD pipeline
3. Automated testing
4. Code reviews
5. Documentation updates

**Production Deployment:**
1. Staging environment testing
2. Rolling updates
3. Monitoring setup
4. Backup verification
5. Performance testing

---

## Conclusion

This Inception project demonstrates comprehensive Docker orchestration skills including:

1. **Multi-service Architecture**: 8 interconnected containers
2. **Docker Expertise**: Custom Dockerfiles, Compose, networks, volumes
3. **Security Implementation**: SSL/TLS, authentication, isolation
4. **Performance Optimization**: Redis caching, efficient configurations
5. **Management Tools**: Portainer, Adminer, automation scripts
6. **Documentation**: Complete guides for users and developers
7. **Best Practices**: Security, performance, maintainability

The project serves as an excellent learning tool for:
- Docker containerization
- System administration
- Web infrastructure
- Security practices
- DevOps workflows

Each component has been carefully designed to teach important concepts while providing a functional, production-ready infrastructure.

---

## Quick Reference

### Essential Commands
```bash
# Build and start
make

# Stop everything
make down

# View logs
make logs

# Check status
make status

# Backup database
make db-backup

# Full rebuild
make re
```

### Service URLs
- WordPress: https://oussama.42.fr
- Adminer: https://adminer.oussama.42.fr:8081
- Portainer: https://portainer.oussama.42.fr:9000
- Static Site: http://static.oussama.42.fr:8080
- FTP: ftp://oussama.42.fr:21

### Configuration Files
- `docker-compose.yml`: Service orchestration
- `Makefile`: Automation commands
- `nginx.conf`: Web server configuration
- `.env`: Environment variables
- `verify_bonus.sh`: Setup verification

This guide provides everything needed to understand, deploy, manage, and maintain your Inception project with Docker expertise.