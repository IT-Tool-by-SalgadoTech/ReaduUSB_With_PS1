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
Write-Host "  Script: 235.Users_List.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0235" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Reports all local users, Administrators group members, and domain or workgroup membership in a single summary" -ForegroundColor DarkCyan
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

Write-Host "  Report generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor DarkCyan
Write-Host ""

# --- Local Users ---
Write-Host "  === Local Users ===" -ForegroundColor Cyan
try {
    $localUsers = Get-LocalUser -ErrorAction Stop |
        Select-Object Name, Enabled, Description, SID
} catch {
    $localUsers = Get-CimInstance Win32_UserAccount -Filter 'LocalAccount=True' |
        Select-Object Name,
            @{Name='Enabled'; Expression={ -not $_.Disabled }},
            Description, SID
}
$localUsers | Format-Table -AutoSize

# --- Administrators Group ---
Write-Host "  === Administrators Group Members ===" -ForegroundColor Cyan
try {
    $admins = Get-LocalGroupMember -Group Administrators -ErrorAction Stop |
        Select-Object @{Name='Name';      Expression={ $_.Name }},
                      @{Name='Type';      Expression={ $_.ObjectClass }},
                      @{Name='SID';       Expression={ $_.SID.Value }}
} catch {
    $group   = [ADSI]"WinNT://$env:COMPUTERNAME/Administrators,group"
    $admins  = @()
    $group.Members() | ForEach-Object {
        $n      = $_.GetType().InvokeMember('Name',  'GetProperty', $null, $_, $null)
        $c      = $_.GetType().InvokeMember('Class', 'GetProperty', $null, $_, $null)
        $sidObj = Get-CimInstance Win32_UserAccount -Filter "Name='$n' AND LocalAccount=True" -ErrorAction SilentlyContinue
        $admins += [PSCustomObject]@{ Name = $n; Type = $c; SID = if ($sidObj) { $sidObj.SID } else { $null } }
    }
}
if ($admins) { $admins | Format-Table -AutoSize } else { Write-Host "  No administrators found." -ForegroundColor Yellow }

# --- Domain / Workgroup ---
Write-Host "  === Domain / Workgroup ===" -ForegroundColor Cyan
$cs = Get-CimInstance Win32_ComputerSystem
if ($cs.PartOfDomain) {
    Write-Host "  Domain    : $($cs.Domain)" -ForegroundColor Cyan
} else {
    Write-Host "  Workgroup : $($cs.Workgroup)" -ForegroundColor Cyan
}

# --- Summary ---
Write-Host ""
Write-Host "  === Summary ===" -ForegroundColor Cyan
Write-Host "  Local users          : $($localUsers.Count)" -ForegroundColor Cyan
Write-Host "  Administrators       : $($admins.Count)" -ForegroundColor Cyan
Write-Host "  Domain joined        : $($cs.PartOfDomain)" -ForegroundColor Cyan

Write-Host ""
Read-Host "Press Enter to exit..."