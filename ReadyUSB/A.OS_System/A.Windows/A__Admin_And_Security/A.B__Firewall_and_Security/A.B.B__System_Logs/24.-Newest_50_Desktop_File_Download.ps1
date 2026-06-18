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
Write-Host "  Script: 24.-Newest_50_Desktop_File_Download.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0024" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Logs" -ForegroundColor DarkCyan
Write-Host "  Description: Exports the last 50 System log entries to a text file on the Desktop" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Export last 50 System log entries to Desktop ──────────────────────────────
$outFile = "$env:USERPROFILE\Desktop\SystemLog.txt"
Write-Host "  Exporting last 50 System log entries to Desktop..." -ForegroundColor Cyan
try {
    Get-EventLog -LogName System -Newest 50 | Out-File $outFile -ErrorAction Stop
    Write-Host "  Saved to: $outFile" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."