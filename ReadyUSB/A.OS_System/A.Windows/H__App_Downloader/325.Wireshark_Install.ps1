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
Write-Host "  Script: 325_Wireshark_Install.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0325" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Installs Wireshark via winget and launches it after verifying the installation path" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "  Installing Wireshark via winget..." -ForegroundColor Cyan
winget install --id WiresharkFoundation.Wireshark --exact --silent --accept-package-agreements --accept-source-agreements

if ($LASTEXITCODE -eq 0) {
    Write-Host "  SUCCESS: Wireshark installed." -ForegroundColor Green
} else {
    Write-Host "  WARNING: winget exit code $LASTEXITCODE - verifying path anyway..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  Verifying installation..." -ForegroundColor Cyan

$wiresharkExe = "$env:ProgramFiles\Wireshark\Wireshark.exe"
if (-not (Test-Path $wiresharkExe)) {
    $wiresharkExe = "${env:ProgramFiles(x86)}\Wireshark\Wireshark.exe"
}

if (Test-Path $wiresharkExe) {
    Write-Host "  SUCCESS: Wireshark found at $wiresharkExe" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Launching Wireshark..." -ForegroundColor Cyan
    Start-Process $wiresharkExe
} else {
    Write-Host "  WARNING: Executable not found in expected paths." -ForegroundColor Yellow
    Write-Host "  Check manually from the Start menu." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."