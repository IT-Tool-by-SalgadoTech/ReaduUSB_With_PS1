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
Write-Host "  Script: 88.Close_a_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0088" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Removes existing Allow rules for a port and creates inbound Block rules for TCP, UDP, and Any protocol" -ForegroundColor DarkCyan
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

$port = Read-Host "  Enter port to block (e.g. 3389)"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    # Remove existing Allow rules for this port
    Get-NetFirewallRule | Where-Object {
        $_.Action -eq 'Allow' -and (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains $port
    } | Remove-NetFirewallRule -ErrorAction SilentlyContinue

    # Remove any existing Block rules for this port to avoid duplicates
    Get-NetFirewallRule -DisplayName "Block Port $port*" -ErrorAction SilentlyContinue |
        Remove-NetFirewallRule -ErrorAction SilentlyContinue

    # Create Block rules
    New-NetFirewallRule -DisplayName "Block Port $port (TCP-In)"  -Direction Inbound -Action Block -Protocol TCP -LocalPort $port -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Block Port $port (UDP-In)"  -Direction Inbound -Action Block -Protocol UDP -LocalPort $port -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Block Port $port (All-In)"  -Direction Inbound -Action Block -Protocol Any -LocalPort $port -Profile Any -Enabled True -ErrorAction SilentlyContinue | Out-Null

    Write-Host "  Block rules created for port $port." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Current firewall rules for port $port :" -ForegroundColor Cyan

    Get-NetFirewallRule | Where-Object {
        (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains $port
    } | Select-Object DisplayName, Action, Direction, Profile, Enabled | Format-Table -AutoSize

} catch {
    Write-Host "  ERROR: Failed to block port $port." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."