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
Write-Host "  Script: 234.Processes_ordered_from_highest_to_lowest_CPU_usage_get_process.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0234" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all running processes sorted by CPU usage from highest to lowest" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $procs = Get-Process | Sort-Object CPU -Descending |
        Select-Object Name, Id, CPU, WorkingSet, Description

    if ($procs) {
        Write-Host "  SUCCESS: $($procs.Count) process(es) found." -ForegroundColor Green
        Write-Host ""
        $procs | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No processes found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve process list. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."