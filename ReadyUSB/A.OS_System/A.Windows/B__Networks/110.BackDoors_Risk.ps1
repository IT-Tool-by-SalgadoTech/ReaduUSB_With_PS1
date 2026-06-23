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
Write-Host "  Script: 110.BackDoors_Risk.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0110" -ForegroundColor Cyan
Write-Host "  Version: 1.2" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Security" -ForegroundColor DarkCyan
Write-Host "  Description: Scans for backdoor indicators including suspicious listening ports, outbound C2 connections, hidden scheduled tasks, suspicious autoruns, non-standard services, and overly permissive firewall rules; exports findings to JSON and CSV on the Desktop" -ForegroundColor DarkCyan
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

Write-Host "  Please wait, scanning the system..." -ForegroundColor Yellow
Write-Host ""

$ErrorActionPreference = 'SilentlyContinue'
$start   = Get-Date
$stamp   = $start.ToString('yyyyMMdd_HHmmss')
$outBase = Join-Path $env:USERPROFILE "Desktop\Backdoor_Sweep_$stamp"
$report  = New-Object System.Collections.Generic.List[object]

function Add-Finding {
    param([string]$Type, [string]$Detail, [int]$Risk, [string]$Source)
    $report.Add([pscustomobject]@{
        Time   = Get-Date
        Type   = $Type
        Detail = $Detail
        Risk   = $Risk
        Source = $Source
    })
}

function Test-PrivateIP {
    param([string]$IP)
    try {
        $addr = [System.Net.IPAddress]::Parse($IP)
        if ($addr.AddressFamily -eq 'InterNetwork') {
            $b = $addr.GetAddressBytes()
            return (
                ($b[0] -eq 10) -or
                ($b[0] -eq 172 -and $b[1] -ge 16 -and $b[1] -le 31) -or
                ($b[0] -eq 192 -and $b[1] -eq 168) -or
                ($b[0] -eq 100 -and $b[1] -ge 64 -and $b[1] -le 127) -or
                ($b[0] -eq 127)
            )
        } else {
            return ($IP -like 'fe80::*' -or $IP -eq '::1')
        }
    } catch { return $true }
}

# --- Network context ---
Write-Host "  [1/6] Checking network context and ARP table..." -ForegroundColor DarkCyan
$ipcfg       = Get-NetIPConfiguration
$defaultRoute = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric, InterfaceMetric | Select-Object -First 1
$gw          = $defaultRoute.NextHop
$ifname      = $defaultRoute.InterfaceAlias
$nn          = Get-NetNeighbor -ErrorAction SilentlyContinue

if (-not $nn) {
    $nn = (arp -a) -replace '\s{2,}', ',' |
          ConvertFrom-Csv -Header 'If','IP','MAC','Type' -ErrorAction SilentlyContinue
}

# --- ARP spoofing check ---
if ($gw) {
    $gwEntries  = $nn | Where-Object { $_.IPAddress -eq $gw -or $_.IP -eq $gw }
    $uniqueMacs = ($gwEntries | ForEach-Object { $_.LinkLayerAddress, $_.MAC } |
                   Where-Object { $_ } | Select-Object -Unique)
    if ($uniqueMacs.Count -gt 1) {
        Add-Finding -Type 'ARP/Gateway' `
            -Detail "Multiple MACs for gateway $gw ($($uniqueMacs -join ', ')) - possible ARP spoofing" `
            -Risk 10 -Source $ifname
    }
}

# --- Suspicious listening ports ---
Write-Host "  [2/6] Scanning listening ports..." -ForegroundColor DarkCyan
$commonOK  = 53,67,68,80,135,137,138,139,443,445,502,593,902,912,1433,3306,3389,5985,5986
$procIndex = @{}
Get-Process | ForEach-Object { $procIndex[$_.Id] = $_ }

Get-NetTCPConnection -State Listen | Sort-Object LocalPort -Unique | ForEach-Object {
    $p    = $procIndex[$_.OwningProcess]
    $exe  = $null
    $name = $null
    if ($p) {
        $name = $p.ProcessName
        try { $exe = $p.Path } catch {}
    }
    $isWeirdPath    = $exe -and ($exe -match '\\Users\\|\\AppData\\|\\Temp\\|\\ProgramData\\[^\\]+\\(?!Microsoft)')
    $isUncommonPort = ($commonOK -notcontains $_.LocalPort)
    $isWideBind     = ($_.LocalAddress -eq '0.0.0.0' -or $_.LocalAddress -eq '::')

    if ($isUncommonPort -and ($isWeirdPath -or $isWideBind)) {
        Add-Finding -Type 'ListeningPort' `
            -Detail "[$name] listening on $($_.LocalAddress):$($_.LocalPort) exe='$exe'" `
            -Risk 7 -Source 'TCP'
    }
}

# --- Outbound C2 connections ---
Write-Host "  [3/6] Checking outbound connections..." -ForegroundColor DarkCyan
$badPorts = 4444,1337,6667,8080,9001,9002,9050,1080,22,2222,3389

Get-NetTCPConnection -State Established | ForEach-Object {
    if ($_.RemoteAddress -and -not (Test-PrivateIP $_.RemoteAddress) -and ($badPorts -contains $_.RemotePort)) {
        $p    = $procIndex[$_.OwningProcess]
        $exe  = $null
        $name = $null
        if ($p) {
            $name = $p.ProcessName
            try { $exe = $p.Path } catch {}
        }
        Add-Finding -Type 'OutboundC2' `
            -Detail "[$name] -> $($_.RemoteAddress):$($_.RemotePort) (non-RFC1918)" `
            -Risk 8 -Source 'TCP'
    }
}

# --- Hidden scheduled tasks ---
Write-Host "  [4/6] Scanning scheduled tasks and autoruns..." -ForegroundColor DarkCyan
try {
    Get-ScheduledTask | Where-Object { $_.Settings.Hidden } | ForEach-Object {
        Add-Finding -Type 'ScheduledTaskHidden' `
            -Detail "$($_.TaskName) ($($_.TaskPath))" `
            -Risk 6 -Source 'Task'
    }
} catch {}

# --- Suspicious autoruns ---
$runKeys = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce'
)

foreach ($rk in $runKeys) {
    try {
        $vals = Get-ItemProperty -Path $rk
        $vals.PSObject.Properties |
            Where-Object { $_.Name -notin 'PSPath','PSParentPath','PSChildName','PSDrive','PSProvider' } |
            ForEach-Object {
                $cmd = [string]$_.Value
                if ($cmd -match '\\Users\\|\\AppData\\|\\Temp\\|\.vbs$|\.js$|\.ps1$|\.bat$|\.hta$') {
                    Add-Finding -Type 'Autorun' `
                        -Detail "$rk -> $($_.Name) = $cmd" `
                        -Risk 7 -Source 'Registry'
                }
            }
    } catch {}
}

# --- Non-standard auto-start services ---
Write-Host "  [5/6] Checking auto-start services..." -ForegroundColor DarkCyan
try {
    Get-CimInstance Win32_Service |
        Where-Object { $_.StartMode -eq 'Auto' -and $_.State -eq 'Running' } |
        ForEach-Object {
            $path = $_.PathName
            if ($path -and ($path -notmatch '\\Windows\\System32\\|\\Program Files\\')) {
                Add-Finding -Type 'Service' `
                    -Detail "Service '$($_.Name)' binary: $path" `
                    -Risk 6 -Source 'Service'
            }
        }
} catch {}

# --- Overly permissive inbound firewall rules ---
Write-Host "  [6/6] Analyzing firewall rules..." -ForegroundColor DarkCyan
try {
    Get-NetFirewallRule -Enabled True -Direction Inbound | ForEach-Object {
        $ru = $_
        $p  = Get-NetFirewallPortFilter    -AssociatedNetFirewallRule $ru -ErrorAction SilentlyContinue
        $a  = Get-NetFirewallAddressFilter -AssociatedNetFirewallRule $ru -ErrorAction SilentlyContinue
        $lp = ($p.LocalPort -join ',')
        $ra = if ($a.RemoteAddress) { $a.RemoteAddress -join ',' } else { 'Any' }

        if ($ru.Action -eq 'Allow' -and ($ra -eq 'Any' -or $ra -eq 'Any,Any')) {
            if ([string]::IsNullOrWhiteSpace($lp) -or $lp -match 'Any') {
                Add-Finding -Type 'Firewall' `
                    -Detail "Rule '$($ru.DisplayName)' allows inbound from ANY to ANY" `
                    -Risk 6 -Source 'Firewall'
            }
        }
    }
} catch {}

# --- Export results ---
$report | ConvertTo-Json -Depth 5 | Out-File -Encoding UTF8 "$outBase.json"
$report | Export-Csv -NoTypeInformation -Encoding UTF8 "$outBase.csv"

# --- Summary ---
$summary = $report | Group-Object Type | Select-Object Name, Count

Write-Host ""
Write-Host "  === Network/Host Backdoor Sweep ===" -ForegroundColor Cyan
Write-Host ("  Interface: {0}   Gateway: {1}" -f $ifname, $gw)
Write-Host ("  Total findings: {0}" -f $report.Count)
Write-Host ""

if ($summary) {
    $summary | ForEach-Object {
        Write-Host ("  {0,-24} {1,5}" -f $_.Name, $_.Count)
    }
    Write-Host ""
    Write-Host "  Report saved to: $outBase.json / .csv" -ForegroundColor Green
} else {
    Write-Host "  No suspicious indicators found." -ForegroundColor Green
}

Write-Host ""
Read-Host "Press Enter to exit..."