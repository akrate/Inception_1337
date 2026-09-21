#!/bin/bash
set -e

WP_PATH="/var/www/html"
CONFIG_FILE="$WP_PATH/wp-config.php"

DB_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(grep wp_user /run/secrets/credentials | cut -d = -f2)

echo "Connecting to MariaDB..."
until mariadb-admin ping -h"mariadb" -u"$MYSQL_USER" -p"$DB_PASSWORD" --silent; do
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
        --dbhost="mariadb:3306" \
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

    if [ -n "$REDIS_HOST" ]; then
        echo "Configuring Redis cache..."
        wp config set WP_REDIS_HOST "$REDIS_HOST" --path="$WP_PATH" --allow-root
        wp config set WP_REDIS_PORT 6379 --raw --path="$WP_PATH" --allow-root
        wp plugin install redis-cache --activate --path="$WP_PATH" --allow-root
        wp redis enable --path="$WP_PATH" --allow-root
    fi

    chown -R www-data:www-data "$WP_PATH"
    chmod -R 755 "$WP_PATH"
    echo "WordPress installed successfully."
fi

mkdir -p /run/php

exec php-fpm7.4 -F