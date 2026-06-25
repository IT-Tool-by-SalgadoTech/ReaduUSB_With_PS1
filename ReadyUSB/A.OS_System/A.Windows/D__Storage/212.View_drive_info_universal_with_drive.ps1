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
Write-Host "  Script: 212.View_drive_info_universal_with_drive.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0212" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Shows volume and filesystem information for a specified drive letter using fsutil" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$driveLetter = Read-Host "Drive letter (e.g. C:)"

if ([string]::IsNullOrWhiteSpace($driveLetter)) {
    Write-Host "  ERROR: No drive letter provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    fsutil fsinfo volumeinfo $driveLetter
    Write-Host "  SUCCESS: Volume info retrieved for drive '$driveLetter'." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to retrieve info for '$driveLetter'. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."