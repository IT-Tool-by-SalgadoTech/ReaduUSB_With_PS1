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
Write-Host "  IT-Tool by ITTOOL" -ForegroundColor Cyan
Write-Host "  Script: 715.Stop_SoftAP_HostedNetwork.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0715" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Stops and disallows the Wi-Fi hosted network (SoftAP) so the machine stops acting as an access point" -ForegroundColor DarkCyan
Write-Host "  (c) 2026 ITTOOL - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "  Hosted network status before action:" -ForegroundColor White
$before = netsh wlan show hostednetwork | Select-String "Status"
if ($before) { Write-Host ("    " + $before.ToString().Trim()) -ForegroundColor Cyan }

$stopOut    = netsh wlan stop hostednetwork 2>&1
$disallow   = netsh wlan set hostednetwork mode=disallow 2>&1

Start-Sleep -Seconds 1
$after = (netsh wlan show hostednetwork | Select-String "Status")
$isStarted = $after -match "Started"

if (-not $isStarted) {
    Write-Host "  Hosted network stopped and set to disallow." -ForegroundColor Green
} else {
    Write-Host "  WARNING: Hosted network may still be active. Check the output below." -ForegroundColor Red
    Write-Host ("    " + $stopOut) -ForegroundColor Yellow
    Write-Host ("    " + $disallow) -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Note: this targets the legacy Wi-Fi hosted network. The Windows" -ForegroundColor White
Write-Host "  'Mobile hotspot' feature is separate and may need to be turned off" -ForegroundColor White
Write-Host "  from Settings if it is the source of the access point." -ForegroundColor White

Write-Host ""
Read-Host "Press Enter to exit..."