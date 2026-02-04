# WSL2 Setup Guide for Microsandbox

## Why WSL2?

Docker Desktop on Windows **CANNOT** run microsandbox because it lacks KVM virtualization support. The container exits with code 139 (segmentation fault) when trying to start the microsandbox server.

**Root cause**: Microsandbox uses libkrun which requires KVM (Kernel-based Virtual Machine) - only available in native Linux environments.

## Prerequisites

- Windows 10/11 with WSL2 enabled
- Ubuntu WSL2 instance installed

## Step-by-Step Setup

### 1. Access WSL2

```bash
wsl -d Ubuntu
```

### 2. Install Docker in WSL2

```bash
# Update package lists
sudo apt update

# Install Docker
curl -fsSL https://get.docker.com | sudo sh

# Add your user to docker group (optional, to avoid sudo)
sudo usermod -aG docker $USER

# Start Docker service
sudo service docker start
```

### 3. Navigate to Project Directory

```bash
cd /mnt/c/Users/admin/Desktop/microsandbox
```

### 4. Build and Run

```bash
# Build and start in detached mode
sudo docker-compose up -d --build

# Check logs
sudo docker-compose logs -f

# You should see:
# ✅ "Docker is ready!"
# ✅ "Starting microsandbox server..."
# ✅ Server listening on port 5555
```

### 5. Test Connection

```bash
# In WSL2
python3 test.py
```

## Troubleshooting

### Docker daemon not starting

```bash
# Check status
sudo service docker status

# Restart Docker
sudo service docker restart
```

### Permission denied

```bash
# Use sudo for docker commands
sudo docker-compose up -d

# Or add user to docker group and re-login
sudo usermod -aG docker $USER
exit  # Exit WSL and re-enter
```

### Port already in use

```bash
# Stop existing containers
sudo docker-compose down

# Check what's using port 5555
sudo lsof -i :5555
```

### Container exits immediately

```bash
# Check logs for errors
sudo docker-compose logs

# Rebuild from scratch
sudo docker-compose down -v
sudo docker-compose up --build
```

## Verification

Your setup is working if you see:

```
✓ containerd successfully booted in 0.XXXs
✓ Docker daemon started
✓ API listen on /var/run/docker.sock
✓ Docker is ready!
✓ Starting microsandbox server...
```

## References

- [microsandbox SELF_HOSTING.md](https://github.com/zerocore-ai/microsandbox/blob/main/SELF_HOSTING.md)
- [microsandbox CLOUD_HOSTING.md](https://github.com/zerocore-ai/microsandbox/blob/main/CLOUD_HOSTING.md)
- Platform requirements: Linux (Recommended) or macOS (Apple Silicon only)
