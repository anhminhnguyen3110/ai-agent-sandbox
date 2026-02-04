#!/bin/sh
set -e

# Start dockerd directly in background without TLS
dockerd --host=unix:///var/run/docker.sock &

# Wait for Docker to be ready
echo "Waiting for Docker daemon to start..."
for i in $(seq 1 60); do
    if docker info >/dev/null 2>&1; then
        echo "Docker is ready!"
        break
    fi
    sleep 1
done

# Verify Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "ERROR: Docker failed to start after 60 seconds"
    exit 1
fi

# Start microsandbox server
echo "Starting microsandbox server..."
exec /root/.local/bin/msb server start --dev --host 0.0.0.0
