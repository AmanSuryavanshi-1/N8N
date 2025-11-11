# Quick Command Reference

_Essential commands for your reorganized n8n project_

## 🚀 Starting Services

### Start n8n (Recommended Method)

```powershell
# Use the provided script
.\scripts\start-n8n.ps1
```

### Start n8n (Manual Method) - AS

```powershell
# Navigate to config directory first

cd config
docker-compose up -d

```

### Start Cloudflare Tunnel - AS

```powershell
# Option 1: Use the script
.\scripts\start-tunnel.ps1

# Option 2: Manual command

.\scripts\cloudflared.exe --config config\config.yml tunnel run 2e471211-4395-4e8c-ad8d-33d549ce7e7c

```

## 🔧 Docker Commands

### From Root Directory

```powershell
# Start n8n
docker-compose -f config/docker-compose.yml up -d

# Stop n8n
docker-compose -f config/docker-compose.yml down

# View logs
docker-compose -f config/docker-compose.yml logs -f n8n

# Pull updates
docker-compose -f config/docker-compose.yml pull
```

### From Config Directory

```powershell
cd config

# Start n8n
docker-compose up -d

# Stop n8n
docker-compose down

# View logs
docker-compose logs -f n8n

# Pull updates
docker-compose pull
```

## 📁 File Locations

### Configuration Files

- **Docker Compose**: `config/docker-compose.yml`
- **Environment**: `config/.env` (copy from `config/.env.example`)
- **Tunnel Config**: `config/config.yml`

### Executables

- **Cloudflared**: `scripts/cloudflared.exe`
- **Startup Scripts**: `scripts/*.ps1`

### Workflows

- **ATC Module**: `modules/atc-meeting-scheduler/workflows/`
- **RAG Module**: `modules/personal-rag-agent/workflows/`
- **Standalone**: `workflows/`

## 🌐 Access URLs

- **Local n8n**: http://localhost:5678
- **Public n8n**: https://n8n.aviatorstrainingcentre.in
- **Tunnel ID**: `2e471211-4395-4e8c-ad8d-33d549ce7e7c`

## ⚡ Quick Setup

### First Time Setup

```powershell
# 1. Copy environment template
Copy-Item "config\.env.example" "config\.env"

# 2. Edit config\.env with your values
notepad config\.env

# 3. Start n8n
.\scripts\start-n8n.ps1

# 4. Start tunnel (optional)
.\scripts\start-tunnel.ps1
```

### Daily Usage

```powershell
# Start everything
.\scripts\start-n8n.ps1
.\scripts\start-tunnel.ps1

# Check status
docker ps

# View logs
cd config && docker-compose logs -f n8n
```

## 🛠️ Troubleshooting

### "No configuration file provided"

**Problem**: Running docker-compose from wrong directory
**Solution**: Either use scripts or run from config/ directory

### "cloudflared.exe not recognized"

**Problem**: Wrong path to cloudflared
**Solution**: Use `.\scripts\cloudflared.exe` (not `.\cloudflared.exe`)

### "Container not starting"

**Problem**: Environment or configuration issues
**Solution**: Check logs with `docker-compose logs -f n8n`

## 📋 Status Checks

```powershell
# Check if Docker is running
docker version

# Check running containers
docker ps

# Check n8n logs
cd config && docker-compose logs -f n8n

# Test tunnel connectivity
curl https://n8n.aviatorstrainingcentre.in
```

---

_Keep this file handy for quick reference to common commands and troubleshooting!_

## 🔄 **n8n Update Process**

### **Quick Update (Recommended)**
```powershell
# From config directory
cd config
docker-compose pull
docker-compose up -d
```

### **Update with Verification**
```powershell
# 1. Pull latest image
cd config
docker-compose pull

# 2. Stop current container
docker-compose down

# 3. Start with new image
docker-compose up -d

# 4. Check version and status
docker-compose logs n8n --tail=10
```

### **Update from Root Directory**
```powershell
# One-liner update
docker-compose -f config/docker-compose.yml pull && docker-compose -f config/docker-compose.yml up -d
```

### **Version Check**
```powershell
# Check current n8n version
docker-compose logs n8n | grep "Version:"

# Check container status
docker ps

# Test accessibility
curl http://localhost:5678
```

---

**Latest Update**: n8n successfully updated to version **1.104.1** ✅