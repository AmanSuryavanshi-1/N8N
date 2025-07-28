# n8n Startup Script
# This script starts the n8n instance using the reorganized project structure

Write-Host "Starting n8n with reorganized project structure..." -ForegroundColor Green

# Check if Docker is running
try {
    docker version | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Docker is not running. Please start Docker Desktop first." -ForegroundColor Red
    exit 1
}

# Navigate to config directory
$configPath = Join-Path $PSScriptRoot "..\config"
if (-not (Test-Path $configPath)) {
    Write-Host "[ERROR] Config directory not found at: $configPath" -ForegroundColor Red
    exit 1
}

Set-Location $configPath
Write-Host "[OK] Changed to config directory: $configPath" -ForegroundColor Green

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "[WARNING] .env file not found. Please copy .env.example to .env and configure your settings." -ForegroundColor Yellow
    Write-Host "  Copy-Item '.env.example' '.env'" -ForegroundColor Cyan
    
    # Ask if user wants to continue anyway
    $continue = Read-Host "Continue without .env file? (y/N)"
    if ($continue -ne "y" -and $continue -ne "Y") {
        exit 1
    }
}

# Start n8n
Write-Host "Starting n8n container..." -ForegroundColor Green
try {
    docker-compose up -d
    Write-Host "[SUCCESS] n8n started successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Access your n8n instance at:" -ForegroundColor Cyan
    Write-Host "  Local: http://localhost:5678" -ForegroundColor White
    Write-Host "  Public: https://your-domain.com (if tunnel is configured)" -ForegroundColor White
    Write-Host ""
    Write-Host "To view logs: docker-compose logs -f n8n" -ForegroundColor Yellow
    Write-Host "To stop: docker-compose down" -ForegroundColor Yellow
} catch {
    Write-Host "[ERROR] Failed to start n8n. Check the error above." -ForegroundColor Red
    exit 1
}