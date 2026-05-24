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
Write-Host "  Script: 256_C_Execute_nmap_using_the_path.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0256" -ForegroundColor Cyan
Write-Host "  Version: 1.2" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Verifies nmap.exe runs correctly from a manually entered full path (use when nmap is not in PATH)" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$path = Read-Host "Enter the full path to nmap.exe (e.g. C:\Program Files (x86)\Nmap\nmap.exe)"

if (Test-Path $path) {
    & $path --version
    Write-Host ""
    Write-Host "  Nmap executed successfully." -ForegroundColor Green
} else {
    Write-Host "  ERROR: Path not found: $path" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."