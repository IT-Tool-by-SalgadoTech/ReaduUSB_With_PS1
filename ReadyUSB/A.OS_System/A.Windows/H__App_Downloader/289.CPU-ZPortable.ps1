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
Write-Host "  Script: 289_CPU-ZPortable.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0289" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads and silently installs CPU-Z Portable, then launches the executable" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url    = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/CPU-ZPortable_2.16_English.paf.exe"
$exe    = Join-Path $env:TEMP "CPU-ZPortable_2.16_English.paf.exe"
$dstDir = Join-Path $env:TEMP "CPUZPortable"

Get-Process -Name "*cpuz*", "CPU-Z*" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "  Downloading CPU-Z Portable from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

New-Item -ItemType Directory -Path $dstDir -Force | Out-Null

Write-Host ""
Write-Host "  Installing CPU-Z Portable silently..." -ForegroundColor Cyan
Start-Process -FilePath $exe -ArgumentList "/S", "/D=$dstDir" -Wait

$launch = Join-Path $dstDir "CPU-ZPortable.exe"
if (Test-Path $launch) {
    Write-Host "  SUCCESS: Launching CPU-Z Portable..." -ForegroundColor Green
    Start-Process -FilePath $launch -WorkingDirectory $dstDir
} else {
    $found = Get-ChildItem $dstDir -Recurse -Filter "cpuz*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Write-Host "  SUCCESS: Launching CPU-Z Portable..." -ForegroundColor Green
        Start-Process $found.FullName
    } else {
        Write-Host "  ERROR: Executable not found after installation." -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."