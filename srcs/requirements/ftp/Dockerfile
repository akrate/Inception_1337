FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/script.sh /script.sh

RUN chmod +x /script.sh && \
    mkdir -p /var/run/vsftpd/empty && \
    mkdir -p /var/www/html && \
    useradd -m -d /var/www/html -s /bin/bash ftpuser && \
    echo "ftpuser:ftppass123!" | chpasswd

EXPOSE 21

ENTRYPOINT ["/script.sh"]