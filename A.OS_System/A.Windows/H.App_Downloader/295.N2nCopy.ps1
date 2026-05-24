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
Write-Host "  Script: 295_N2nCopy.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0295" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the N2nCopy ZIP from GitHub, extracts it to the Desktop, and launches n2ncopy.exe" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url     = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/n2ncopy_en.zip"
$zipDest = Join-Path $env:USERPROFILE "Downloads\n2ncopy_en.zip"
$desk    = [Environment]::GetFolderPath("Desktop")
$base    = Join-Path $desk "n2ncopy_en"
$exe     = Join-Path $base "n2ncopy.exe"

Remove-Item $base -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "  Downloading N2nCopy ZIP from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $zipDest -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Extracting to Desktop\n2ncopy_en..." -ForegroundColor Cyan

try {
    Expand-Archive -Path $zipDest -DestinationPath $desk -Force
    Write-Host "  SUCCESS: Extraction complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Extraction failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (-not (Test-Path $exe)) {
    $found = Get-ChildItem -Path $base -Recurse -Filter "n2ncopy.exe" -File -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) { $exe = $found.FullName }
}

if (-not $exe -or -not (Test-Path $exe)) {
    Write-Host "  ERROR: n2ncopy.exe not found after extraction." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Unblock-File -Path $exe -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "  Launching N2nCopy..." -ForegroundColor Cyan
Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe -Parent)
Write-Host "  SUCCESS: N2nCopy launched from $exe" -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."