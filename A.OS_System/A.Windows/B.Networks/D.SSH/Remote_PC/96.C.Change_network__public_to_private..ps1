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
Write-Host "  Script: 96.C.Change_network__public_to_private_.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0096" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > SSH" -ForegroundColor DarkCyan
Write-Host "  Description: Displays current network profiles and changes any Public-category interface to Private" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
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
    Write-Host "  Current network profiles:" -ForegroundColor Cyan
    Get-NetConnectionProfile | Format-Table -AutoSize Name, InterfaceAlias, NetworkCategory, IPv4Connectivity

    $publicProfiles = Get-NetConnectionProfile | Where-Object { $_.NetworkCategory -eq 'Public' }

    if ($publicProfiles) {
        $publicProfiles | ForEach-Object {
            Set-NetConnectionProfile -InterfaceAlias $_.InterfaceAlias -NetworkCategory Private
            Write-Host "  Interface '$($_.InterfaceAlias)' changed from Public to Private." -ForegroundColor Green
        }

        Write-Host ""
        Write-Host "  Updated network profiles:" -ForegroundColor Cyan
        Get-NetConnectionProfile | Format-Table -AutoSize Name, InterfaceAlias, NetworkCategory, IPv4Connectivity
    } else {
        Write-Host "  No Public network profiles found. No changes made." -ForegroundColor Yellow
    }

} catch {
    Write-Host "  ERROR: Failed to change network profile." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."