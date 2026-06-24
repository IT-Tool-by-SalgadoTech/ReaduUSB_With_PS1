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
Write-Host "  Script: 58.BIOS.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0058" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Reboots the system directly into BIOS/UEFI firmware or Windows Recovery Environment (WinRE)" -ForegroundColor DarkCyan
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

Write-Host "  1) Reboot to BIOS/UEFI  (/fw)" -ForegroundColor White
Write-Host "  2) Reboot to WinRE      (/o)" -ForegroundColor White
Write-Host ""
$opt = Read-Host "  Enter option (1 or 2)"

if ($opt -eq '1') {
    Write-Host "  Rebooting to BIOS/UEFI firmware..." -ForegroundColor Yellow
    shutdown.exe /r /fw /t 0
} elseif ($opt -eq '2') {
    Write-Host "  Rebooting to Windows Recovery Environment..." -ForegroundColor Yellow
    shutdown.exe /r /o /t 0
} else {
    Write-Host "  ERROR: Invalid option. Run again and choose 1 or 2." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
}