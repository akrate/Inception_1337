all:
	@mkdir -p /home/aoussama/data/db_data
	@mkdir -p /home/aoussama/data/wordpress_data
	docker compose -f srcs/docker-compose.yml up -d --build


down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down -v --rmi all

re: clean all