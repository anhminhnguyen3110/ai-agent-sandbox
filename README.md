# ai-agent-sandbox

Docker-based microsandbox environment for running isolated Python code execution.

## ⚠️ CRITICAL: KVM Virtualization Requirement

**Microsandbox requires KVM/libkrun virtualization** which is **NOT available in Docker Desktop on Windows**.

### ✅ Supported Platforms:
- **WSL2 with Docker** (recommended for Windows users)
- **Native Linux** with KVM support
- **Bare-metal servers**: Scaleway, OVHcloud, Hetzner, Vultr
- **Cloud VMs with nested virtualization**: DigitalOcean, Google Cloud (with flag), Azure Dv3/Ev3
- **macOS**: Apple Silicon only (M1/M2/M3/M4)

### ❌ Will NOT Work:
- Docker Desktop on Windows → exits with code 139 (segmentation fault)
- Containers without KVM/nested virtualization support

**Source**: [microsandbox CLOUD_HOSTING.md](https://github.com/zerocore-ai/microsandbox/blob/main/CLOUD_HOSTING.md)

## Features

- 🐳 Docker-in-Docker setup with Alpine Linux (optimized, no apt required)
- 🔒 Isolated sandbox environment for safe code execution
- 🚀 Microsandbox server with development mode
- 🐍 Python client library for easy interaction

## Quick Start

### Using Docker Compose

```bash
docker-compose up -d --build
```

The microsandbox server will be available at `http://localhost:5555`

### Using WSL2 (Recommended for Windows)

```bash
wsl -d Ubuntu
curl -fsSL https://get.docker.com | sudo sh
sudo service docker start
sudo docker-compose up -d --build
```

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
