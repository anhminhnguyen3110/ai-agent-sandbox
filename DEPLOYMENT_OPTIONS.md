# Deployment Options for Microsandbox (No WSL2)

## ❌ Problem: Windows Native NOT Supported

Microsandbox **does not work** on Docker Desktop for Windows because:
- No `/dev/kvm` device available
- libkrun requires Linux kernel KVM support
- Windows Hypervisor Platform port is still in development (Issue #47)

## ✅ Solution 1: Cloud Linux VM with KVM (RECOMMENDED)

Deploy to a cloud provider with KVM support:

### DigitalOcean Droplet ($4/month)
```bash
# 1. Create Ubuntu droplet with nested virtualization
# 2. SSH to droplet
ssh root@your-droplet-ip

# 3. Install Docker
curl -fsSL https://get.docker.com | sh

# 4. Clone project
git clone https://github.com/anhminhnguyen3110/ai-agent-sandbox.git
cd ai-agent-sandbox

# 5. Get KVM GID
getent group kvm | cut -d: -f3

# 6. Set environment
echo "KVM_GID=108" > .env  # Replace with actual GID

# 7. Run
docker-compose up -d --build

# 8. Access from Windows
# Server will be at: http://your-droplet-ip:5555
```

### Other Cloud Providers:
- **Google Cloud**: n1-standard-1 instance, enable nested virtualization
  ```bash
  gcloud compute instances create msb-instance \
    --enable-nested-virtualization \
    --min-cpu-platform "Intel Haswell"
  ```
  
- **Azure**: Dv3 or Ev3 series VMs (nested virt enabled by default)
- **Vultr**: Any KVM instance
- **Hetzner**: Bare-metal servers (best performance)

## ✅ Solution 2: Docker Machine with VirtualBox/Hyper-V

Create a Linux VM on Windows that runs Docker:

### Option A: VirtualBox
```powershell
# Install Docker Machine
choco install docker-machine

# Create Ubuntu VM with VirtualBox
docker-machine create --driver virtualbox \
  --virtualbox-cpu-count "2" \
  --virtualbox-memory "4096" \
  microsandbox-vm

# Configure shell to use this VM
docker-machine env microsandbox-vm | Invoke-Expression

# Now docker commands will run in the VM
cd C:\Users\admin\Desktop\microsandbox
docker-compose up -d --build

# Access server
docker-machine ip microsandbox-vm  # Get IP
# Server at: http://<VM-IP>:5555
```

### Option B: Hyper-V (Windows Pro/Enterprise)
```powershell
# Create VM with Hyper-V driver
docker-machine create --driver hyperv \
  --hyperv-cpu-count 2 \
  --hyperv-memory 4096 \
  --hyperv-virtual-switch "Default Switch" \
  microsandbox-vm
```

## ✅ Solution 3: Multipass VM (Ubuntu on Windows)

Lightweight Ubuntu VM manager by Canonical:

```powershell
# Install Multipass
choco install multipass

# Create Ubuntu VM
multipass launch --name microsandbox --cpus 2 --mem 4G --disk 20G

# Shell into VM
multipass shell microsandbox

# Inside VM:
sudo apt update
curl -fsSL https://get.docker.com | sudo sh

# Mount Windows folder into VM
exit
multipass mount C:\Users\admin\Desktop\microsandbox microsandbox:/home/ubuntu/microsandbox

# Back in VM
multipass shell microsandbox
cd /home/ubuntu/microsandbox
sudo docker-compose up -d --build
```

## ✅ Solution 4: GitHub Codespaces (Free Tier)

Run in cloud with free compute:

1. Push code to GitHub (already done ✅)
2. Go to repo: https://github.com/anhminhnguyen3110/ai-agent-sandbox
3. Click **Code** → **Codespaces** → **Create codespace**
4. In codespace terminal:
```bash
# Get KVM GID
getent group kvm | cut -d: -f3

# Set env
echo "KVM_GID=108" > .env

# Run
docker-compose up -d --build

# Forward port 5555 in VS Code
# Access from Windows at localhost:5555
```

## Comparison

| Solution | Cost | Setup Time | Performance | Best For |
|----------|------|------------|-------------|----------|
| **DigitalOcean** | $4/mo | 5 min | ⭐⭐⭐⭐⭐ | Production |
| **Google Cloud** | $34/mo | 10 min | ⭐⭐⭐⭐⭐ | Enterprise |
| **Docker Machine** | Free | 15 min | ⭐⭐⭐ | Local dev |
| **Multipass** | Free | 10 min | ⭐⭐⭐⭐ | Local dev |
| **Codespaces** | Free | 2 min | ⭐⭐⭐⭐ | Quick testing |

## Recommended for You

Since you don't want WSL2, I suggest:

1. **Quick test**: GitHub Codespaces (instant, free)
2. **Local development**: Multipass (clean, lightweight)
3. **Production**: DigitalOcean Droplet (cheap, reliable)

## Why WSL2 is Actually Easier (FYI)

Despite your preference, WSL2 is the simplest option:
- ✅ Already have Ubuntu installed
- ✅ Native Windows integration
- ✅ No extra VM to manage
- ✅ Direct file access
- ✅ 1 command: `wsl -d Ubuntu` then run docker-compose

But if you absolutely don't want WSL2, **Multipass** or **Codespaces** are your best bets.
