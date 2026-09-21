FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

COPY tools/script.sh /script.sh
COPY conf/maria.conf /etc/mysql/mariadb.conf.d/

RUN chmod +x /script.sh

EXPOSE 3306

ENTRYPOINT ["/script.sh"]
