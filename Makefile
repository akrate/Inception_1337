NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
DATA_DIR = /home/aoussama/data

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
	@echo "$(YELLOW)WordPress: https://aoussama.42.fr$(NC)"
	@echo "$(YELLOW)Static Site: http://static.aoussama.42.fr:8080$(NC)"
	@echo "$(YELLOW)Adminer: https://adminer.aoussama.42.fr:8081 (user: admin, pass: AdminSecurePass123!)$(NC)"
	@echo "$(YELLOW)Portainer: https://portainer.aoussama.42.fr:9000 (user: admin, pass: PortainerSecurePass123!)$(NC)"
	@echo "$(YELLOW)FTP Server: ftp://aoussama.42.fr:21 (user: ftpuser, pass: ftppass123!)$(NC)"

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


.PHONY: all up down start stop restart clean fclean re create_dirs