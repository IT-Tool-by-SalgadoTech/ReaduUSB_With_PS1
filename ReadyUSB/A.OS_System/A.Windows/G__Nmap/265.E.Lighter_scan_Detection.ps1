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
Write-Host "  Script: 265_E_Lighter_scan_Detection.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0265" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Runs Nmap service version detection (-sV) with adjustable probe intensity (0=light to 9=aggressive)" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$IP = Read-Host "Enter target IP address"
$Intensity = Read-Host "Enter version intensity (0=light, 9=aggressive)"

if ($Intensity -notmatch '^[0-9]$') {
    Write-Host "  ERROR: Intensity must be a single digit between 0 and 9." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Running: nmap -sV --version-intensity $Intensity $IP" -ForegroundColor Cyan
Write-Host ""

nmap -sV --version-intensity $Intensity "$IP"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  Scan completed." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: Nmap scan failed or nmap not found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."