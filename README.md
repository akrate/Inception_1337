*This project has been created as part of the 42 curriculum by oussama*

# Inception Project

## Description
This project implements a Docker-based infrastructure with WordPress, MariaDB, and NGINX services. The goal is to set up a small web application infrastructure following specific rules and best practices for containerization.

The infrastructure includes:
- NGINX container with TLS encryption (TLSv1.2/TLSv1.3)
- WordPress container with PHP-FPM
- MariaDB container for database storage
- Docker network for inter-container communication
- Named volumes for persistent storage

## Instructions
### Prerequisites
- Docker and Docker Compose must be installed
- Sufficient disk space for Docker images and volumes
- Port 443 available on the host machine

### Installation & Execution
1. Clone the repository
2. Navigate to the project root directory
3. Run `make` or `make up` to build and start all containers
4. Access the website at `https://oussama.42.fr`

### Management Commands
- `make up` - Build and start containers
- `make down` - Stop and remove containers
- `make start` - Start existing containers
- `make stop` - Stop running containers
- `make restart` - Restart containers
- `make clean` - Clean Docker system
- `make fclean` - Full clean (removes volumes)
- `make re` - Rebuild from scratch

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)

## AI Usage
AI was used to:
- Help debug shell script issues
- Validate YAML configuration syntax
- Suggest improvements for security practices
- Assist with documenting the project structure

## Project Design Choices

### Virtual Machines vs Docker
Docker containers provide lightweight, isolated environments compared to traditional virtual machines. Containers share the host OS kernel, making them faster to start and more resource-efficient than VMs. This project uses Docker for its portability, consistency across environments, and efficient resource utilization.

### Secrets vs Environment Variables
Docker secrets are used for sensitive information like passwords, while environment variables are used for non-sensitive configuration. Secrets provide better security as they are encrypted during transit and at rest, unlike environment variables which are visible in process listings.

### Docker Network vs Host Network
A custom Docker network (`inception-net`) is used instead of host networking. This provides better isolation, allows containers to communicate using service names as DNS entries, and follows security best practices by not exposing container ports directly to the host network.

### Docker Volumes vs Bind Mounts
Named volumes with bind mount backend are used instead of direct bind mounts. This approach provides Docker's volume management features while allowing data to be stored at `/home/oussama/data` on the host. Named volumes offer better portability and management compared to bind mounts.