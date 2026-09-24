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

    # Redis configuration removed as it's part of the bonus section

    chown -R www-data:www-data "$WP_PATH"
    chmod -R 757 "$WP_PATH"
    echo "WordPress installed successfully."
fi

mkdir -p /run/php

exec php-fpm8.2 -F