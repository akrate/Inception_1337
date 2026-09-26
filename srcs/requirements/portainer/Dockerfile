FROM portainer/portainer-ce:latest

# Create volume for persistent data
VOLUME /data

# Copy custom configuration if needed
COPY conf/ /etc/portainer/

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:9000/api/status || exit 1

EXPOSE 9000 8000

ENTRYPOINT ["/portainer"]