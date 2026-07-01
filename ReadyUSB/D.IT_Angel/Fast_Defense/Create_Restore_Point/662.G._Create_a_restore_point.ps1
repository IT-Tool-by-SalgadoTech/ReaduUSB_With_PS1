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
Write-Host "  Script: 664.G._Create_a_restore_point.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0664" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Restore" -ForegroundColor DarkCyan
Write-Host "  Description: Creates a new system restore point labeled ReadyUSB_RestorePoint" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Admin check ───────────────────────────────────────────────────────────────
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# ── Create restore point ──────────────────────────────────────────────────────
Write-Host "  Creating restore point 'ReadyUSB_RestorePoint'..." -ForegroundColor Cyan
try {
    Checkpoint-Computer -Description "ReadyUSB_RestorePoint" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
    Write-Host "  Restore point created successfully." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Could not create restore point. $_" -ForegroundColor Red
    Write-Host "  Tip: Run script 24 first to remove the 24-hour frequency restriction." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."