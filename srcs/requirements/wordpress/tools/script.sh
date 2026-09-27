#!/bin/bash
set -e

WP_PATH="/var/www/html"
CONFIG_FILE="$WP_PATH/wp-config.php"

DB_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/credentials)

echo "Connecting to MariaDB..."
until mariadb-admin ping -h"mariadb" -u"$MYSQL_USER" -p"$DB_PASSWORD"; do
    sleep 2
done
echo "MariaDB is ready!"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Starting fresh WordPress installation..."

    wp core download --path="$WP_PATH" --allow-root

    wp config create \
        --path="$WP_PATH" \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    wp core install \
        --path="$WP_PATH" \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --path="$WP_PATH" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    # Configure Redis cache for WordPress
    echo "Configuring Redis cache..."
    wp config set WP_REDIS_HOST "${REDIS_HOST:-redis}" --path="$WP_PATH" --allow-root
    wp config set WP_REDIS_PORT "6379" --raw --path="$WP_PATH" --allow-root
    wp config set WP_REDIS_TIMEOUT "1" --raw --path="$WP_PATH" --allow-root
    wp config set WP_REDIS_READ_TIMEOUT "1" --raw --path="$WP_PATH" --allow-root
    wp config set WP_CACHE_KEY_SALT "${DOMAIN_NAME}" --path="$WP_PATH" --allow-root
    
    # Install and activate Redis cache plugin
    wp plugin install redis-cache --activate --path="$WP_PATH" --allow-root
    wp redis enable --path="$WP_PATH" --allow-root
    
    echo "Redis cache configured successfully."

    chown -R www-data:www-data "$WP_PATH"
    chmod -R 757 "$WP_PATH"
    echo "WordPress installed successfully."
fi

chmod -R o+w /var/www/html

mkdir -p /run/php

exec php-fpm8.2 -F