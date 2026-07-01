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
Write-Host "  Script: 671.Block_Device_By_MAC.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0671" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-26" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Resolves a MAC address to its current IP via the ARP/neighbor table and blocks it via Windows Firewall" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# Admin check
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$GROUP = "ITTOOL_FastDefense"

# Get and normalize the MAC
$macInput = Read-Host "Enter the MAC address of the device to block (any format)"
if ([string]::IsNullOrWhiteSpace($macInput)) {
    Write-Host "  ERROR: No MAC address provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# Strip every non-hex char and validate 12 hex digits
$macHex = ($macInput -replace "[^0-9A-Fa-f]", "").ToUpper()
if ($macHex.Length -ne 12) {
    Write-Host "  ERROR: '$macInput' is not a valid MAC address (need 12 hex digits)." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}
# Canonical dashed form for naming, e.g. AA-BB-CC-DD-EE-FF
$macDash = ($macHex -split "(.{2})" | Where-Object { $_ -ne "" }) -join "-"
Write-Host "  Normalized MAC: $macDash" -ForegroundColor White
Write-Host ""

# Resolve MAC -> IP using the neighbor (ARP/ND) table
Write-Host "  Searching the neighbor table for this MAC..." -ForegroundColor Cyan
$ips = @()
try {
    $neighbors = Get-NetNeighbor -ErrorAction Stop | Where-Object {
        $_.LinkLayerAddress -and
        (($_.LinkLayerAddress -replace "[^0-9A-Fa-f]", "").ToUpper() -eq $macHex) -and
        ($_.State -ne "Unreachable" -and $_.State -ne "Incomplete")
    }
    $ips = $neighbors | Select-Object -ExpandProperty IPAddress -Unique
} catch {
    # Fallback below
}

# Fallback: parse 'arp -a' if Get-NetNeighbor found nothing
if (-not $ips -or $ips.Count -eq 0) {
    $macDashLower = $macDash.ToLower()
    $arpLines = (arp -a) 2>$null
    foreach ($line in $arpLines) {
        $norm = ($line -replace "[^0-9A-Fa-f]", "").ToUpper()
        if ($line -match "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})" -and $line.ToLower() -match $macDashLower) {
            $ips += $Matches[1]
        }
    }
    $ips = $ips | Select-Object -Unique
}

if (-not $ips -or $ips.Count -eq 0) {
    Write-Host ""
    Write-Host "  NOTICE: MAC '$macDash' is not currently visible on this network." -ForegroundColor Yellow
    Write-Host "  The device must be online and have communicated recently so it appears" -ForegroundColor Yellow
    Write-Host "  in the ARP/neighbor table. A MAC can only be mapped to an IP while reachable." -ForegroundColor Yellow
    Write-Host "  For a permanent MAC ban regardless of IP, apply it on your router/switch." -ForegroundColor Gray
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

Write-Host ("  Resolved MAC to {0} IP address(es): {1}" -f $ips.Count, ($ips -join ", ")) -ForegroundColor Green
Write-Host ""

# Block each resolved IP (inbound + outbound)
$created = 0
foreach ($ip in $ips) {
    $ruleIn  = "ITTOOL_Block_MAC_" + $macDash + "_" + $ip + "_In"
    $ruleOut = "ITTOOL_Block_MAC_" + $macDash + "_" + $ip + "_Out"

    $exists = Get-NetFirewallRule -DisplayName ("ITTOOL_Block_MAC_" + $macDash + "_" + $ip + "_*") -ErrorAction SilentlyContinue
    if ($exists) {
        Write-Host "    SKIP: '$ip' already blocked for this MAC." -ForegroundColor Yellow
        continue
    }
    try {
        New-NetFirewallRule -DisplayName $ruleIn  -Group $GROUP -Direction Inbound  -Action Block -RemoteAddress $ip -Profile Any -Enabled True -ErrorAction Stop | Out-Null
        New-NetFirewallRule -DisplayName $ruleOut -Group $GROUP -Direction Outbound -Action Block -RemoteAddress $ip -Profile Any -Enabled True -ErrorAction Stop | Out-Null
        Write-Host "    BLOCKED: $ip (inbound + outbound)" -ForegroundColor Green
        $created++
    } catch {
        Write-Host "    ERROR blocking $ip : $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
if ($created -gt 0) {
    Write-Host "  SUCCESS: Device '$macDash' blocked on $created IP address(es)." -ForegroundColor Green
}
Write-Host "  Tip: if the device uses DHCP its IP may change. Re-run this script if it" -ForegroundColor Gray
Write-Host "  reconnects with a new IP, or enforce the MAC ban on your router/switch." -ForegroundColor Gray

Write-Host ""
Read-Host "Press Enter to exit..."