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


## Bonus Services Access

### Static Portfolio Website
**URL**: `http://static.oussama.42.fr:8080`
**Purpose**: Professional portfolio showcasing skills and projects
**Features**:
- Responsive design works on all devices
- Interactive animations and transitions
- Contact form for inquiries
- Project showcase with technology tags

### Database Management Interfaces

#### Adminer
**URL**: `https://adminer.oussama.42.fr:8081`
**Credentials**: `admin` / `AdminSecurePass123!`
**Features**:
- Lightweight database administration
- SQL command execution
- Table structure management
- Data import/export

#### phpMyAdmin
**URL**: `https://phpmyadmin.oussama.42.fr:8082`
**Credentials**: `admin` / `AdminSecurePass123!`
**Features**:
- Advanced database management
- Visual query builder
- User privilege management
- Multiple export formats

### FTP Server Access
**URL**: `ftp://oussama.42.fr:21`
**Credentials**: `ftpuser` / `ftppass123!`
**Purpose**: Secure file transfer for WordPress content
**Usage**:
1. Connect using any FTP client
2. Navigate to `/var/www/html`
3. Upload/download theme files, plugins, media

### Redis Cache Monitoring
Redis cache is automatically enabled for WordPress. To verify:
1. Login to WordPress admin
2. Navigate to Settings → Redis
3. Verify "Connected to Redis" status

## Bonus Service Management

### Starting Bonus Services
Bonus services start automatically with `make up`. To start only bonus services (if already built):
```bash
docker compose -f srcs/docker-compose.yml up -d redis ftp static-site adminer phpmyadmin
```

### Stopping Bonus Services
```bash
docker compose -f srcs/docker-compose.yml stop redis ftp static-site adminer phpmyadmin
```

### Checking Bonus Service Status
```bash
# View all bonus containers
docker ps --filter "name=redis\|ftp\|static-site\|adminer\|phpmyadmin"

# Check specific service
docker logs redis
docker logs ftp
```

### Bonus Service Data
- **Redis data**: `/home/oussama/data/redis/`
- **Static site files**: `srcs/requirements/static-site/html/`
- **FTP home directory**: `/var/www/html` (shared with WordPress)

## Troubleshooting Bonus Services

### Redis Connection Issues
```bash
# Test Redis connection from WordPress
docker exec wordpress redis-cli -h redis ping
# Expected response: PONG
```

### FTP Connection Issues
1. Ensure passive ports 40000-40010 are open
2. Check firewall settings
3. Verify credentials: `ftpuser` / `ftppass123!`

### Static Site Not Loading
1. Check if port 8080 is available
2. Verify nginx is running: `docker logs nginx`
3. Check static site container: `docker logs static-site`

### Database Admin Interfaces
1. Use correct credentials: `admin` / `AdminSecurePass123!`
2. Accept self-signed SSL certificate warning
3. Ensure MariaDB container is running

## Security Notes for Bonus Services

1. **Admin interfaces** are protected with basic authentication
2. **FTP uses chroot** to restrict file access
3. **Redis is internal only** (not exposed externally)
4. **Static site is read-only** in production
5. All bonus services use the same Docker network isolation as mandatory services