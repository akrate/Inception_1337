# User Documentation

## Overview
This infrastructure provides a WordPress website with MariaDB database and NGINX web server, all running in Docker containers.

## Services Provided
- **WordPress Website**: Content management system accessible at `https://aoussama.42.fr`
- **Administration Panel**: WordPress admin dashboard at `https://aoussama.42.fr/wp-admin`
- **Database**: MariaDB database storing website content and user data
- **Web Server**: NGINX with TLS encryption for secure connections

## Starting and Stopping the Project

### Starting the Project
```bash
make up
```
This command will:
1. Create necessary data directories
2. Build Docker images for all services
3. Start all containers in the correct order
4. Configure WordPress automatically

### Stopping the Project
```bash
make down
```
Stops all containers while preserving data in volumes.

### Restarting the Project
```bash
make restart
```
Restarts all containers.

## Accessing the Website
1. Ensure the project is running with `make up`
2. Open a web browser
3. Navigate to `https://aoussama.42.fr`
4. Accept the self-signed SSL certificate warning (for development)

## Accessing the Administration Panel
1. Access the website at `https://aoussama.42.fr`
2. Navigate to `https://aoussama.42.fr/wp-admin`
3. Login with administrator credentials

## Locating and Managing Credentials

### Credential Files
All credentials are stored in the `secrets/` directory:
- `db_password.txt`: MariaDB user password
- `db_root_password.txt`: MariaDB root password  
- `credentials.txt`: WordPress admin and user passwords

### WordPress Users
Two users are created automatically:
1. **Administrator**: `site_manager` (cannot contain "admin" or "administrator")
2. **Regular User**: `site_editor` (author role)

### Changing Passwords
To change passwords:
1. Update the corresponding file in `secrets/`
2. Run `make re` to rebuild with new passwords

## Checking Service Status

### View Running Containers
```bash
docker ps
```

### View Container Logs
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

### Check Service Health
```bash
# Check if website is accessible
curl -k https://aoussama.42.fr

# Check database connection
docker exec mariadb mariadb-admin ping
```

### Common Issues
- **Port 443 in use**: Ensure no other service is using port 443
- **SSL certificate warning**: Accept the warning or add certificate to trusted store
- **Container startup failures**: Check logs with `docker logs [container-name]`