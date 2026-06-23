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
Write-Host "  Script: 171.G.Map_network_drive.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0171" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Shared Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Maps a network UNC path to a drive letter persistently, removing any existing mapping on that letter first" -ForegroundColor DarkCyan
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

$uncPath     = Read-Host "Enter UNC path (e.g. \\SERVER\Share)"
$driveLetter = (Read-Host "Enter drive letter (e.g. Z)").TrimEnd(':').ToUpper()

if ([string]::IsNullOrWhiteSpace($uncPath) -or [string]::IsNullOrWhiteSpace($driveLetter)) {
    Write-Host "  ERROR: UNC path and drive letter cannot be empty." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$driveLabel = "${driveLetter}:"

# Remove existing mapping on that drive letter
net use $driveLabel /delete /y 2>$null | Out-Null

# Remove stale registry entry
Remove-Item "HKCU:\Network\$driveLetter" -Recurse -Force -ErrorAction SilentlyContinue

# Verify UNC is reachable
if (-not (Test-Path $uncPath)) {
    Write-Host "  ERROR: UNC path not reachable: '$uncPath'" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# Map the drive persistently
net use $driveLabel "$uncPath" /persistent:yes | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "  SUCCESS: '$driveLabel' mapped to '$uncPath' (persistent)." -ForegroundColor Green
    Start-Process explorer.exe $driveLabel
} else {
    Write-Host "  ERROR: Failed to map '$driveLabel' to '$uncPath'." -ForegroundColor Red
    Write-Host "  Current mappings:" -ForegroundColor Yellow
    net use
}

Write-Host ""
Read-Host "Press Enter to exit..."