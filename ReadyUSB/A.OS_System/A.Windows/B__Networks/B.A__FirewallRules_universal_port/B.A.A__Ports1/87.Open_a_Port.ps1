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
Write-Host "  Script: 87.Open_a_Port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0087" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Re-enables disabled services associated with a specified port" -ForegroundColor DarkCyan
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

$port = Read-Host "  Enter port to re-enable"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    $tcp = Get-NetTCPConnection -State Listen -LocalPort $port -ErrorAction SilentlyContinue
    $udp = Get-NetUDPEndpoint   -LocalPort $port              -ErrorAction SilentlyContinue

    $procs = @()
    if ($tcp) { $procs += $tcp | Select-Object -ExpandProperty OwningProcess -Unique }
    if ($udp) { $procs += $udp | Select-Object -ExpandProperty OwningProcess -Unique }

    if (-not $procs) {
        # No active listener — try to re-enable any disabled service that may own the port
        $svcs = Get-CimInstance Win32_Service -Filter "StartMode='Disabled'" -ErrorAction SilentlyContinue
        foreach ($svc in $svcs) {
            sc.exe config $svc.Name start= auto | Out-Null
            Start-Service -Name $svc.Name -ErrorAction SilentlyContinue
            Write-Host "  Enabled and started service '$($svc.Name)'." -ForegroundColor Green
        }
    } else {
        foreach ($procId in $procs) {
            $svcs = Get-CimInstance Win32_Service -Filter "ProcessId=$procId" -ErrorAction SilentlyContinue
            if ($svcs) {
                foreach ($svc in $svcs) {
                    sc.exe config $svc.Name start= auto | Out-Null
                    Start-Service -Name $svc.Name -ErrorAction SilentlyContinue
                    Write-Host "  Enabled and started service '$($svc.Name)' (PID $procId)." -ForegroundColor Green
                }
            }
        }
    }
} catch {
    Write-Host "  ERROR: Failed to re-enable service on port $port." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."