#!/bin/bash
set -e

echo "Starting FTP server..."

# Ensure proper permissions for WordPress files
chown -R ftpuser:ftpuser /var/www/html

exec vsftpd /etc/vsftpd.conf