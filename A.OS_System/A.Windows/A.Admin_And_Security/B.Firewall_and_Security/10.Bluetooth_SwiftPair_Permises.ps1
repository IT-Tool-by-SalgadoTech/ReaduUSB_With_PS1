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
Write-Host "  Script: 10.Bluetooth_SwiftPair_Permises.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0010" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Disables Bluetooth Swift Pair and resets Bluetooth services" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

reg add "HKCU\Software\Microsoft\Bluetooth\BluetoothSettings" /v EnableSwiftPair /t REG_DWORD /d 0 /f; Stop-Service bthserv -Force -ErrorAction SilentlyContinue; Stop-Service DeviceAssociationService -Force -ErrorAction SilentlyContinue; Stop-Service DeviceInstall -Force -ErrorAction SilentlyContinue; Stop-Service hidserv -Force -ErrorAction SilentlyContinue; Get-Service "BluetoothUserService*" -ErrorAction SilentlyContinue | Stop-Service -Force; Start-Sleep -Milliseconds 800; Start-Service DeviceInstall; Start-Service DeviceAssociationService; Start-Service hidserv; Start-Service bthserv; Get-NetAdapter -Name "*Bluetooth*" -ErrorAction SilentlyContinue | Disable-NetAdapter -Confirm:$false; Start-Sleep -Milliseconds 800; Get-NetAdapter -Name "*Bluetooth*" -ErrorAction SilentlyContinue | Enable-NetAdapter -Confirm:$false
Read-Host "Presiona Enter para salir..."