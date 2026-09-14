#!/bin/bash

WP_PATH="/var/www/html"
CONFIG_FILE="$WP_PATH/wp-config.php"
SAMPLE_FILE="$WP_PATH/wp-config-sample.php"
DB_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PWS=$(cat /run/secrets/db_root_password)
WP_USER_PASSWORD=$(grep wp_user /run/secrets/credentials | cut -d = -f2)

if [ ! -f "$CONFIG_FILE" ]; then

    if [ ! -f "$SAMPLE_FILE" ]; then
        curl -O https://wordpress.org/latest.tar.gz
        tar -xzf latest.tar.gz
        cp -r wordpress/* $WP_PATH/
        rm -rf wordpress latest.tar.gz
    fi

    cp "$SAMPLE_FILE" "$CONFIG_FILE"
    chown -R www-data:www-data /var/www/html
    chmod 755 /var/www/html
    sed -i "s|database_name_here|${MYSQL_DATABASE}|g" "$CONFIG_FILE"
    sed -i "s|username_here|${MYSQL_USER}|g" "$CONFIG_FILE"
    sed -i "s|password_here|${DB_PASSWORD}|g" "$CONFIG_FILE"
    sed -i "s|localhost|mariadb:3306|g" "$CONFIG_FILE"
    
    until wp db check --allow-root --path="$WP_PATH" 2>/dev/null; do
        sleep 1
    done


fi


sed -i "/That's all, stop editing/i \
define('WP_REDIS_HOST', 'redis');\n\
define('WP_REDIS_PORT', 6379);" /var/www/html/wp-config.php

wp core install \
        --allow-root \
        --url="https://$NAME_D" \
        --title="inception" \
        --admin_user="$ADMIN" \
        --admin_password="$ADMIN_PWS" \
        --admin_email="$EMAIL" \
        --path='/var/www/html'

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --allow-root \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --path='/var/www/html'
    wp plugin install redis-cache \
        --allow-root \
        --activate \
        --path='/var/www/html'
    wp redis enable \
        --allow-root
chown -R www-data:www-data /var/www/html
mkdir -p /run/php

exec php-fpm8.2 -F