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
Write-Host "  Script: 101.Bluetooth_On.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0101" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Bluetooth" -ForegroundColor DarkCyan
Write-Host "  Description: Enables all disabled Bluetooth PnP devices by class GUID and starts the Bluetooth Support Service" -ForegroundColor DarkCyan
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
    $btClassGuid = '{e0cbf06c-cd8b-4647-bb8a-263b43f0f974}'

    $devices = Get-PnpDevice | Where-Object { $_.ClassGuid -eq $btClassGuid -and $_.Status -ne 'OK' }

    if ($devices) {
        $devices | ForEach-Object {
            Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction SilentlyContinue
            Write-Host "  Enabled Bluetooth device: $($_.FriendlyName)" -ForegroundColor Green
        }
    } else {
        Write-Host "  No disabled Bluetooth devices found." -ForegroundColor Yellow
    }

    Start-Service bthserv -ErrorAction SilentlyContinue
    Write-Host "  Bluetooth Support Service (bthserv) started." -ForegroundColor Green

} catch {
    Write-Host "  ERROR: Failed to enable Bluetooth." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."