#!/bin/sh
set -e

# Start Docker daemon in background using the official entrypoint
/usr/local/bin/dockerd-entrypoint.sh dockerd &

# Wait for Docker to be ready
echo "Waiting for Docker daemon to start..."
for i in $(seq 1 30); do
    if docker info >/dev/null 2>&1; then
        echo "Docker is ready!"
        break
    fi
    sleep 1
done

# Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker failed to start"
    exit 1
fi

# Start microsandbox server with full path
echo "Starting microsandbox server..."
if [ -f /root/.local/bin/msb ]; then
    exec /root/.local/bin/msb server start --dev --host 0.0.0.0
else
    echo "ERROR: msb binary not found at /root/.local/bin/msb"
    ls -la /root/.local/bin/ || echo "Directory does not exist"
    exit 1
fi
