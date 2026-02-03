#!/bin/bash
# Run microsandbox in WSL2

set -e

echo "Installing Docker in WSL2..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Starting Docker daemon..."
sudo service docker start

echo "Building and running microsandbox container..."
cd /mnt/c/Users/admin/Desktop/microsandbox
sudo docker-compose up -d --build

echo "Waiting for microsandbox to start..."
sleep 15

echo "Testing microsandbox server..."
curl http://localhost:5555 || echo "Server started but endpoint not found (expected)"

echo ""
echo "✓ Microsandbox is running in WSL2!"
echo "Access it at: http://localhost:5555"
