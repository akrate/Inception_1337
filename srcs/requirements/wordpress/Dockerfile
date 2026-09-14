FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-redis \
    php-zip \
    mariadb-client \
    iputils-ping \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


RUN mkdir -p /var/www/html
WORKDIR /var/www/html
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh


EXPOSE 9000
ENTRYPOINT [ "/script.sh" ]