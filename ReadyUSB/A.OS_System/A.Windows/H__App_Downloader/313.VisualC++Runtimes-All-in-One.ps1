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
Write-Host "  Script: 312_VisualC__Runtimes-All-in-One.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0312" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads and silently installs the Visual C++ 2015-2022 x64 redistributable with elevated privileges" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url  = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/Visual-C-Runtimes-All-in-One-Nov-2024/vcredist2015_2017_2019_2022_x64.exe"
$dest = Join-Path $env:TEMP "vcredist2015_2017_2019_2022_x64.exe"

Write-Host "  Downloading Visual C++ 2015-2022 x64 redistributable from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Unblock-File -Path $dest -ErrorAction SilentlyContinue
if (Get-Item $dest -Stream "Zone.Identifier" -ErrorAction SilentlyContinue) {
    Remove-Item $dest -Stream "Zone.Identifier" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "  Installing Visual C++ Runtimes silently..." -ForegroundColor Cyan

$proc = Start-Process -FilePath $dest -ArgumentList "/install", "/quiet", "/norestart" -Verb RunAs -PassThru -Wait
$code = $proc.ExitCode

switch ($code) {
    0    { Write-Host "  SUCCESS: Installation complete." -ForegroundColor Green }
    1638 { Write-Host "  INFO: A newer version is already installed (OK)." -ForegroundColor Yellow }
    3010 { Write-Host "  SUCCESS: Installed. A system restart is required (exit code 3010)." -ForegroundColor Yellow }
    default { Write-Host "  WARNING: Installer exit code: $code" -ForegroundColor Yellow }
}

Write-Host ""
Read-Host "Press Enter to exit..."