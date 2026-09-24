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