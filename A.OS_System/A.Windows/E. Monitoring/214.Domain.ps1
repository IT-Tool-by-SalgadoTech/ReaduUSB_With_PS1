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
Write-Host "  Script: 214.Domain.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0214" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Displays the domain or workgroup the machine belongs to" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
    Write-Host "  SUCCESS: Domain information retrieved." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Computer Name : $($cs.Name)" -ForegroundColor Cyan
    if ($cs.PartOfDomain) {
        Write-Host "  Domain        : $($cs.Domain)" -ForegroundColor Cyan
    } else {
        Write-Host "  Workgroup     : $($cs.Workgroup)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve domain information. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."