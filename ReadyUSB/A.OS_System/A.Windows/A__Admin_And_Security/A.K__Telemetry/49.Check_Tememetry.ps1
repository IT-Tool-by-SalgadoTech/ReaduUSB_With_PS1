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
Write-Host "  Script: 49.Check_Tememetry.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0049" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Privacy & Telemetry" -ForegroundColor DarkCyan
Write-Host "  Description: Checks Windows telemetry registry policies, service status, and scheduled tasks related to data collection" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

Write-Host "  --- DataCollection Policy ---" -ForegroundColor Cyan
try {
    reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection
    Write-Host "  DataCollection policy read successfully." -ForegroundColor Green
} catch {
    Write-Host "  WARNING: DataCollection policy key not found or not readable." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  --- DiagTrack Service ---" -ForegroundColor Cyan
try {
    Get-Service DiagTrack | Format-List Name, Status, StartType
    Write-Host "  DiagTrack service status retrieved." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to retrieve DiagTrack service status." -ForegroundColor Red
}

Write-Host ""
Write-Host "  --- dmwappushservice Service ---" -ForegroundColor Cyan
try {
    Get-Service dmwappushservice | Format-List Name, Status, StartType
    Write-Host "  dmwappushservice status retrieved." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to retrieve dmwappushservice status." -ForegroundColor Red
}

Write-Host ""
Write-Host "  --- CloudContent Policy ---" -ForegroundColor Cyan
try {
    reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent
    Write-Host "  CloudContent policy read successfully." -ForegroundColor Green
} catch {
    Write-Host "  WARNING: CloudContent policy key not found or not readable." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  --- Scheduled Tasks (Customer Experience) ---" -ForegroundColor Cyan
try {
    schtasks /query | findstr Experience
    Write-Host "  Scheduled tasks query complete." -ForegroundColor Green
} catch {
    Write-Host "  WARNING: No matching scheduled tasks found." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."