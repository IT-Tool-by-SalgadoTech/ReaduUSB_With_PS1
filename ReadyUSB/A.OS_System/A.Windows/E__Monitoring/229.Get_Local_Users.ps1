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
Write-Host "  Script: 229.Get_Local_Users.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0229" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all local user accounts on the machine with name, enabled status, and last logon date" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $users = Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordRequired, Description

    if ($users) {
        Write-Host "  SUCCESS: $($users.Count) local user(s) found." -ForegroundColor Green
        Write-Host ""
        $users | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No local users found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve local users. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."