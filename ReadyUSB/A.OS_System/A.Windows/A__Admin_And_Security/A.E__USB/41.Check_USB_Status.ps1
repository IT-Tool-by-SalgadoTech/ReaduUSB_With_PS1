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
Write-Host "  Script: 41.Check_USB_Status.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0041" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > USB" -ForegroundColor DarkCyan
Write-Host "  Description: Reads the USBSTOR registry key to report whether USB storage devices are enabled or blocked" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Read USBSTOR Start value ──────────────────────────────────────────────────
Write-Host "  Checking USB storage status..." -ForegroundColor Cyan
Write-Host ""

try {
    $val = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR' -Name Start -ErrorAction Stop).Start
    Write-Host ("  USBSTOR Start value: {0}" -f $val) -ForegroundColor White

    switch ($val) {
        3 { Write-Host "  Status: ENABLED - USB storage devices are allowed." -ForegroundColor Green }
        4 { Write-Host "  Status: DISABLED - USB storage devices are blocked." -ForegroundColor Red }
        default { Write-Host ("  Status: Unknown value ({0}). Manual review recommended." -f $val) -ForegroundColor Yellow }
    }
} catch {
    Write-Host "  ERROR: Could not read USBSTOR registry key. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."