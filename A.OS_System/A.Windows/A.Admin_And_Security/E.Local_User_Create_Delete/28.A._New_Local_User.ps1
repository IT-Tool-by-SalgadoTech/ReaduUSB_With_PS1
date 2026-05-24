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
Write-Host "  Script: 28.A._New_Local_User.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0028" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Creates a new local user and adds it to the Users group" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Admin check ───────────────────────────────────────────────────────────────
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# ── Create new local user ─────────────────────────────────────────────────────
$user   = Read-Host "  Enter username"
$pass   = Read-Host "  Enter password"
$secure = ConvertTo-SecureString $pass -AsPlainText -Force

try {
    New-LocalUser -Name $user -Password $secure -FullName $user -Description "IT-Tool User" -ErrorAction Stop
    Add-LocalGroupMember -Group "Users" -Member $user -ErrorAction Stop
    Write-Host "  User '$user' created and added to the Users group." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."