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
Write-Host "  Script: 239.services.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0239" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all currently running Windows services with name, display name, and startup type" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $services = Get-Service | Where-Object { $_.Status -eq 'Running' } |
        Select-Object Name, DisplayName, StartType |
        Sort-Object DisplayName

    if ($services) {
        Write-Host "  SUCCESS: $($services.Count) running service(s) found." -ForegroundColor Green
        Write-Host ""
        $services | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No running services found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve services. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."