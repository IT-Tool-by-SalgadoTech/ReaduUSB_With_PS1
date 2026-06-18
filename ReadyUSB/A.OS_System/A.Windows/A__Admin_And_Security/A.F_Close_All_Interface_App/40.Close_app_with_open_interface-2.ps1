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
Write-Host "  Script: 40.Close_app_with_open_interface-2.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0040" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Process Management" -ForegroundColor DarkCyan
Write-Host "  Description: Force-closes all user-facing processes with a visible window, excluding critical system processes" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Force-close windowed processes, skip critical system ones ─────────────────
Write-Host "  Force-closing all windowed user processes..." -ForegroundColor Cyan

Get-Process | Where-Object {
    $_.MainWindowHandle -ne 0 -and
    $_.Name -notmatch 'winlogon|csrss|services|lsass|dwm|system'
} | ForEach-Object {
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

Write-Host "  Done." -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."