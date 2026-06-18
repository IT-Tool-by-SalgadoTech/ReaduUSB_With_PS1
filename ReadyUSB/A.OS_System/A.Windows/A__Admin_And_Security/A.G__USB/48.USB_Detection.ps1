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
Write-Host "  Script: 48.USB_Detection.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0048" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > USB" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads usb_monitor.py from GitHub to the Desktop and launches it with Python" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Download usb_monitor.py and launch ────────────────────────────────────────
$dst = "$env:USERPROFILE\Desktop\usb_monitor.py"
$url = 'https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/usb_monitor.py'

Write-Host "  Downloading usb_monitor.py to Desktop..." -ForegroundColor Cyan
try {
    $desktopDir = Split-Path $dst
    if (-not (Test-Path $desktopDir)) { New-Item -ItemType Directory -Path $desktopDir -Force | Out-Null }
    curl.exe -L $url -o $dst
    Write-Host "  Download complete. Launching usb_monitor.py..." -ForegroundColor Green
    Set-Location "$HOME\Desktop"
    python .\usb_monitor.py
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."