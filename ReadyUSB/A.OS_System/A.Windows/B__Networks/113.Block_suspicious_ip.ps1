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
Write-Host "  Script: 113.Block_Suspicious_IP.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0113" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-26" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Blocks all inbound and outbound traffic to a suspicious IP via Windows Firewall" -ForegroundColor DarkCyan
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

# Get and validate the IP
$ipInput = Read-Host "Enter the suspicious IP address to block (IPv4 or IPv6)"
if ([string]::IsNullOrWhiteSpace($ipInput)) {
    Write-Host "  ERROR: No IP address provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$parsed = $null
if (-not [System.Net.IPAddress]::TryParse($ipInput.Trim(), [ref]$parsed)) {
    Write-Host "  ERROR: '$ipInput' is not a valid IP address." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}
$ip = $parsed.ToString()

# Safety advisory (does not block the action, technician decides)
if ($parsed.IsIPv6LinkLocal -or $ip -eq "127.0.0.1" -or $ip -eq "::1" -or $ip -eq "0.0.0.0") {
    Write-Host "  WARNING: '$ip' is a local/loopback address. Blocking it may affect this system." -ForegroundColor Yellow
    $go = Read-Host "  Type YES to continue anyway"
    if ($go -ne "YES") {
        Write-Host "  Cancelled by user." -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 0
    }
    Write-Host ""
}

$ruleIn  = "ITTOOL_Block_IP_" + $ip + "_In"
$ruleOut = "ITTOOL_Block_IP_" + $ip + "_Out"

# If already blocked, report and exit
$existing = Get-NetFirewallRule -DisplayName ("ITTOOL_Block_IP_" + $ip + "_*") -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "  NOTICE: IP '$ip' is already blocked by IT-Tool." -ForegroundColor Yellow
    Write-Host "  Use the Unblock_Suspicious_IP script to remove the block." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

# Create the block rules (inbound + outbound, all profiles)
try {
    New-NetFirewallRule -DisplayName $ruleIn  -Group $GROUP -Direction Inbound  -Action Block -RemoteAddress $ip -Profile Any -Enabled True -ErrorAction Stop | Out-Null
    New-NetFirewallRule -DisplayName $ruleOut -Group $GROUP -Direction Outbound -Action Block -RemoteAddress $ip -Profile Any -Enabled True -ErrorAction Stop | Out-Null
    Write-Host "  SUCCESS: Firewall block applied for '$ip' (inbound + outbound)." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to create firewall rules." -ForegroundColor Red
    Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# Report active connections that already exist to that IP (informational)
Write-Host ""
Write-Host "  Active connections currently open to '$ip':" -ForegroundColor White
$conns = Get-NetTCPConnection -RemoteAddress $ip -ErrorAction SilentlyContinue
if (-not $conns) {
    Write-Host "    (none found)" -ForegroundColor Gray
} else {
    Write-Host ("    {0,-22} {1,-6} {2,-14} {3}" -f "REMOTE", "PID", "STATE", "PROCESS") -ForegroundColor Gray
    foreach ($c in $conns) {
        $procName = "-"
        try { $procName = (Get-Process -Id $c.OwningProcess -ErrorAction Stop).ProcessName } catch { }
        $remote = "{0}:{1}" -f $c.RemoteAddress, $c.RemotePort
        Write-Host ("    {0,-22} {1,-6} {2,-14} {3}" -f $remote, $c.OwningProcess, $c.State, $procName) -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "  Note: the firewall rule blocks new packets immediately. Existing sockets" -ForegroundColor Gray
    Write-Host "  may linger until they time out. Close the listed processes if needed." -ForegroundColor Gray
}

Write-Host ""
Read-Host "Press Enter to exit..."