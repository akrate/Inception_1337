# Portainer Service

Portainer is a lightweight management UI for Docker. It allows you to easily manage your Docker containers, images, networks, and volumes through a web interface.

## Features

- **Container Management**: Start, stop, restart, remove containers
- **Image Management**: Pull, build, remove Docker images
- **Network Management**: Create and manage Docker networks
- **Volume Management**: Create and manage Docker volumes
- **Stack Deployment**: Deploy Docker Compose stacks
- **User Management**: Multi-user support with RBAC
- **Templates**: Application templates for quick deployment
- **Monitoring**: Resource usage monitoring

## Configuration

Portainer is configured to:
- Persist data in Docker volume `portainer_data`
- Bind to Docker socket for management (read-only for security)
- Use HTTPS with the same certificate as other services
- Have basic authentication via nginx proxy

## Security Considerations

1. **Read-only Docker socket**: Portainer has read-only access to Docker socket
2. **HTTPS Only**: All access is through HTTPS with valid certificates
3. **Basic Authentication**: Protected by nginx basic auth
4. **Network Isolation**: Runs on internal Docker network
5. **Regular Updates**: Uses latest Portainer CE version

## Access

- **URL**: `https://portainer.oussama.42.fr:9000`
- **Credentials**: `admin` / `PortainerSecurePass123!` (initial setup)
- **Docker Socket**: Mounted as read-only for security

## Initial Setup

1. Access Portainer at the URL above
2. Create admin user with secure password
3. Connect to local Docker environment
4. Configure additional settings as needed

## Integration with Inception Project

Portainer can manage all Inception project containers:
- WordPress, MariaDB, NGINX containers
- Redis, FTP, Static Site bonus services
- Adminer and phpMyAdmin containers
- View logs and monitor resource usage

## Maintenance

- Back up Portainer data from `/data` volume
- Update by pulling new Portainer image
- Monitor logs for security events
- Regular password rotation recommended