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
Write-Host "  Script: 218.Firewall_rule_list_with_Ports_2minuntes_wait.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0218" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all Windows Firewall rules with direction, action, enabled state, profile, and local port (may take up to 2 minutes)" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
Write-Host "  INFO: Enumerating all firewall rules with port filters. This may take up to 2 minutes..." -ForegroundColor Yellow

try {
    $results = Get-NetFirewallRule | ForEach-Object {
        $rule       = $_
        $portFilter = Get-NetFirewallPortFilter -AssociatedNetFirewallRule $rule -ErrorAction SilentlyContinue
        [pscustomobject]@{
            DisplayName = $rule.DisplayName
            Direction   = $rule.Direction
            Action      = $rule.Action
            Enabled     = $rule.Enabled
            Profile     = $rule.Profile
            LocalPort   = ($portFilter.LocalPort -join ',')
        }
    }

    if ($results) {
        Write-Host "  SUCCESS: Firewall rules retrieved." -ForegroundColor Green
        Write-Host ""
        $results | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No firewall rules found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve firewall rules. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."