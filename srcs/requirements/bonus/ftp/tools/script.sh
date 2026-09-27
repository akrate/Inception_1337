#!/bin/bash
set -e


FTP_USER="ftpuser"

if ! id "$FTP_USER" &>/dev/null; then
    useradd -m -s /bin/bash $FTP_USER
fi


echo "$FTP_USER:1234" | chpasswd

mkdir -p /var/run/vsftpd/empty

usermod -d /var/www/html ftpuser

chown -R $FTP_USER:$FTP_USER /var/www/html  

# Ensure proper permissions for WordPress files
exec vsftpd /etc/vsftpd.conf