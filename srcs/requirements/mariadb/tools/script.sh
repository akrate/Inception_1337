#!/bin/bash
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

mysqld_safe --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &

sleep 5 

mariadb --socket=/run/mysqld/mysqld.sock -u root -p"${DB_PASSWORD}" << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
FLUSH PRIVILEGES;
EOF



mysqladmin --socket=/run/mysqld/mysqld.sock -u root -p"${DB_PASSWORD}" shutdown

exec mysqld_safe --user=mysqlH