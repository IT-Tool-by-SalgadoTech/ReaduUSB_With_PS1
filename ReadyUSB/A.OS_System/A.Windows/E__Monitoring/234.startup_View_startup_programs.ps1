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
Write-Host "  Script: 234.startup_View_startup_programs.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0234" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all startup programs with name, command, and registry or folder location" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $startupItems = Get-CimInstance -ClassName Win32_StartupCommand -ErrorAction Stop |
        Select-Object Name, Command, Location, User |
        Sort-Object Name

    if ($startupItems) {
        Write-Host "  SUCCESS: $($startupItems.Count) startup program(s) found." -ForegroundColor Green
        Write-Host ""
        $startupItems | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No startup programs found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve startup programs. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."