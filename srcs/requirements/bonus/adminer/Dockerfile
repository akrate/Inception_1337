FROM debian:bookworm

# Install PHP core and database extensions
RUN apt-get update && apt-get install -y \
    php-cli \
    php-mysql \
    php-pgsql \
    php-sqlite3 \
    curl \
    wget \ 
    && rm -rf /var/lib/apt/lists/*


WORKDIR /var/www/html

RUN curl -L -o /var/www/html/adminer.php https://www.adminer.org/latest.php && \ 
    mv adminer.php index.php


# Expose the traffic port
EXPOSE 8080

ENTRYPOINT ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]