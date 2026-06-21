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
Write-Host "  Script: 303_Process_Explorer.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0303" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads Process Explorer from GitHub, accepts the EULA silently via registry, and launches it with elevated privileges" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url  = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/ProcessExplorer/procexp64.exe"
$dest = Join-Path $env:TEMP "procexp64.exe"

Write-Host "  Downloading Process Explorer from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

reg add "HKCU\Software\Sysinternals\Process Explorer" /v EulaAccepted /t REG_DWORD /d 1 /f | Out-Null

Unblock-File -Path $dest -ErrorAction SilentlyContinue
if (Get-Item $dest -Stream "Zone.Identifier" -ErrorAction SilentlyContinue) {
    Remove-Item $dest -Stream "Zone.Identifier" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "  Launching Process Explorer..." -ForegroundColor Cyan
Start-Process -FilePath $dest -Verb RunAs
Write-Host "  SUCCESS: Process Explorer launched." -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."