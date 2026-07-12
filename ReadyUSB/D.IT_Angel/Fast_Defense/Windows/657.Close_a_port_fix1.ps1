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
Write-Host "  Script: 703.Close_a_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0703" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Identifies and kills the process or service listening on a specified TCP/UDP port" -ForegroundColor DarkCyan
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

$port = Read-Host "  Enter port to close"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    $tcp  = Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue
    $udp  = Get-NetUDPEndpoint   -LocalPort $port              -ErrorAction SilentlyContinue

    $procs = @()
    if ($tcp) { $procs += $tcp | Select-Object -ExpandProperty OwningProcess -Unique }
    if ($udp) { $procs += $udp | Select-Object -ExpandProperty OwningProcess -Unique }
    $procs = $procs | Sort-Object -Unique

    if (-not $procs) {
        Write-Host "  No listener found on port $port." -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 0
    }

    foreach ($procId in $procs) {
        $svcs = Get-CimInstance Win32_Service -Filter "ProcessId=$procId" -ErrorAction SilentlyContinue
        if ($svcs) {
            $svcs | ForEach-Object {
                sc.exe config $_.Name start= disabled | Out-Null
                Stop-Service -Name $_.Name -Force -ErrorAction SilentlyContinue
                Write-Host "  Disabled and stopped service '$($_.Name)' (PID $procId)." -ForegroundColor Green
            }
        } else {
            Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
            Write-Host "  Killed process PID $procId." -ForegroundColor Green
        }
    }

    Start-Sleep 1

    $stillOpen = (Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue) -or
                 (Get-NetUDPEndpoint   -LocalPort $port              -ErrorAction SilentlyContinue)

    if ($stillOpen) {
        Write-Host "  WARNING: Port $port is still listening." -ForegroundColor Red
    } else {
        Write-Host "  Port $port is now closed." -ForegroundColor Green
    }
} catch {
    Write-Host "  ERROR: An unexpected error occurred." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."