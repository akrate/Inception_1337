# Docker Cheat Sheet for Inception Project

## Basic Docker Commands

### Container Management
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Start a container
docker start <container_name>

# Stop a container
docker stop <container_name>

# Restart a container
docker restart <container_name>

# Remove a container
docker rm <container_name>

# Remove all stopped containers
docker container prune
```

### Image Management
```bash
# List images
docker images

# Pull an image
docker pull <image_name>

# Remove an image
docker rmi <image_name>

# Remove unused images
docker image prune
```

### Volume Management
```bash
# List volumes
docker volume ls

# Create a volume
docker volume create <volume_name>

# Remove a volume
docker volume rm <volume_name>

# Remove unused volumes
docker volume prune
```

### Network Management
```bash
# List networks
docker network ls

# Create a network
docker network create <network_name>

# Inspect a network
docker network inspect <network_name>

# Remove a network
docker network rm <network_name>
```

## Docker Compose Commands

### Basic Operations
```bash
# Start all services
docker-compose up -d

# Start with build
docker-compose up -d --build

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# View service status
docker-compose ps

# Restart services
docker-compose restart

# Scale a service
docker-compose up -d --scale <service>=<count>
```

### Service Management
```bash
# Start specific service
docker-compose start <service>

# Stop specific service
docker-compose stop <service>

# Restart specific service
docker-compose restart <service>

# View logs for specific service
docker-compose logs -f <service>

# Execute command in service
docker-compose exec <service> <command>
```

## Inception Project Specific Commands

### Using Makefile (Recommended)
```bash
# Build and start everything
make

# Check service status
make status

# View all logs
make logs

# Health check
make health

# Full clean and rebuild
make re

# Help menu
make help
```

### Individual Service Logs
```bash
# WordPress logs
make logs-wordpress

# NGINX logs
make logs-nginx

# MariaDB logs
make logs-mariadb

# Redis logs
make logs-redis

# Portainer logs
make logs-portainer
```

### Database Operations
```bash
# Backup WordPress database
make db-backup

# Restore from backup
make db-restore file=backup.sql

# WordPress CLI
make wp-cli
make wp-cli plugin list
make wp-cli theme list
```

## Dockerfile Commands Reference

### Basic Structure
```dockerfile
# Base image
FROM debian:bookworm

# Metadata
LABEL maintainer="oussama"

# Install packages
RUN apt-get update && apt-get install -y package

# Copy files
COPY source destination

# Set environment variables
ENV VAR=value

# Set working directory
WORKDIR /app

# Expose ports
EXPOSE 80

# Run commands on container start
CMD ["command", "args"]
```

### Common Instructions
- `FROM`: Base image (debian:bookworm, alpine:latest)
- `RUN`: Execute commands during build
- `COPY`: Copy files from host to image
- `ADD`: Similar to COPY but can extract archives
- `ENV`: Set environment variables
- `ARG`: Build-time variables
- `WORKDIR`: Set working directory
- `USER`: Set user for subsequent commands
- `VOLUME`: Create mount point
- `EXPOSE`: Document ports
- `CMD`: Default command when container starts
- `ENTRYPOINT`: Configure container to run as executable

## Docker Compose YAML Reference

### Basic Structure
```yaml
version: '3.8'

services:
  service_name:
    build: .
    image: custom_image
    container_name: my_container
    restart: always
    depends_on:
      - other_service
    environment:
      VAR: value
    volumes:
      - ./data:/app/data
    ports:
      - "80:80"
    networks:
      - my_network

networks:
  my_network:
    driver: bridge

volumes:
  data:
    driver: local
```

### Key Options
- `build`: Build from Dockerfile
- `image`: Use existing image
- `ports`: Port mappings (host:container)
- `volumes`: Mount host directories or volumes
- `environment`: Environment variables
- `depends_on`: Service dependencies
- `networks`: Network connections
- `restart`: Restart policy (no, always, on-failure, unless-stopped)

## Network Types

### Bridge (Default)
```yaml
networks:
  default:
    driver: bridge
```
- Default network for containers
- Containers can communicate via container names
- Isolated from host network

### Host
```yaml
networks:
  default:
    driver: host
```
- Shares host network namespace
- No network isolation
- Better performance

### None
```yaml
networks:
  default:
    driver: none
```
- No networking
- Completely isolated

## Volume Types

### Named Volumes
```yaml
volumes:
  data:
    driver: local
```
- Managed by Docker
- Persistent data
- Easy backup/restore

### Bind Mounts
```yaml
volumes:
  - ./host/path:/container/path
```
- Mount host directory
- Development friendly
- Direct file access

### tmpfs Mounts
```yaml
tmpfs:
  - /tmp
```
- In-memory storage
- Fast but ephemeral
- No persistence

## Security Best Practices

### Run as Non-root
```dockerfile
RUN useradd -m appuser
USER appuser
```

### Use .dockerignore
```
.git
node_modules
*.log
.env
secrets/
```

### Regular Updates
```bash
# Update base images
docker pull debian:bookworm

# Scan for vulnerabilities
docker scan <image_name>
```

### Secret Management
```yaml
secrets:
  db_password:
    file: ./secrets/password.txt
```

## Troubleshooting Commands

### Debug Container Issues
```bash
# View container logs
docker logs <container> --tail 50

# Execute shell in container
docker exec -it <container> sh

# Inspect container details
docker inspect <container>

# View resource usage
docker stats
```

### Network Issues
```bash
# Test connectivity
docker exec <container> ping <other_container>

# Check DNS resolution
docker exec <container> nslookup <service_name>

# View network connections
docker exec <container> netstat -tulpn
```

### Volume Issues
```bash
# Check volume contents
docker run --rm -v <volume>:/data alpine ls -la /data

# Backup volume
docker run --rm -v <volume>:/data -v $(pwd):/backup alpine tar czf /backup/data.tar.gz /data

# Restore volume
docker run --rm -v <volume>:/data -v $(pwd):/backup alpine tar xzf /backup/data.tar.gz -C /data
```

## Performance Monitoring

### Resource Usage
```bash
# Real-time container stats
docker stats

# Container resource limits
docker update --memory=256m --cpus="0.5" <container>

# View container processes
docker top <container>
```

### Log Management
```bash
# Follow logs
docker logs -f <container>

# View last N lines
docker logs --tail 100 <container>

# View logs since timestamp
docker logs --since 2024-01-01 <container>

# Export logs to file
docker logs <container> > container.log
```

## Cleanup Commands

### Remove Unused Resources
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused
docker system prune -a
```

### Clean Build Cache
```bash
# Build without cache
docker-compose build --no-cache

# Clear Docker build cache
docker builder prune
```

## Common Docker Patterns

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

### Multi-stage Builds
```dockerfile
# Build stage
FROM node:alpine AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Production stage
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

### Entrypoint Scripts
```dockerfile
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

## Quick Reference - Inception Project

### Service Ports
- `443` - NGINX (HTTPS)
- `8080` - Static Site (HTTP)
- `8081` - Adminer (HTTPS)
- `9000` - Portainer (HTTPS)
- `21` - FTP
- `3306` - MariaDB (internal)
- `6379` - Redis (internal)
- `9000` - WordPress PHP-FPM (internal)

### Service Names
- `nginx` - Web server
- `wordpress` - CMS
- `mariadb` - Database
- `redis` - Cache
- `ftp` - FTP server
- `static-site` - Portfolio website
- `adminer` - Database management
- `portainer` - Docker management

### Data Locations
- `/home/oussama/data/mariadb` - Database files
- `/home/oussama/data/wordpress` - WordPress files
- `/home/oussama/data/redis` - Redis data
- Docker volumes for other services

### Common Issues & Solutions

#### Port Already in Use
```bash
# Check what's using the port
sudo netstat -tulpn | grep :443

# Stop the conflicting service
sudo systemctl stop nginx
```

#### Permission Issues
```bash
# Fix volume permissions
sudo chown -R 1000:1000 /home/oussama/data/

# Check container user
docker exec <container> whoami
```

#### Container Won't Start
```bash
# Check logs
docker logs <container>

# Check dependencies
docker-compose ps

# Remove and recreate
docker-compose up -d --force-recreate <service>
```

#### Database Connection Issues
```bash
# Test database connection
docker exec mariadb mariadb-admin ping

# Check WordPress database
docker exec wordpress wp db check --path=/var/www/html
```

This cheat sheet covers everything from basic Docker commands to Inception project specifics. Keep it handy for quick reference!