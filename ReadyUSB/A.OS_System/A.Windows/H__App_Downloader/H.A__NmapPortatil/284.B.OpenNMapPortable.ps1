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
Write-Host "  Script: 284_B_OpenNMapPortable.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0284" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Launches NmapPortable.exe from the user Desktop folder" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$nmapPath = Join-Path $env:USERPROFILE "Desktop\NmapPortable\NmapPortable.exe"

if (-not (Test-Path $nmapPath)) {
    Write-Host "  ERROR: NmapPortable not found at:" -ForegroundColor Red
    Write-Host "  $nmapPath" -ForegroundColor Red
    Write-Host "  Run 276_A_Nmap_Download.ps1 first to install it." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "  Launching NmapPortable..." -ForegroundColor Cyan
Start-Process "$nmapPath"
Write-Host "  SUCCESS: NmapPortable launched." -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."