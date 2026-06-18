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
Write-Host "  Script: 81.Open_a_Port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0081" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Removes Block firewall rules for a port and creates inbound Allow rules for TCP and UDP" -ForegroundColor DarkCyan
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

$port = Read-Host "  Enter the port to open (e.g. 3389)"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    # Remove existing Block rules for this port
    Get-NetFirewallRule | Where-Object {
        $_.Action -eq 'Block' -and (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains $port
    } | Remove-NetFirewallRule

    # Create Allow rules
    New-NetFirewallRule -DisplayName "Allow Port $port (TCP-In)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port -Profile Any -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName "Allow Port $port (UDP-In)" -Direction Inbound -Action Allow -Protocol UDP -LocalPort $port -Profile Any -ErrorAction SilentlyContinue | Out-Null

    Write-Host "  Allow rules created for port $port." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Current firewall rules for port $port :" -ForegroundColor Cyan

    Get-NetFirewallRule | Where-Object {
        (
            Get-NetFirewallPortFilter -AssociatedNetFirewallRule $_ -ErrorAction SilentlyContinue |
            ForEach-Object { $_.LocalPort }
        ) -contains $port
    } | Select-Object DisplayName, Action, Direction, Profile, Enabled | Format-Table -AutoSize

} catch {
    Write-Host "  ERROR: Failed to open port $port." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."