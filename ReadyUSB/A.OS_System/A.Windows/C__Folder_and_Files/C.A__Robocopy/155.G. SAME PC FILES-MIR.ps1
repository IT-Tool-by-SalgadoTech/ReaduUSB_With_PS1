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
Write-Host "  Script: 155.G._SAME_PC_FILES-MIR.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0155" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > File Copy" -ForegroundColor DarkCyan
Write-Host "  Description: Mirrors a local source folder to a local destination using Robocopy /MIR, deleting files in destination that no longer exist in source" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$source      = Read-Host "Enter source path"
$destination = Read-Host "Enter destination path"

robocopy $source $destination /MIR

if ($LASTEXITCODE -le 3) {
    Write-Host "  Mirror copy completed successfully." -ForegroundColor Green
} else {
    Write-Host "  ERROR: Robocopy reported errors (exit code $LASTEXITCODE)." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."