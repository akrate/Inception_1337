NAME = inception
COMPOSE_FILE = ./srcs/docker-compose.yml
# DATA_DIR = /home/oussama/data

all:
	@mkdir -p /home/aoussama/data/wordpress
	@mkdir -p /home/aoussama/data/mariadb
	docker compose -f $(COMPOSE_FILE) --env-file ./srcs/.env up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

start:
	docker compose -f $(COMPOSE_FILE) start

stop:
	docker compose -f $(COMPOSE_FILE) stop

restart:
	docker compose -f $(COMPOSE_FILE) restart

clean: down
	docker system prune -a --force

fclean: clean
	docker compose -f $(COMPOSE_FILE) down -v --rmi all
# 	sudo rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/*

re: fclean all

# create_dirs:
# 	@mkdir -p $(DATA_DIR)/mariadb
# 	@mkdir -p $(DATA_DIR)/wordpress

.PHONY: all up down start stop restart clean fclean re 
