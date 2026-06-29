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
Write-Host "  Script: 282_G_Nmap_Scan_against_IP_or_host.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0282" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Runs a standard Nmap scan against a user-supplied IP address or hostname" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$target = Read-Host "Enter IP address or hostname"

Write-Host ""
Write-Host "  Running: nmap $target" -ForegroundColor Cyan
Write-Host ""

nmap "$target"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  Scan completed." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: Nmap scan failed or nmap not found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."