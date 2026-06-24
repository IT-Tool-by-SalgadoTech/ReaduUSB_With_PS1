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
Write-Host "  Script: 100.A.Enable_SSH_Server.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0100" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > SSH" -ForegroundColor DarkCyan
Write-Host "  Description: Checks whether the OpenSSH Server Windows capability is installed or available" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    Write-Host "  Checking OpenSSH Server capability status..." -ForegroundColor Cyan
    $cap = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'

    if ($cap) {
        $cap | Format-List Name, State
        if ($cap.State -eq 'Installed') {
            Write-Host "  OpenSSH Server is installed." -ForegroundColor Green
        } else {
            Write-Host "  OpenSSH Server is available but not installed." -ForegroundColor Yellow
        }
    } else {
        Write-Host "  OpenSSH Server capability not found on this system." -ForegroundColor Red
    }
} catch {
    Write-Host "  ERROR: Failed to query Windows capabilities." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."