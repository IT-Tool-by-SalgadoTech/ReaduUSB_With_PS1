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
Write-Host "  Script: Enable_Firewall_AllProfiles.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Enables the Windows Firewall on the Domain, Private, and Public profiles" -ForegroundColor DarkCyan
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

try {
    Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True -ErrorAction Stop
    Write-Host "  Firewall enable command applied to all profiles." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Could not apply firewall enable command." -ForegroundColor Red
    Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Current firewall profile state:" -ForegroundColor White
foreach ($p in (Get-NetFirewallProfile)) {
    if ($p.Enabled) {
        Write-Host ("    {0,-8} : ENABLED" -f $p.Name) -ForegroundColor Green
    } else {
        Write-Host ("    {0,-8} : DISABLED" -f $p.Name) -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."