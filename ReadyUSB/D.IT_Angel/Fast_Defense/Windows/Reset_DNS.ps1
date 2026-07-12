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
Write-Host "  Script: Reset_DNS_KnownGood.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Resets DNS to automatic (DHCP) on all active adapters and flushes the DNS cache. Optional trusted-resolver block included" -ForegroundColor DarkCyan
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

# To pin a trusted resolver instead of automatic, comment the reset block
# below and set $useTrusted = $true with the desired addresses.
$useTrusted = $false
$trustedDns = @("1.1.1.1","1.0.0.1")

$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
if (-not $adapters) {
    Write-Host "  No active network adapters found." -ForegroundColor Red
} else {
    foreach ($a in $adapters) {
        try {
            if ($useTrusted) {
                Set-DnsClientServerAddress -InterfaceIndex $a.ifIndex -ServerAddresses $trustedDns -ErrorAction Stop
                Write-Host ("  DNS set to trusted resolver on: {0}" -f $a.Name) -ForegroundColor Green
            } else {
                Set-DnsClientServerAddress -InterfaceIndex $a.ifIndex -ResetServerAddresses -ErrorAction Stop
                Write-Host ("  DNS reset to automatic on: {0}" -f $a.Name) -ForegroundColor Green
            }
        } catch {
            Write-Host ("  ERROR on {0}: {1}" -f $a.Name, $_.Exception.Message) -ForegroundColor Red
        }
    }

    try {
        Clear-DnsClientCache
        Write-Host "  DNS client cache flushed." -ForegroundColor Green
    } catch {
        Write-Host "  WARNING: Could not flush DNS cache." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "  Current DNS servers per active adapter:" -ForegroundColor White
    foreach ($a in $adapters) {
        $dns = (Get-DnsClientServerAddress -InterfaceIndex $a.ifIndex -AddressFamily IPv4).ServerAddresses -join ", "
        if (-not $dns) { $dns = "(automatic / DHCP)" }
        Write-Host ("    {0,-22} : {1}" -f $a.Name, $dns) -ForegroundColor Cyan
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."