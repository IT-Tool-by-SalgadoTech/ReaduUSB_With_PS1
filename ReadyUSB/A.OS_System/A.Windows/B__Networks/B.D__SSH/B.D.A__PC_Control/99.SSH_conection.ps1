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
Write-Host "  Script: SSH_conection.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0099" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-24" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Remote Access" -ForegroundColor DarkCyan
Write-Host "  Description: Opens an interactive SSH connection to a user-specified host" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
ssh ("{0}@{1}" -f (Read-Host "Enter the SSH username"), (Read-Host "Enter the IP address or hostname"))