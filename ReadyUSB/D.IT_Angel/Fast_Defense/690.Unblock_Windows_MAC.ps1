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
Write-Host "  Script: 692.Unblock_Device_By_MAC.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0692" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-26" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Removes IT-Tool firewall blocks created for a device MAC address" -ForegroundColor DarkCyan
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

# List currently blocked MAC devices
$rules = Get-NetFirewallRule -DisplayName "ITTOOL_Block_MAC_*" -ErrorAction SilentlyContinue
if (-not $rules) {
    Write-Host "  No MAC blocks created by IT-Tool were found." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

# Extract distinct MACs from rule names (ITTOOL_Block_MAC_<mac>_<ip>_In/_Out)
$blocked = @{}
foreach ($r in $rules) {
    if ($r.DisplayName -match "^ITTOOL_Block_MAC_([0-9A-Fa-f\-]{17})_") {
        $blocked[$Matches[1].ToUpper()] = $true
    }
}

Write-Host "  Currently blocked devices (by MAC):" -ForegroundColor White
$i = 0
foreach ($b in ($blocked.Keys | Sort-Object)) {
    $i++
    Write-Host ("    [{0}] {1}" -f $i, $b) -ForegroundColor Yellow
}
Write-Host ""

$choice = Read-Host "Enter the MAC to unblock (any format), or type ALL to remove every MAC block"
if ([string]::IsNullOrWhiteSpace($choice)) {
    Write-Host "  No selection made. Nothing changed." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}
$choice = $choice.Trim()

if ($choice -ieq "ALL") {
    try {
        $rules | Remove-NetFirewallRule -ErrorAction Stop
        Write-Host "  SUCCESS: Removed all IT-Tool MAC blocks ($($rules.Count) rule(s))." -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Failed to remove some rules." -ForegroundColor Red
        Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
    }
} else {
    $macHex = ($choice -replace "[^0-9A-Fa-f]", "").ToUpper()
    if ($macHex.Length -ne 12) {
        Write-Host "  ERROR: '$choice' is not a valid MAC address (need 12 hex digits)." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
    $macDash = ($macHex -split "(.{2})" | Where-Object { $_ -ne "" }) -join "-"
    $target = Get-NetFirewallRule -DisplayName ("ITTOOL_Block_MAC_" + $macDash + "_*") -ErrorAction SilentlyContinue
    if (-not $target) {
        Write-Host "  NOTICE: No IT-Tool block found for MAC '$macDash'." -ForegroundColor Yellow
    } else {
        try {
            $target | Remove-NetFirewallRule -ErrorAction Stop
            Write-Host "  SUCCESS: Unblocked MAC '$macDash' ($($target.Count) rule(s) removed)." -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: Failed to remove rules for MAC '$macDash'." -ForegroundColor Red
            Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."