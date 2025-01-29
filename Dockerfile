# Use a lightweight Debian-based image
FROM debian:bookworm-slim

# Set the working directory
WORKDIR /root

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl unzip sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# Install Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Set environment variables for authentication
ENV PASSWORD="changeme"

# Expose port (Render & Railway will set this automatically)
EXPOSE 8080

# Disable telemetry and auto-updates for better performance
RUN mkdir -p /root/.config/code-server && \
    echo "bind-addr: 0.0.0.0:${PORT:-8080}" > /root/.config/code-server/config.yaml && \
    echo "auth: password" >> /root/.config/code-server/config.yaml && \
    echo "password: ${PASSWORD}" >> /root/.config/code-server/config.yaml && \
    echo "disable-telemetry: true" >> /root/.config/code-server/config.yaml && \
    echo "disable-update-check: true" >> /root/.config/code-server/config.yaml

# Run as root and start Code Server
CMD ["sh", "-c", "code-server --auth password --host 0.0.0.0 --bind-addr 0.0.0.0:${PORT:-8080}"]
