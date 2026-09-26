# Developer Documentation

## Environment Setup

### Prerequisites
- Docker (version 20.10+)
- Docker Compose (version 2.0+)
- Git
- Linux-based system (tested on Debian/Ubuntu)

### Configuration Files
1. **`.env`** - Environment variables (domain name, database config, WordPress settings)
2. **`secrets/`** - Password files (excluded from git)
3. **`srcs/docker-compose.yml`** - Docker Compose configuration
4. **`Makefile`** - Build and management commands

### Initial Setup
```bash
# Clone repository
git clone <repository-url>
cd Inception_1337

# Set up secrets (example - use secure passwords!)
echo "SecureWordPressPass123!" > secrets/credentials.txt
echo "SecureDBPass456!" > secrets/db_password.txt
echo "SecureRootPass789!" > secrets/db_root_password.txt

# Make scripts executable
chmod +x srcs/requirements/*/tools/*.sh
```

## Building and Launching

### Using Makefile
```bash
# Full build and start
make up

# Alternative commands
make        # Same as make up
make start  # Start existing containers
make stop   # Stop containers
make down   # Stop and remove containers
make re     # Full rebuild
```

### Manual Docker Commands
```bash
# Build images
docker compose -f srcs/docker-compose.yml build

# Start services
docker compose -f srcs/docker-compose.yml up -d

# View logs
docker compose -f srcs/docker-compose.yml logs -f
```

## Project Structure
```
Inception_1337/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/                    # Password files (gitignored)
├── srcs/
│   ├── .env                    # Environment variables
│   ├── docker-compose.yml     # Service configuration
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/maria.conf
│       │   └── tools/script.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/nginx.conf
│       │   └── tools/
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/www.conf
│           └── tools/script.sh
```

## Container Management

### Useful Commands
```bash
# List all containers
docker ps -a

# Execute commands in containers
docker exec -it wordpress bash
docker exec mariadb mariadb -u wp_user -p

# View resource usage
docker stats

# Clean up unused resources
docker system prune
```

### Volume Management
```bash
# List volumes
docker volume ls

# Inspect volume location
docker volume inspect mariadb_data

# Remove volumes (caution: data loss!)
docker volume rm mariadb_data wordpress_data
```

## Data Persistence

### Volume Locations
- Database data: `/home/aoussama/data/mariadb/`
- WordPress files: `/home/aoussama/data/wordpress/`

### Backup Data
```bash
# Backup database
docker exec mariadb mysqldump -u wp_user -p wordpress > backup.sql

# Backup WordPress files
cp -r /home//data/wordpress/ wordpress-backup/
```

### Restore Data
```bash
# Restore database
cat backup.sql | docker exec -i mariadb mariadb -u wp_user -p wordpress

# Restore WordPress files
cp -r wordpress-backup/* /home/aoussama/data/wordpress/
```

## Development Workflow

### Making Changes
1. **Modify configuration**: Update files in `srcs/requirements/[service]/`
2. **Rebuild**: Run `make re` to apply changes
3. **Test**: Verify services work correctly
4. **Commit**: Add changes to git repository

### Testing Changes
```bash
# Test build without cache
docker compose -f srcs/docker-compose.yml build --no-cache

# Test with clean state
make fclean && make up
```

### Debugging
```bash
# View real-time logs
docker compose -f srcs/docker-compose.yml logs -f --tail=50

# Check specific service
docker logs wordpress --tail=100

# Interactive debugging
docker exec -it wordpress bash
docker exec -it mariadb mariadb -u root -p
```

## Security Notes
- All passwords are stored in `secrets/` directory
- `.env` file contains non-sensitive configuration
- SSL/TLS is configured for all connections
- Containers run as non-root users where possible
- Network isolation prevents direct external access to database


## Bonus Services Development

### Service Structure

Each bonus service follows the same pattern:
```
service-name/
├── Dockerfile          # Container definition
├── conf/              # Configuration files
├── tools/             # Startup scripts (if needed)
└── README.md          # Service-specific documentation
```

### Redis Service Development

**Location**: `srcs/requirements/redis/`
**Configuration**: `conf/redis.conf`
**Key Settings**:
- Memory limit: 256MB
- Eviction policy: allkeys-lru
- Persistence: RDB snapshots
- Bind address: 0.0.0.0 (internal network)

**Testing Redis**:
```bash
# Connect to Redis CLI
docker exec -it redis redis-cli

# Test basic operations
SET test "Hello Redis"
GET test

# Monitor cache hits
INFO stats
```

### FTP Service Development

**Location**: `srcs/requirements/ftp/`
**Configuration**: `conf/vsftpd.conf`
**Security Features**:
- Chroot isolation for users
- Passive mode ports 40000-40010
- No anonymous access
- Write permissions for authenticated users

**Testing FTP**:
```bash
# Command line FTP test
ftp localhost 21
# Username: ftpuser
# Password: ftppass123!

# Upload test file
put localfile.txt remotefile.txt
```

### Static Site Development

**Location**: `srcs/requirements/static-site/`
**Structure**:
- `html/` - Website source files
- `conf/nginx.conf` - Nginx configuration
- `Dockerfile` - Nginx Alpine container

**Development Workflow**:
1. Edit files in `html/` directory
2. Test locally by opening `html/index.html`
3. Rebuild container: `docker-compose build static-site`
4. Deploy: `docker-compose up -d static-site`

**Features Implemented**:
- Responsive CSS Grid/Flexbox layout
- JavaScript animations and interactivity
- Form validation
- Theme toggle (dark/light mode)
- Mobile navigation menu

### Adminer Development

**Location**: `srcs/requirements/adminer/`
**Customization**:
- Custom CSS styling in `conf/adminer.css`
- Login form plugin in Dockerfile
- Environment-based configuration

**Testing**:
1. Access `https://adminer.oussama.42.fr:8081`
2. Login with database credentials
3. Test SQL queries and table management

### phpMyAdmin Development

**Location**: `srcs/requirements/phpmyadmin/`
**Configuration**: `conf/config.user.inc.php`
**Features**:
- Custom PHP configuration
- Security hardening
- Performance optimization
- Theme customization

### Adding New Bonus Services

To add a new bonus service:

1. Create service directory:
```bash
mkdir -p srcs/requirements/new-service/{conf,tools}
```

2. Create Dockerfile:
```dockerfile
FROM appropriate-base:tag
# Installation and configuration
COPY conf/ /etc/service/
COPY tools/script.sh /script.sh
CMD ["/script.sh"]
```

3. Add to docker-compose.yml:
```yaml
new-service:
  build: ./requirements/new-service
  container_name: new-service
  networks:
    - inception-net
  # Add dependencies, volumes, environment
```

4. Update nginx configuration if web-accessible
5. Add to Makefile commands
6. Update documentation

### Bonus Service Testing

**Integration Tests**:
```bash
# Test all bonus services
make health

# Individual service tests
curl -k https://localhost:8081  # Adminer
curl http://localhost:8080      # Static site
redis-cli -h localhost -p 6379 ping  # Redis
```

**Performance Testing**:
```bash
# Monitor Redis memory usage
docker exec redis redis-cli info memory

# Check FTP connections
docker exec ftp netstat -tulpn | grep :21

# Test static site performance
curl -o /dev/null -s -w "%{time_total}\n" http://localhost:8080
```

### Debugging Bonus Services

**Common Issues**:

1. **Port Conflicts**:
```bash
# Check used ports
netstat -tulpn | grep -E ':8080|:8081|:8082|:21'
```

2. **Container Startup Failures**:
```bash
# View startup logs
docker logs --tail 50 redis
docker logs --tail 50 ftp
```

3. **Network Connectivity**:
```bash
# Test service connectivity
docker exec wordpress ping redis
docker exec wordpress nc -zv redis 6379
```

### Security Considerations for Bonus Services

1. **Redis**: No external exposure, password protection if needed
2. **FTP**: TLS encryption recommended for production
3. **Admin Interfaces**: Strong passwords, IP restrictions in production
4. **Static Site**: Content security policies, input sanitization
5. **All Services**: Regular security updates, vulnerability scanning

### Monitoring and Maintenance

**Log Rotation**:
```bash
# View bonus service logs
docker-compose logs --tail=100 redis ftp

# Monitor resource usage
docker stats redis ftp static-site adminer phpmyadmin
```

**Backup Procedures**:
```bash
# Backup Redis data
docker exec redis redis-cli SAVE
cp /home/oussama/data/redis/dump.rdb backup/

# Backup static site
cp -r srcs/requirements/static-site/html/ static-site-backup/
```

**Update Procedures**:
1. Update Docker images in docker-compose.yml
2. Test configuration changes in development
3. Backup data before updates
4. Deploy updates during maintenance windows