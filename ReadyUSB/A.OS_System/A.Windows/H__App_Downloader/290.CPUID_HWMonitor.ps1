Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host ""
Write-Host " _____ _____  _______ ____   ____  _     " -ForegroundColor Cyan
Write-Host "|_   _|_   _||__   __/ __ \ / __ \| |    " -ForegroundColor Cyan
Write-Host "  | |   | |     | | | |  | | |  | | |    " -ForegroundColor Cyan
Write-Host "  | |   | |     | | | |  | | |  | | |    " -ForegroundColor Cyan
Write-Host " _| |_  | |     | | | |__| | |__| | |___ " -ForegroundColor Cyan
Write-Host "|_____| |_|     |_|  \____/ \____/|_____|" -ForegroundColor Cyan
Write-Host ""
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host "  IT-Tool by SalgadoTech" -ForegroundColor Cyan
Write-Host "  Script: 290_CPUID_HWMonitor.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0290" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads HWMonitor from GitHub to the Desktop and launches it" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$dest = "$env:USERPROFILE\Desktop\hwmonitor_1.63.exe"
$url  = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/hwmonitor_1.63.exe"

$destDir = Split-Path $dest
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

Write-Host "  Downloading HWMonitor from GitHub..." -ForegroundColor Cyan

try {
    curl.exe -L $url -o $dest
    if (-not (Test-Path $dest)) { throw "File not found after download." }
    Write-Host "  SUCCESS: Download complete: $dest" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Launching HWMonitor..." -ForegroundColor Cyan
Start-Process "$dest"

Write-Host ""
Read-Host "Press Enter to exit..."