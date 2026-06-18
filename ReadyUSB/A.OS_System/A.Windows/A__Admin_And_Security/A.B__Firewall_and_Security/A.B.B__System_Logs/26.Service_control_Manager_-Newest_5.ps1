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
Write-Host "  Script: 26.Service_control_Manager_-Newest_5.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0026" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Logs" -ForegroundColor DarkCyan
Write-Host "  Description: Retrieves the 5 most recent System event log entries from the Service Control Manager source" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $events = Get-EventLog -LogName System -Source "Service Control Manager" -Newest 5
    if ($events) {
        $events | Format-Table TimeGenerated, EntryType, EventID, Message -AutoSize
        Write-Host "  Displayed the 5 most recent Service Control Manager entries." -ForegroundColor Green
    } else {
        Write-Host "  No Service Control Manager entries found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve Service Control Manager log entries." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."