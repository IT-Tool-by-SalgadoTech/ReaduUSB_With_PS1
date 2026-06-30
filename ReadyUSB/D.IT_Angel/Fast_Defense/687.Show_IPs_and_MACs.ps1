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
Write-Host "  Script: 687.Show_Active_Blocks.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0687" -ForegroundColor Cyan
Write-Host "  Version: 1.2" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-26" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Sweeps the local subnet to list every active device MAC, shows local interface MACs, and all IP/MAC addresses blocked by IT-Tool" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# Read-only: listing firewall rules, adapters and neighbors does not require admin.

# ----------------------------------------------------------------------------
# Collect IP blocks  (ITTOOL_Block_IP_<ip>_In / _Out)
# ----------------------------------------------------------------------------
$ipRules = Get-NetFirewallRule -DisplayName "ITTOOL_Block_IP_*" -ErrorAction SilentlyContinue
$ipMap = @{}
foreach ($r in $ipRules) {
    if ($r.DisplayName -match "^ITTOOL_Block_IP_(.+)_(In|Out)$") {
        $ip  = $Matches[1]
        $dir = $Matches[2]
        if (-not $ipMap.ContainsKey($ip)) {
            $ipMap[$ip] = [ordered]@{ In = $false; Out = $false; EnIn = $true; EnOut = $true }
        }
        if ($dir -eq "In")  { $ipMap[$ip].In  = $true; $ipMap[$ip].EnIn  = [bool]$r.Enabled }
        if ($dir -eq "Out") { $ipMap[$ip].Out = $true; $ipMap[$ip].EnOut = [bool]$r.Enabled }
    }
}

# ----------------------------------------------------------------------------
# Collect MAC blocks  (ITTOOL_Block_MAC_<mac>_<ip>_In / _Out)
# ----------------------------------------------------------------------------
$macRules = Get-NetFirewallRule -DisplayName "ITTOOL_Block_MAC_*" -ErrorAction SilentlyContinue
$macMap = @{}
foreach ($r in $macRules) {
    if ($r.DisplayName -match "^ITTOOL_Block_MAC_([0-9A-Fa-f\-]{17})_(.+)_(In|Out)$") {
        $mac = $Matches[1].ToUpper()
        $ip  = $Matches[2]
        $dir = $Matches[3]
        $key = $mac + "|" + $ip
        if (-not $macMap.ContainsKey($key)) {
            $macMap[$key] = [ordered]@{ Mac = $mac; Ip = $ip; In = $false; Out = $false; EnIn = $true; EnOut = $true }
        }
        if ($dir -eq "In")  { $macMap[$key].In  = $true; $macMap[$key].EnIn  = [bool]$r.Enabled }
        if ($dir -eq "Out") { $macMap[$key].Out = $true; $macMap[$key].EnOut = [bool]$r.Enabled }
    }
}

# Build quick lookup sets of what is currently blocked (for cross-marking)
$blockedIPs  = @{}
foreach ($ip in $ipMap.Keys)  { $blockedIPs[$ip] = $true }
$blockedMACs = @{}
foreach ($k in $macMap.Keys) {
    $blockedMACs[$macMap[$k].Mac] = $true
    $blockedIPs[$macMap[$k].Ip]   = $true
}

function Get-StateLabel($hasIn, $hasOut, $enIn, $enOut) {
    $allEnabled = $true
    if ($hasIn  -and -not $enIn)  { $allEnabled = $false }
    if ($hasOut -and -not $enOut) { $allEnabled = $false }
    if ($allEnabled) { return "ACTIVE" } else { return "DISABLED" }
}

# Normalize any MAC string to canonical AA-BB-CC-DD-EE-FF (or "" if invalid)
function Format-Mac($raw) {
    $hex = ($raw -replace "[^0-9A-Fa-f]", "").ToUpper()
    if ($hex.Length -ne 12) { return "" }
    return ($hex -split "(.{2})" | Where-Object { $_ -ne "" }) -join "-"
}

# ----------------------------------------------------------------------------
# Active discovery: sweep local IPv4 subnet(s) so ALL live devices populate ARP
# ----------------------------------------------------------------------------
Write-Host "  Scanning the local network to discover all active devices..." -ForegroundColor Cyan

$bases = @{}
$ipcfg = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object {
    $_.IPAddress -and
    ($_.IPAddress -notlike "127.*") -and
    ($_.IPAddress -notlike "169.254.*")
}
foreach ($a in $ipcfg) {
    $parts = ([string]$a.IPAddress).Split(".")
    if ($parts.Count -eq 4) {
        $bases[("{0}.{1}.{2}." -f $parts[0], $parts[1], $parts[2])] = $true
    }
}

if ($bases.Count -gt 0) {
    $targets = New-Object System.Collections.Generic.List[string]
    foreach ($b in $bases.Keys) {
        for ($i = 1; $i -le 254; $i++) { $targets.Add($b + $i) }
    }
    $pings = New-Object System.Collections.Generic.List[object]
    $tasks = New-Object System.Collections.Generic.List[object]
    foreach ($t in $targets) {
        try {
            $p = New-Object System.Net.NetworkInformation.Ping
            $pings.Add($p)
            $tasks.Add($p.SendPingAsync($t, 350))
        } catch { }
    }
    try {
        [System.Threading.Tasks.Task]::WaitAll([System.Threading.Tasks.Task[]]$tasks.ToArray(), 8000) | Out-Null
    } catch { }
    foreach ($p in $pings) { try { $p.Dispose() } catch { } }
}
Start-Sleep -Milliseconds 300
Write-Host ""

# ----------------------------------------------------------------------------
# Render: ACTIVE network devices (IP + MAC from the populated neighbor table)
# ----------------------------------------------------------------------------
Write-Host "  =================== ACTIVE NETWORK DEVICES ===================" -ForegroundColor Cyan
Write-Host ""

$neighbors = Get-NetNeighbor -ErrorAction SilentlyContinue | Where-Object {
    $_.LinkLayerAddress -and
    (($_.LinkLayerAddress -replace "[^0-9A-Fa-f]", "").Length -eq 12) -and
    ($_.State -in @("Reachable", "Stale", "Delay", "Probe", "Permanent"))
}

$seen = @{}
$devices = @()
foreach ($n in $neighbors) {
    $dash = Format-Mac $n.LinkLayerAddress
    if ($dash -eq "") { continue }
    $hex = $dash -replace "-", ""
    if ($hex -eq "FFFFFFFFFFFF") { continue }
    if ($dash.StartsWith("01-00-5E")) { continue }
    if ($dash.StartsWith("33-33"))    { continue }
    $ipAddr = [string]$n.IPAddress
    if ($ipAddr -eq "0.0.0.0") { continue }
    $key = $ipAddr + "|" + $dash
    if ($seen.ContainsKey($key)) { continue }
    $seen[$key] = $true
    $devices += [ordered]@{ Ip = $ipAddr; Mac = $dash; State = [string]$n.State }
}

if ($devices.Count -eq 0) {
    Write-Host "    (no active devices found)" -ForegroundColor Gray
} else {
    Write-Host ("    {0,-20} {1,-20} {2,-12} {3}" -f "MAC", "IP ADDRESS", "STATE", "BLOCKED") -ForegroundColor White
    Write-Host ("    {0}" -f ("-" * 70)) -ForegroundColor DarkGray
    foreach ($d in ($devices | Sort-Object { $_.Mac })) {
        $isBlocked = ($blockedMACs.ContainsKey($d.Mac)) -or ($blockedIPs.ContainsKey($d.Ip))
        Write-Host ("    {0,-20} {1,-20} {2,-12} " -f $d.Mac, $d.Ip, $d.State) -ForegroundColor Yellow -NoNewline
        if ($isBlocked) { Write-Host "BLOCKED" -ForegroundColor Red }
        else            { Write-Host "no" -ForegroundColor Green }
    }
    Write-Host ""
    Write-Host ("    Active device MACs found: {0}" -f $devices.Count) -ForegroundColor White
}
Write-Host ""

# ----------------------------------------------------------------------------
# Render: LOCAL interface MACs (this machine's own adapters)
# ----------------------------------------------------------------------------
Write-Host "  ================= LOCAL INTERFACES (this PC) =================" -ForegroundColor Cyan
Write-Host ""
$adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.MacAddress }
if (-not $adapters) {
    Write-Host "    (no local adapters with a MAC found)" -ForegroundColor Gray
} else {
    Write-Host ("    {0,-20} {1,-26} {2}" -f "MAC", "INTERFACE", "STATUS") -ForegroundColor White
    Write-Host ("    {0}" -f ("-" * 64)) -ForegroundColor DarkGray
    foreach ($ad in ($adapters | Sort-Object Name)) {
        $mac = Format-Mac $ad.MacAddress
        if ($mac -eq "") { $mac = [string]$ad.MacAddress }
        $name = ([string]$ad.Name)
        if ($name.Length -gt 24) { $name = $name.Substring(0, 24) }
        Write-Host ("    {0,-20} {1,-26} {2}" -f $mac, $name, [string]$ad.Status) -ForegroundColor Gray
    }
}
Write-Host ""
Write-Host "  Note: devices that never use IP (pure layer-2) cannot be listed by Windows." -ForegroundColor DarkGray
Write-Host "  For a full hardware MAC table of the whole network, query your switch/router." -ForegroundColor DarkGray
Write-Host ""

# ----------------------------------------------------------------------------
# Render: BLOCKED IP addresses
# ----------------------------------------------------------------------------
Write-Host "  ===================== BLOCKED IP ADDRESSES =====================" -ForegroundColor Cyan
Write-Host ""
if ($ipMap.Count -eq 0) {
    Write-Host "    (none)" -ForegroundColor Gray
} else {
    Write-Host ("    {0,-40} {1,-4} {2,-4} {3}" -f "IP ADDRESS", "IN", "OUT", "STATE") -ForegroundColor White
    Write-Host ("    {0}" -f ("-" * 60)) -ForegroundColor DarkGray
    foreach ($ip in ($ipMap.Keys | Sort-Object)) {
        $e = $ipMap[$ip]
        $inS  = if ($e.In)  { "yes" } else { "no" }
        $outS = if ($e.Out) { "yes" } else { "no" }
        $state = Get-StateLabel $e.In $e.Out $e.EnIn $e.EnOut
        $col = if ($state -eq "ACTIVE") { "Green" } else { "Yellow" }
        Write-Host ("    {0,-40} {1,-4} {2,-4} " -f $ip, $inS, $outS) -ForegroundColor Yellow -NoNewline
        Write-Host $state -ForegroundColor $col
    }
}
Write-Host ""
Write-Host ("    Total blocked IPs: {0}" -f $ipMap.Count) -ForegroundColor White
Write-Host ""

# ----------------------------------------------------------------------------
# Render: BLOCKED MAC devices
# ----------------------------------------------------------------------------
Write-Host "  ==================== BLOCKED MAC DEVICES =====================" -ForegroundColor Cyan
Write-Host ""
if ($macMap.Count -eq 0) {
    Write-Host "    (none)" -ForegroundColor Gray
} else {
    Write-Host ("    {0,-20} {1,-22} {2,-4} {3,-4} {4}" -f "MAC ADDRESS", "RESOLVED IP", "IN", "OUT", "STATE") -ForegroundColor White
    Write-Host ("    {0}" -f ("-" * 64)) -ForegroundColor DarkGray
    $macKeys = $macMap.Keys | Sort-Object { $macMap[$_].Mac }, { $macMap[$_].Ip }
    $uniqueMacs = @{}
    foreach ($k in $macKeys) {
        $e = $macMap[$k]
        $uniqueMacs[$e.Mac] = $true
        $inS  = if ($e.In)  { "yes" } else { "no" }
        $outS = if ($e.Out) { "yes" } else { "no" }
        $state = Get-StateLabel $e.In $e.Out $e.EnIn $e.EnOut
        $col = if ($state -eq "ACTIVE") { "Green" } else { "Yellow" }
        Write-Host ("    {0,-20} {1,-22} {2,-4} {3,-4} " -f $e.Mac, $e.Ip, $inS, $outS) -ForegroundColor Yellow -NoNewline
        Write-Host $state -ForegroundColor $col
    }
    Write-Host ""
    Write-Host ("    Total blocked devices: {0} MAC(s) over {1} IP entry(ies)" -f $uniqueMacs.Count, $macMap.Count) -ForegroundColor White
}

Write-Host ""
Write-Host "  ==============================================================" -ForegroundColor White
Write-Host "  Red 'BLOCKED' above means that active device is already cut by IT-Tool." -ForegroundColor Gray
Write-Host "  Use 731.Unblock_Suspicious_IP or 719.Unblock_Device_By_MAC to remove blocks." -ForegroundColor Gray
Write-Host ""
Read-Host "Press Enter to exit..."