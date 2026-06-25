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
Write-Host "  Script: 231.Installed_drivers.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0231" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all installed signed device drivers with device name, driver version, and manufacturer" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $drivers = Get-CimInstance -ClassName Win32_PnPSignedDriver -ErrorAction Stop |
        Select-Object DeviceName, DriverVersion, Manufacturer |
        Sort-Object DeviceName

    if ($drivers) {
        Write-Host "  SUCCESS: $($drivers.Count) driver(s) found." -ForegroundColor Green
        Write-Host ""
        $drivers | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No signed drivers found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve driver list. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."