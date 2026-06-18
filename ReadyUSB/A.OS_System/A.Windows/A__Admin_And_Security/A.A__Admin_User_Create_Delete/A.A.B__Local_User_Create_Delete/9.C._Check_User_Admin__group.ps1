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
Write-Host "  Script: 9.C._Check_User_Admin__group.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0009" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Checks if a local user exists and belongs to the Administrators group" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Check user and group membership ──────────────────────────────────────────
$user = Read-Host "  Enter username to check"

if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
    Write-Host "  User '$user' exists." -ForegroundColor Green
    if (Get-LocalGroupMember -Group "Administrators" | Where-Object { $_.Name -match $user }) {
        Write-Host "  User '$user' IS in the Administrators group." -ForegroundColor Green
    } else {
        Write-Host "  User '$user' is NOT in the Administrators group." -ForegroundColor Yellow
    }
} else {
    Write-Host "  User '$user' does not exist." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."