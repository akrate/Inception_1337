#!/bin/bash
set -e

DB_PASS=$(tr -d '\r\n' < /run/secrets/db_password)
ROOT_PASS=$(tr -d '\r\n' < /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    echo "Initializing MariaDB for the first time..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null

    mysqld_safe --user=mysql --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    until mariadb-admin ping; do
        sleep 1
    done
    echo "Heeeeeeeeere"
    # Execute all commands in a single session before closing root
    mariadb -u root -e "
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASS}';
    FLUSH PRIVILEGES;
    "

    # Shutdown temporary server with new root password
    mariadb-admin -u root -p"${ROOT_PASS}" shutdown
    wait "$pid"

    echo "Database setup completed successfully."
fi

exec mysqld_safe --user=mysql --bind-address=0.0.0.0 --skip-name-resolve