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
Write-Host "  Script: 228.Firewall_Active_rules.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0228" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all currently enabled Windows Firewall rules with name, direction, action, and profile" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $rules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' } |
        Select-Object DisplayName, Direction, Action, Profile, Description

    if ($rules) {
        Write-Host "  SUCCESS: $($rules.Count) active firewall rule(s) found." -ForegroundColor Green
        Write-Host ""
        $rules | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No active firewall rules found." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve firewall rules. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."