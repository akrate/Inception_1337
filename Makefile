NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_DIR = /home/oussama/data

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m

all: up

up: create_dirs
	@echo "$(GREEN)Building and starting all containers (mandatory + bonus)...$(NC)"
	docker compose -f $(COMPOSE_FILE) --env-file ./srcs/.env up -d --build
	@echo "$(GREEN)Containers started successfully!$(NC)"
	@echo "$(YELLOW)WordPress: https://oussama.42.fr$(NC)"
	@echo "$(YELLOW)Static Site: http://static.oussama.42.fr:8080$(NC)"
	@echo "$(YELLOW)Adminer: https://adminer.oussama.42.fr:8081 (user: admin, pass: AdminSecurePass123!)$(NC)"
	@echo "$(YELLOW)Portainer: https://portainer.oussama.42.fr:9000 (user: admin, pass: PortainerSecurePass123!)$(NC)"
	@echo "$(YELLOW)FTP Server: ftp://oussama.42.fr:21 (user: ftpuser, pass: ftppass123!)$(NC)"

down:
	@echo "$(YELLOW)Stopping all containers...$(NC)"
	docker compose -f $(COMPOSE_FILE) down

start:
	@echo "$(YELLOW)Starting existing containers...$(NC)"
	docker compose -f $(COMPOSE_FILE) start

stop:
	@echo "$(YELLOW)Stopping containers...$(NC)"
	docker compose -f $(COMPOSE_FILE) stop

restart: down start
	@echo "$(GREEN)Containers restarted!$(NC)"

clean: down
	@echo "$(YELLOW)Cleaning Docker system...$(NC)"
	docker system prune -a --force

fclean:
	@echo "$(RED)Full clean - removing containers, images, and volumes...$(NC)"
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
	sudo rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/* $(DATA_DIR)/redis/*
	@echo "$(YELLOW)Note: Portainer data volume preserved for user data$(NC)"

re: fclean all

create_dirs:
	@echo "$(YELLOW)Creating data directories...$(NC)"
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/redis
	@echo "$(GREEN)Data directories created at $(DATA_DIR)$(NC)"

# Bonus service specific commands
bonus: up
	@echo "$(GREEN)Bonus services are included in the main 'make' command$(NC)"

status:
	@echo "$(YELLOW)Container status:$(NC)"
	docker compose -f $(COMPOSE_FILE) ps

logs:
	@echo "$(YELLOW)Showing logs (Ctrl+C to exit):$(NC)"
	docker compose -f $(COMPOSE_FILE) logs -f

logs-wordpress:
	docker logs -f wordpress

logs-nginx:
	docker logs -f nginx

logs-mariadb:
	docker logs -f mariadb

logs-redis:
	docker logs -f redis

logs-portainer:
	docker logs -f portainer

# Database management
db-backup:
	@echo "$(YELLOW)Backing up WordPress database...$(NC)"
	docker exec mariadb mysqldump -u wp_user -p wordpress > wordpress_backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)Backup saved to wordpress_backup_$(shell date +%Y%m%d_%H%M%S).sql$(NC)"

db-restore:
	@if [ -z "$(file)" ]; then \
		echo "$(RED)Usage: make db-restore file=backup.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restoring database from $(file)...$(NC)"
	cat $(file) | docker exec -i mariadb mysql -u wp_user -p wordpress
	@echo "$(GREEN)Database restored!$(NC)"

# WordPress management
wp-cli:
	@echo "$(YELLOW)Entering WordPress CLI...$(NC)"
	docker exec -it wordpress wp --path=/var/www/html $(filter-out $@,$(MAKECMDGOALS))

# Health checks
health:
	@echo "$(YELLOW)Checking service health...$(NC)"
	@echo "WordPress: $$(curl -s -o /dev/null -w "%{http_code}" https://localhost || echo "DOWN")"
	@echo "Static Site: $$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "DOWN")"
	@echo "Adminer: $$(curl -s -o /dev/null -w "%{http_code}" https://localhost:8081 || echo "DOWN")"
	@echo "Portainer: $$(curl -s -o /dev/null -w "%{http_code}" https://localhost:9000 || echo "DOWN")"

# Help command
help:
	@echo "$(GREEN)Inception Project Makefile Commands:$(NC)"
	@echo ""
	@echo "$(YELLOW)Basic Commands:$(NC)"
	@echo "  make              Build and start all containers (mandatory + bonus)"
	@echo "  make up           Same as 'make'"
	@echo "  make down         Stop and remove containers"
	@echo "  make start        Start existing containers"
	@echo "  make stop         Stop containers"
	@echo "  make restart      Restart containers"
	@echo "  make clean        Stop containers and clean Docker system"
	@echo "  make fclean       Full clean (containers, images, volumes, data)"
	@echo "  make re           Full rebuild"
	@echo ""
	@echo "$(YELLOW)Monitoring:$(NC)"
	@echo "  make status       Show container status"
	@echo "  make logs         Follow all container logs"
	@echo "  make logs-[service] Follow specific service logs"
	@echo "  make health       Check service health"
	@echo ""
	@echo "$(YELLOW)Database Management:$(NC)"
	@echo "  make db-backup    Backup WordPress database"
	@echo "  make db-restore file=backup.sql  Restore database"
	@echo ""
	@echo "$(YELLOW)WordPress Management:$(NC)"
	@echo "  make wp-cli       Run WordPress CLI commands"
	@echo "  make wp-cli plugin list  Example: List plugins"
	@echo ""
	@echo "$(YELLOW)Bonus Services:$(NC)"
	@echo "  • Redis cache for WordPress"
	@echo "  • FTP server for file management"
	@echo "  • Static portfolio website"
	@echo "  • Adminer database management"
	@echo "  • Portainer Docker management (your choice)"
	@echo ""
	@echo "$(YELLOW)Access URLs:$(NC)"
	@echo "  WordPress: https://oussama.42.fr"
	@echo "  Static Site: http://static.oussama.42.fr:8080"
	@echo "  Adminer: https://adminer.oussama.42.fr:8081"
	@echo "  Portainer: https://portainer.oussama.42.fr:9000"
	@echo "  FTP: ftp://oussama.42.fr:21"
	@echo ""
	@echo "$(YELLOW)Credentials:$(NC)"
	@echo "  WordPress Admin: site_manager / [from credentials.txt]"
	@echo "  Admin Interfaces: admin / AdminSecurePass123!"
	@echo "  Portainer: admin / PortainerSecurePass123! (initial setup)"
	@echo "  FTP: ftpuser / ftppass123!"
	@echo "  Database: wp_user / [from db_password.txt]"

.PHONY: all up down start stop restart clean fclean re create_dirs bonus status logs logs-wordpress logs-nginx logs-mariadb logs-redis logs-portainer db-backup db-restore wp-cli health help