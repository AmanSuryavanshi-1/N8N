# Cloudflare Tunnel Startup Script
# This script starts the Cloudflare tunnel for public n8n access

Write-Host "Starting Cloudflare Tunnel..." -ForegroundColor Green

# Check if cloudflared.exe exists
$cloudflaredPath = Join-Path $PSScriptRoot "cloudflared.exe"
if (-not (Test-Path $cloudflaredPath)) {
    Write-Host "[ERROR] cloudflared.exe not found at: $cloudflaredPath" -ForegroundColor Red
    Write-Host "Please download cloudflared.exe and place it in the scripts/ directory" -ForegroundColor Yellow
    exit 1
}

# Check if config.yml exists
$configPath = Join-Path $PSScriptRoot "..\config\config.yml"
if (-not (Test-Path $configPath)) {
    Write-Host "[ERROR] config.yml not found at: $configPath" -ForegroundColor Red
    Write-Host "Please ensure config.yml is properly configured in the config/ directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Found cloudflared.exe and config.yml" -ForegroundColor Green

# Start the tunnel
Write-Host "Starting tunnel with config: $configPath" -ForegroundColor Cyan
try {
    & $cloudflaredPath --config $configPath tunnel run 2e471211-4395-4e8c-ad8d-33d549ce7e7c
} catch {
    Write-Host "[ERROR] Failed to start tunnel. Check your configuration." -ForegroundColor Red
    Write-Host "Make sure you have:" -ForegroundColor Yellow
    Write-Host "  1. Authenticated with Cloudflare: .\scripts\cloudflared.exe tunnel login" -ForegroundColor White
    Write-Host "  2. Created a tunnel: .\scripts\cloudflared.exe tunnel create your-tunnel-name" -ForegroundColor White
    Write-Host "  3. Configured DNS: .\scripts\cloudflared.exe tunnel route dns your-tunnel-name your-domain.com" -ForegroundColor White
    exit 1
}