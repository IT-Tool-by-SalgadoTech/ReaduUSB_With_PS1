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
Write-Host "  Script: 89.Open_3389_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0089" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Remote Desktop" -ForegroundColor DarkCyan
Write-Host "  Description: Fully enables RDP by setting registry keys, starting TermService, adding the current user to Remote Desktop Users, enabling firewall Allow rules, and verifying port 3389 connectivity" -ForegroundColor DarkCyan
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
    $username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

    # --- Network profile: set to Private (required for RDP) ---
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
    Write-Host "  Network profile set to Private." -ForegroundColor Green

    # --- Registry: allow RDP connections ---
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f | Out-Null
    Write-Host "  Registry: fDenyTSConnections set to 0." -ForegroundColor Green

    # --- Registry: require NLA ---
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 1 /f | Out-Null
    Write-Host "  Registry: NLA (UserAuthentication) enabled." -ForegroundColor Green

    # --- Service: start TermService ---
    Set-Service  -Name TermService -StartupType Automatic
    Start-Service -Name TermService
    Write-Host "  TermService started and set to Automatic." -ForegroundColor Green

    # --- Add current user to Remote Desktop Users ---
    try {
        net localgroup "Remote Desktop Users" "$username" /add 2>$null | Out-Null
        Write-Host "  User '$username' added to Remote Desktop Users." -ForegroundColor Green
    } catch {}

    # --- Firewall: remove Block rules for port 3389 ---
    Get-NetFirewallRule | Where-Object {
        $_.Action -eq 'Block' -and (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains 3389
    } | Remove-NetFirewallRule -ErrorAction SilentlyContinue
    Write-Host "  Firewall: Block rules for port 3389 removed." -ForegroundColor Green

    # --- Firewall: enable Remote Desktop group rules ---
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
    Write-Host "  Firewall: Remote Desktop group rules enabled." -ForegroundColor Green

    # --- Firewall: create explicit Allow rules ---
    New-NetFirewallRule -DisplayName "Allow Port 3389 (TCP-In)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -Profile Any -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Allow Port 3389 (UDP-In)" -Direction Inbound -Action Allow -Protocol UDP -LocalPort 3389 -Profile Any -ErrorAction SilentlyContinue | Out-Null
    Write-Host "  Firewall: Allow rules for port 3389 created." -ForegroundColor Green

    # --- Verify port 3389 is accessible ---
    Write-Host ""
    Write-Host "  Verifying port 3389 connectivity..." -ForegroundColor Cyan
    $test = Test-NetConnection -ComputerName localhost -Port 3389
    $test | Format-Table -AutoSize

    if ($test.TcpTestSucceeded) {
        Write-Host "  RDP is active and port 3389 is responding." -ForegroundColor Green
    } else {
        Write-Host "  WARNING: Port 3389 is not responding yet. A restart may be required." -ForegroundColor Yellow
    }

} catch {
    Write-Host "  ERROR: Failed to fully enable RDP." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."