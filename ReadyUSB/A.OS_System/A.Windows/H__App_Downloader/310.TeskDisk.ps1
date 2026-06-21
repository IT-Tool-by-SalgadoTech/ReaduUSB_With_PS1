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
Write-Host "  Script: 309_TeskDisk.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0309" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the TestDisk 7.3 ZIP from GitHub, extracts it to the Desktop, and launches testdisk_win.exe" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url    = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/testdisk-7.3-WIP.zip"
$zip    = Join-Path $env:USERPROFILE "Desktop\testdisk-7.3-WIP.zip"
$dest   = Join-Path $env:USERPROFILE "Desktop\testdisk-7.3-WIP"

Write-Host "  Downloading TestDisk 7.3 from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (Test-Path $dest) {
    Remove-Item $dest -Recurse -Force
}

Write-Host ""
Write-Host "  Extracting to Desktop\testdisk-7.3-WIP..." -ForegroundColor Cyan

try {
    Expand-Archive -Path $zip -DestinationPath $dest -Force
    Write-Host "  SUCCESS: Extracted to $dest" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Extraction failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$exe = (Get-ChildItem -Path $dest -Filter "testdisk_win.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1).FullName

if ($exe) {
    Write-Host ""
    Write-Host "  Launching TestDisk..." -ForegroundColor Cyan
    Start-Process $exe
    Write-Host "  SUCCESS: TestDisk launched." -ForegroundColor Green
} else {
    Write-Host "  ERROR: testdisk_win.exe not found after extraction." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."