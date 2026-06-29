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
Write-Host "  Script: 312_MemTest.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0312" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads MemTest64 from GitHub and launches it for RAM stress testing" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/MemTest64.exe"
$exe = Join-Path $env:TEMP "MemTest64.exe"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Get-Process -Name "MemTest64*" -ErrorAction SilentlyContinue | Stop-Process -Force
Remove-Item $exe -Force -ErrorAction SilentlyContinue

Write-Host "  Downloading MemTest64 from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing -ErrorAction Stop
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (Test-Path $exe) {
    Write-Host ""
    Write-Host "  Launching MemTest64..." -ForegroundColor Cyan
    Start-Process -FilePath $exe
    Write-Host "  SUCCESS: MemTest64 launched." -ForegroundColor Green
} else {
    Write-Host "  ERROR: Executable not found after download." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."