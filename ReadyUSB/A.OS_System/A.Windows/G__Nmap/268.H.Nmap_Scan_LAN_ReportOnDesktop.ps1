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
Write-Host "  Script: 268_H_Nmap_Scan_LAN_ReportOnDesktop.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0268" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Scans one or two subnets with nmap -sV and saves the report to the Desktop" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$ip     = Read-Host "Enter target IP or subnet (e.g. 192.168.1.0)"
$prefix = Read-Host "Enter prefix length (e.g. 24)"
$report = "$env:USERPROFILE\Desktop\nmap_scan_lan.txt"

Write-Host ""
Write-Host "  Running nmap scan. This may take a while..." -ForegroundColor Cyan

nmap -sV -oN "$report" 192.168.50.0/24 "$ip/$prefix"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  SUCCESS: Scan complete. Report saved to:" -ForegroundColor Green
    Write-Host "  $report" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: nmap exited with code $LASTEXITCODE." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."