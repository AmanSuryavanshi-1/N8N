# Cloudflare Tunnel Troubleshooting Guide

## ✅ **Tunnel Script Fixed**

The `start-tunnel.ps1` script has been fixed to resolve the string termination error.

## 🚀 **Quick Start Commands**

### **Option 1: Use the Fixed Script**
```powershell
.\scripts\start-tunnel.ps1
```

### **Option 2: Direct Command**
```powershell
.\scripts\cloudflared.exe --config config\config.yml tunnel run 2e471211-4395-4e8c-ad8d-33d549ce7e7c
```

### **Option 3: Minimal Command (if config issues)**
```powershell
.\scripts\cloudflared.exe tunnel run 2e471211-4395-4e8c-ad8d-33d549ce7e7c
```

## 🔧 **Tunnel Configuration**

Your tunnel is configured for:
- **Tunnel ID**: `2e471211-4395-4e8c-ad8d-33d549ce7e7c`
- **Domain**: `n8n.aviatorstrainingcentre.in`
- **Local Service**: `http://localhost:5678`

## 🛠️ **Common Issues & Solutions**

### **Issue: "Unable to reach the origin service"**
**Cause**: n8n container not running or wrong port
**Solution**: 
1. Ensure n8n is running: `docker ps`
2. Test local access: `curl http://localhost:5678`
3. Restart n8n if needed: `cd config && docker-compose restart`

### **Issue: "String termination error"**
**Cause**: Special characters in PowerShell script
**Solution**: ✅ **FIXED** - Use the updated script

### **Issue: "cloudflared.exe not found"**
**Cause**: Wrong path to executable
**Solution**: Ensure cloudflared.exe is in `scripts/` directory

### **Issue: "config.yml not found"**
**Cause**: Config file missing or wrong path
**Solution**: Ensure config.yml is in `config/` directory

## 📋 **Verification Steps**

### **1. Check n8n is Running**
```powershell
docker ps
# Should show config-n8n-1 container running
```

### **2. Test Local Access**
```powershell
curl http://localhost:5678
# Should return HTTP 200
```

### **3. Start Tunnel**
```powershell
.\scripts\start-tunnel.ps1
# Should connect without errors
```

### **4. Test Public Access**
```powershell
curl https://n8n.aviatorstrainingcentre.in
# Should return n8n interface
```

## 🌐 **Access URLs**

- **Local**: http://localhost:5678
- **Public**: https://n8n.aviatorstrainingcentre.in
- **Tunnel Status**: Check tunnel logs for connection status

## 📝 **Tunnel Logs**

When the tunnel is running, you'll see logs like:
```
2025-07-28T19:13:31Z INF Connection established
2025-07-28T19:13:31Z INF Tunnel connected
```

If you see errors about "Unable to reach origin service", it means n8n isn't running properly.

---

**Status**: Tunnel script fixed and ready to use! ✅