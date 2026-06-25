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
Write-Host "  Script: 117.IP_Private_And_Public.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0117" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Displays all private IPv4 addresses per adapter and retrieves the current public IP from ipify.org" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    Write-Host "  --- Private IP Addresses ---" -ForegroundColor Cyan
    $privateIPs = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object { $_.IPAddress -notlike "169.*" -and $_.IPAddress -ne "127.0.0.1" }

    if ($privateIPs) {
        $privateIPs | ForEach-Object {
            Write-Host ("  Adapter: {0,-30} IP: {1}" -f $_.InterfaceAlias, $_.IPAddress) -ForegroundColor Green
        }
    } else {
        Write-Host "  No private IPv4 addresses found." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "  --- Public IP Address ---" -ForegroundColor Cyan
    $publicIP = Invoke-RestMethod -Uri "https://api.ipify.org?format=text" -ErrorAction Stop
    Write-Host "  Public IP: $publicIP" -ForegroundColor Green

} catch {
    Write-Host "  ERROR: Could not retrieve public IP address." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."