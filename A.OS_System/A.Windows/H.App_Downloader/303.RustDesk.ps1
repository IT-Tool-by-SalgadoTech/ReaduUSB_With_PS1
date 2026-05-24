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
Write-Host "  Script: 303_RustDesk.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0303" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the RustDesk 1.4.3 x64 installer from GitHub to the Desktop and launches it" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url  = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/rustdesk-1.4.3-x86_64.exe"
$dest = Join-Path ([Environment]::GetFolderPath("Desktop")) "rustdesk-1.4.3-x86_64.exe"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "  Downloading RustDesk 1.4.3 x64 from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    Write-Host "  SUCCESS: Download complete: $dest" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Launching RustDesk installer..." -ForegroundColor Cyan
Start-Process $dest

Write-Host ""
Read-Host "Press Enter to exit..."