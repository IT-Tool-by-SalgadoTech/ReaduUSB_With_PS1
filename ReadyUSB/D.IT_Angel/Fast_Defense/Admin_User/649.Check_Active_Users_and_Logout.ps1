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
Write-Host "  Script: 649.Check_Active_Users_and_Logout.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0649" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > User Sessions" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all active user sessions and logs off a selected session by ID" -ForegroundColor DarkCyan
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
    Write-Host ""
    Write-Host "  Current logged-on sessions:" -ForegroundColor Cyan
    Write-Host ""
    query user
    Write-Host ""

    $sessionID = Read-Host "  Enter the Session ID to log off"

    if ($sessionID -match '^\d+$') {
        Write-Host ""
        Write-Host "  Logging off session ID $sessionID ..." -ForegroundColor Yellow
        logoff $sessionID
        Write-Host "  Session $sessionID logged off successfully." -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Invalid Session ID entered." -ForegroundColor Red
    }
} catch {
    Write-Host "  ERROR: Failed to log off session." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."