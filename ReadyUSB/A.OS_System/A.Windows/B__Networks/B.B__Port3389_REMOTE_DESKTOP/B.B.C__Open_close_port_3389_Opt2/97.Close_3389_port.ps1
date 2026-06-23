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
Write-Host "  Script: 97.Close_3389_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0097" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Remote Desktop" -ForegroundColor DarkCyan
Write-Host "  Description: Fully blocks RDP by setting the registry key, disabling firewall Allow rules, creating Block rules for port 3389, and stopping the TermService" -ForegroundColor DarkCyan
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
    # --- Registry: deny RDP connections ---
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f | Out-Null
    Write-Host "  Registry: fDenyTSConnections set to 1." -ForegroundColor Green

    # --- Firewall: disable Remote Desktop group rules ---
    Disable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
    Write-Host "  Firewall: Remote Desktop group rules disabled." -ForegroundColor Green

    # --- Firewall: remove existing Allow rules for port 3389 ---
    Get-NetFirewallRule | Where-Object {
        $_.Action -eq 'Allow' -and (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains 3389
    } | Remove-NetFirewallRule -ErrorAction SilentlyContinue
    Write-Host "  Firewall: Allow rules for port 3389 removed." -ForegroundColor Green

    # --- Firewall: remove stale Block rules to avoid duplicates ---
    Get-NetFirewallRule -DisplayName "Block Port 3389*" -ErrorAction SilentlyContinue |
        Remove-NetFirewallRule -ErrorAction SilentlyContinue

    # --- Firewall: create Block rules ---
    New-NetFirewallRule -DisplayName "Block Port 3389 (TCP-In)" -Direction Inbound -Action Block -Protocol TCP -LocalPort 3389 -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Block Port 3389 (UDP-In)" -Direction Inbound -Action Block -Protocol UDP -LocalPort 3389 -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Block Port 3389 (All-In)" -Direction Inbound -Action Block -Protocol Any -LocalPort 3389 -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  Firewall: Block rules for port 3389 created." -ForegroundColor Green

    # --- Service: stop TermService ---
    Stop-Service -Name TermService -Force -ErrorAction SilentlyContinue
    Set-Service  -Name TermService -StartupType Manual
    Write-Host "  TermService stopped and set to Manual." -ForegroundColor Green

    Write-Host ""
    Write-Host "  Current firewall rules for port 3389:" -ForegroundColor Cyan
    Get-NetFirewallRule | Where-Object {
        (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains 3389
    } | Select-Object DisplayName, Action, Direction, Profile, Enabled | Format-Table -AutoSize

} catch {
    Write-Host "  ERROR: Failed to fully block RDP." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."