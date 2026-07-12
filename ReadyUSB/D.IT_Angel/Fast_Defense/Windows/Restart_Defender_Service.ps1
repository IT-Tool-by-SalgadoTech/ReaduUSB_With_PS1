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
Write-Host "  IT-Tool by ITTOOL" -ForegroundColor Cyan
Write-Host "  Script: Restart_Defender_Service.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Ensures the Microsoft Defender service (WinDefend) is running and re-enables real-time protection" -ForegroundColor DarkCyan
Write-Host "  (c) 2026 ITTOOL - All Rights Reserved" -ForegroundColor DarkCyan
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

$svc = Get-Service -Name WinDefend -ErrorAction SilentlyContinue
if ($null -eq $svc) {
    Write-Host "  Microsoft Defender service (WinDefend) was not found on this system." -ForegroundColor Red
} else {
    if ($svc.Status -ne 'Running') {
        try {
            Start-Service -Name WinDefend -ErrorAction Stop
            Write-Host "  WinDefend service started." -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: Could not start WinDefend (may be blocked by Tamper Protection)." -ForegroundColor Red
            Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
        }
    } else {
        Write-Host "  WinDefend service already running." -ForegroundColor Green
    }

    try {
        Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction Stop
        Write-Host "  Real-time protection re-enabled." -ForegroundColor Green
    } catch {
        Write-Host "  WARNING: Could not change real-time monitoring (Tamper Protection may be on)." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "  Current Defender status:" -ForegroundColor White
    try {
        $status = Get-MpComputerStatus -ErrorAction Stop
        Write-Host ("    Antivirus enabled      : {0}" -f $status.AntivirusEnabled) -ForegroundColor Cyan
        Write-Host ("    Real-time protection   : {0}" -f $status.RealTimeProtectionEnabled) -ForegroundColor Cyan
        Write-Host ("    Service running        : {0}" -f ((Get-Service WinDefend).Status -eq 'Running')) -ForegroundColor Cyan
    } catch {
        Write-Host "    Could not query Get-MpComputerStatus." -ForegroundColor Yellow
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."