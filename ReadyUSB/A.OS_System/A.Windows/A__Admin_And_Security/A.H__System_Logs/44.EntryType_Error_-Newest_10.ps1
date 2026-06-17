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
Write-Host "  Script: 44.EntryType_Error_-Newest_10.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0044" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Logs" -ForegroundColor DarkCyan
Write-Host "  Description: Retrieves the 10 most recent Error entries from the System event log" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $errors = Get-EventLog -LogName System -EntryType Error -Newest 10
    if ($errors) {
        $errors | Format-Table TimeGenerated, Source, EventID, Message -AutoSize
        Write-Host "  Displayed the 10 most recent System Error entries." -ForegroundColor Green
    } else {
        Write-Host "  No error entries found in the System event log." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve event log entries." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."