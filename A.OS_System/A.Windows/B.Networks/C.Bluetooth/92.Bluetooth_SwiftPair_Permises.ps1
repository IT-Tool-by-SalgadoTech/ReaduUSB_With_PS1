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
Write-Host "  Script: 92.Bluetooth_SwiftPair_Permises.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0092" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Bluetooth" -ForegroundColor DarkCyan
Write-Host "  Description: Disables Bluetooth Swift Pair via registry, restarts Bluetooth-related services, and resets the Bluetooth network adapter" -ForegroundColor DarkCyan
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
    # --- Disable Swift Pair via registry ---
    reg add "HKCU\Software\Microsoft\Bluetooth\BluetoothSettings" /v EnableSwiftPair /t REG_DWORD /d 0 /f | Out-Null
    Write-Host "  Swift Pair disabled in registry." -ForegroundColor Green

    # --- Stop Bluetooth-related services ---
    Stop-Service bthserv              -Force -ErrorAction SilentlyContinue
    Stop-Service DeviceAssociationService -Force -ErrorAction SilentlyContinue
    Stop-Service DeviceInstall        -Force -ErrorAction SilentlyContinue
    Stop-Service hidserv              -Force -ErrorAction SilentlyContinue
    Get-Service "BluetoothUserService*" -ErrorAction SilentlyContinue | Stop-Service -Force
    Write-Host "  Bluetooth services stopped." -ForegroundColor Green

    Start-Sleep -Milliseconds 800

    # --- Restart services ---
    Start-Service DeviceInstall
    Start-Service DeviceAssociationService
    Start-Service hidserv
    Start-Service bthserv
    Write-Host "  Bluetooth services restarted." -ForegroundColor Green

    # --- Reset Bluetooth network adapter ---
    $btAdapter = Get-NetAdapter -Name "*Bluetooth*" -ErrorAction SilentlyContinue
    if ($btAdapter) {
        $btAdapter | Disable-NetAdapter -Confirm:$false
        Start-Sleep -Milliseconds 800
        $btAdapter | Enable-NetAdapter -Confirm:$false
        Write-Host "  Bluetooth network adapter reset." -ForegroundColor Green
    } else {
        Write-Host "  No Bluetooth network adapter found to reset." -ForegroundColor Yellow
    }

} catch {
    Write-Host "  ERROR: An error occurred during Bluetooth reset." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."