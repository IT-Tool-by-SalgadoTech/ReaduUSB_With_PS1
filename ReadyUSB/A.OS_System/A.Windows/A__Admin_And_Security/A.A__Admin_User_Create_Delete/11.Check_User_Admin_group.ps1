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
Write-Host "  Script: Check_User_Admin_group.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0011" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Checks if a local user exists and belongs to the Administrators group" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$user = Read-Host "Enter username"

if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
    Write-Output "User '$user' exists."
    if (Get-LocalGroupMember -Group "Administrators" | Where-Object { $_.Name -match $user }) {
        Write-Output "User '$user' is in the Administrators group."
    } else {
        Write-Output "User '$user' is NOT in the Administrators group."
    }
} else {
    Write-Output "User '$user' does not exist."
}

Read-Host "Presiona Enter para salir..."