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
Write-Host "  Script: 106.B.Activate_and_start_SSH.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0106" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > SSH" -ForegroundColor DarkCyan
Write-Host "  Description: Installs OpenSSH Server if not present, sets the sshd service to Automatic startup, and starts it" -ForegroundColor DarkCyan
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

try {
    # --- Install OpenSSH Server if not installed ---
    $cap = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
    if ($cap -and $cap.State -ne 'Installed') {
        Write-Host "  Installing OpenSSH Server capability..." -ForegroundColor Cyan
        Add-WindowsCapability -Online -Name $cap.Name | Out-Null
        Write-Host "  OpenSSH Server installed." -ForegroundColor Green
    } elseif ($cap.State -eq 'Installed') {
        Write-Host "  OpenSSH Server already installed." -ForegroundColor Green
    } else {
        Write-Host "  WARNING: OpenSSH Server capability not found. Continuing with service configuration." -ForegroundColor Yellow
    }

    # --- Configure and start sshd ---
    Set-Service -Name sshd -StartupType Automatic
    Start-Service -Name sshd
    Write-Host "  sshd service set to Automatic and started." -ForegroundColor Green

} catch {
    Write-Host "  ERROR: Failed to activate SSH server." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."