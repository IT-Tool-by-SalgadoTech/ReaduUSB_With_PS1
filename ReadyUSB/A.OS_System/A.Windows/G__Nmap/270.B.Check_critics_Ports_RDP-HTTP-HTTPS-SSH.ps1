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
Write-Host "  Script: 270_B_Check_critics_Ports_RDP-HTTP-HTTPS-SSH.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0270" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Checks critical ports SSH/HTTP/HTTPS/RDP (22,80,443,3389) via Nmap on a target IP" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$IP = Read-Host "Enter target IP address"

Write-Host ""
Write-Host "  Running: nmap -p 22,80,443,3389 $IP" -ForegroundColor Cyan
Write-Host ""

nmap -p 22,80,443,3389 "$IP"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  Scan completed." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: Nmap scan failed or nmap not found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."