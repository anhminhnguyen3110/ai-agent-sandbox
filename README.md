# ai-agent-sandbox

Docker-based microsandbox environment for running isolated Python code execution.

## ⚠️ CRITICAL: KVM Virtualization Requirement

**Microsandbox requires KVM/libkrun virtualization** to run microVMs.

### ✅ Supported Platforms:

#### Option 1: WSL2 with Docker (Windows)
Best option for Windows users - native Linux kernel with KVM support:
```bash
# In WSL2
getent group kvm | cut -d: -f3  # Get KVM GID
echo "KVM_GID=108" > .env        # Set the GID
sudo docker-compose up -d --build
```

#### Option 2: Native Linux with KVM
Host must have KVM enabled. Verify with:
```bash
# Check KVM availability
ls -la /dev/kvm
# Should show: crw-rw---- 1 root kvm ...

# Get KVM group ID
getent group kvm | cut -d: -f3

# Set in .env file
echo "KVM_GID=108" > .env  # Replace 108 with your actual GID
```

#### Option 3: Cloud Servers
- **Bare-metal**: Scaleway, OVHcloud, Hetzner, Vultr (best performance)
- **Nested virtualization VMs**: DigitalOcean, Google Cloud (enable flag), Azure Dv3/Ev3

### ❌ Will NOT Work:
- ❌ Docker Desktop on Windows (no /dev/kvm device)
- ❌ macOS without Apple Silicon
- ❌ Containers without KVM device access

**Sources**: 
- [microsandbox CLOUD_HOSTING.md](https://github.com/zerocore-ai/microsandbox/blob/main/CLOUD_HOSTING.md)
- [StackOverflow: KVM in Docker](https://stackoverflow.com/questions/48422001)

## Features

- 🐳 Simple Alpine container with Docker socket mounting (no Docker-in-Docker)
- 🔒 Isolated sandbox environment for safe code execution
- 🚀 Microsandbox server with development mode
- 🐍 Python client library for easy interaction

## Architecture

This setup enables **KVM inside Docker** by:
- ✅ Mounting `/dev/kvm` device from host
- ✅ Adding container user to host's `kvm` group (GID matching required)
- ✅ Using host Docker socket for container management
- ✅ No privileged mode needed (more secure than `--privileged`)
- ✅ QEMU/KVM for hardware-accelerated virtualization

**Key insight**: The trick is matching the container's kvm group GID to the host's kvm GID using `group_add` in docker-compose.

## Quick Start

### Using WSL2 (Required for Windows)

```bash
# 1. Enter WSL2
wsl -d Ubuntu

# 2. Install Docker in WSL2
curl -fsSL https://get.docker.com | sudo sh
sudo service docker start

# 3. Navigate to project
cd /mnt/c/Users/admin/Desktop/microsandbox

# 4. Start microsandbox
sudo docker-compose up -d --build

# 5. Verify it's running
sudo docker-compose logs -f
```

The microsandbox server will be available at `http://localhost:5555`

### Test with Python

```python
import asyncio
from microsandbox import PythonSandbox

async def main():
    async with PythonSandbox.create(
        server_url="http://localhost:5555",
        name="python-demo"
    ) as sb:
        # Execute Python code
        exec = await sb.run("print('Hello from Python!')")
        print(await exec.output())

asyncio.run(main())
```

## Architecture

- **Base Image**: `docker:27-dind` (Alpine Linux with Docker-in-Docker)
- **Runtime**: glibc compatibility layer for microsandbox binaries
- **Isolation**: Each sandbox runs in its own Docker container
- **Port**: 5555 (configurable)

## Files

- `Dockerfile` - Optimized Alpine-based image with microsandbox
- `docker-compose.yml` - Service configuration
- `entrypoint.sh` - Startup script handling Docker daemon and microsandbox server
- `test.py` - Python client example
- `setup-wsl.sh` - WSL2 setup script

## Requirements

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- For optimal performance on Windows: WSL2 with nested virtualization support

## License

MIT
