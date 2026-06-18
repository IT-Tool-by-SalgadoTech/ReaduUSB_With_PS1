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
Write-Host "  Script: 49.Toggle-VMwareservises_Download_PS1.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0049" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Virtualization" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the Toggle-VMwareServices script from the SalgadoTech GitHub repository to the Desktop and launches it in a new PowerShell window" -ForegroundColor DarkCyan
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

$dst = "$env:USERPROFILE\Desktop\Toggle-VMwareServices.ps1"
$raw = "https://raw.githubusercontent.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/main/Toggle-VMwareServices.ps1"

try {
    $destFolder = Split-Path $dst
    if (-not (Test-Path -Path $destFolder)) {
        New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
    }

    Write-Host "  Downloading Toggle-VMwareServices.ps1 to Desktop..." -ForegroundColor Cyan
    curl.exe -L $raw -o $dst

    if (Test-Path $dst) {
        Write-Host "  Download complete: $dst" -ForegroundColor Green
        Write-Host "  Launching script in a new PowerShell window..." -ForegroundColor Cyan
        Start-Process -FilePath "$PSHOME\powershell.exe" -ArgumentList @('-NoExit', '-ExecutionPolicy', 'Bypass', '-File', $dst)
        Write-Host "  Script launched successfully." -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Download failed. File not found at destination." -ForegroundColor Red
    }
} catch {
    Write-Host "  ERROR: An unexpected error occurred." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."