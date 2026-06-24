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
Write-Host "  Script: 88.Check_if_a_port_has_a_rule.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0088" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all enabled Windows Firewall rules that reference a specified port as local or remote" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$port = Read-Host "  Enter the port to check (e.g. 3389)"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    $results = Get-NetFirewallRule -Enabled True | ForEach-Object {
        $r  = $_
        $pf = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $r -ErrorAction SilentlyContinue
        if ($pf) {
            $lp = ($pf.LocalPort  -join ',')
            $rp = ($pf.RemotePort -join ',')
            if ($lp -match "(^|,)$port($|,)" -or $rp -match "(^|,)$port($|,)") {
                [pscustomobject]@{
                    Name        = $r.DisplayName
                    Action      = $r.Action
                    Direction   = $r.Direction
                    Profile     = $r.Profile
                    Protocol    = ($pf.Protocol -join ',')
                    LocalPort   = $lp
                    RemotePort  = $rp
                }
            }
        }
    }

    if ($results) {
        $results | Format-Table -AutoSize
        Write-Host "  Firewall rules found for port $port." -ForegroundColor Green
    } else {
        Write-Host "  No enabled firewall rules found for port $port." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to query firewall rules." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."