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
Write-Host "  Script: 278_C_Fast_Scaning_nmap_-T4_-A_-v.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0278" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Runs an aggressive Nmap scan (-T4 -A -v) for fast OS detection, service versions, and traceroute" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$IP = Read-Host "Enter target IP address"

Write-Host ""
Write-Host "  Running: nmap -T4 -A -v $IP" -ForegroundColor Cyan
Write-Host ""

nmap -T4 -A -v "$IP"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  Scan completed." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: Nmap scan failed or nmap not found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."