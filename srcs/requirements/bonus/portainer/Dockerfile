FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG PORTAINER_VERSION=2.19.4

RUN mkdir -p /app && \
    curl -L "https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz" -o /tmp/portainer.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /tmp && \
    cp -r /tmp/portainer/* /app/ && \
    rm -rf /tmp/portainer* /tmp/*.tar.gz

WORKDIR /app

EXPOSE 9000

CMD ["./portainer"]