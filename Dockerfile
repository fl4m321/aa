# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y curl unzip sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create a new non-root user
RUN useradd -m coder && \
    mkdir -p /home/coder/.local/share/code-server && \
    chown -R coder:coder /home/coder

# Switch to non-root user
USER coder
WORKDIR /home/coder

# Set environment variables (optional password for authentication)
ENV PASSWORD="changeme"

# Expose the correct port (Render/Railway will provide it dynamically)
EXPOSE 8080

# Start Code Server with authentication and correct port
CMD ["sh", "-c", "code-server --auth password --host 0.0.0.0 --bind-addr 0.0.0.0:${PORT:-8080}"]
