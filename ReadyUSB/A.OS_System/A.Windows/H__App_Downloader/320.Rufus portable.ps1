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
Write-Host "  Script: 320_Rufus_portable.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0320" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads and silently installs Rufus Portable, then launches it" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url  = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/RufusPortable_4.9.paf.exe"
$exe  = Join-Path $env:TEMP "RufusPortable_4.9.paf.exe"
$dest = Join-Path $env:TEMP "RufusPortable"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Get-Process -Name "RufusPortable*", "Rufus*" -ErrorAction SilentlyContinue | Stop-Process -Force
Remove-Item $exe -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $dest -Force | Out-Null

Write-Host "  Downloading Rufus Portable from GitHub..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $exe -UseBasicParsing -ErrorAction Stop
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Installing Rufus Portable silently..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $exe -ArgumentList "/S", "/D=$dest" -PassThru
$proc.WaitForExit()

$launch = Join-Path $dest "RufusPortable.exe"
if (Test-Path $launch) {
    Write-Host "  SUCCESS: Launching Rufus Portable..." -ForegroundColor Green
    Start-Process -FilePath $launch -WorkingDirectory $dest
} else {
    $found = Get-ChildItem $dest -Recurse -Filter "RufusPortable.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Write-Host "  SUCCESS: Launching Rufus Portable..." -ForegroundColor Green
        Start-Process $found.FullName
    } else {
        Write-Host "  ERROR: Executable not found after installation." -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."