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
Write-Host "  Script: 713.Restore_Service_Key.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0713" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Restores the WudfSvc service registry key and its parameters to default values" -ForegroundColor DarkCyan
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
    Write-Host "  Restoring WudfSvc registry key..." -ForegroundColor Cyan

    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v DisplayName    /t REG_EXPAND_SZ /d "@%SystemRoot%\system32\wudfsvc.dll,-200"                          /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v ErrorControl   /t REG_DWORD     /d 1                                                                   /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v ImagePath      /t REG_EXPAND_SZ /d "%SystemRoot%\system32\svchost.exe -k LocalSystemNetworkRestricted -p" /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v Start          /t REG_DWORD     /d 2                                                                   /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v Type           /t REG_DWORD     /d 32                                                                  /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v DependOnService /t REG_MULTI_SZ /d "RpcSs"                                                             /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v ServiceSidType /t REG_DWORD     /d 1                                                                   /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v Description    /t REG_EXPAND_SZ /d "@%SystemRoot%\system32\wudfsvc.dll,-201"                          /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc" /v ObjectName     /t REG_SZ        /d "NT AUTHORITY\LocalService"                                         /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc\Parameters" /v ServiceDll  /t REG_EXPAND_SZ /d "%SystemRoot%\system32\wudfsvc.dll" /f | Out-Null
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\WudfSvc\Parameters" /v ServiceMain /t REG_SZ        /d "WudfSvc"                          /f | Out-Null

    Write-Host "  WudfSvc registry key restored successfully." -ForegroundColor Green
    Write-Host "  A system restart is recommended." -ForegroundColor Yellow
} catch {
    Write-Host "  ERROR: Failed to restore WudfSvc registry key." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."