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
Write-Host "  Script: 275_Q_What_hosts_are_alive_on_a_LAN.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0275" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Performs a ping scan (-sn) on a subnet or IP range to discover which hosts are alive on the LAN" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$ip = Read-Host "Enter subnet or IP range (e.g. 192.168.1.0/24)"

Write-Host ""
Write-Host "  Running nmap host discovery on $ip..." -ForegroundColor Cyan

nmap -sn "$ip"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  SUCCESS: Host discovery complete." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: nmap exited with code $LASTEXITCODE." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."