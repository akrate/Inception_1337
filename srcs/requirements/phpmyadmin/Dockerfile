FROM phpmyadmin:latest

# Create custom configuration
COPY conf/config.user.inc.php /etc/phpmyadmin/config.user.inc.php

# Set environment variables for default configuration
ENV PMA_HOST=mariadb
ENV PMA_PORT=3306
ENV PMA_USER=wp_user
ENV UPLOAD_LIMIT=128M
ENV MEMORY_LIMIT=256M