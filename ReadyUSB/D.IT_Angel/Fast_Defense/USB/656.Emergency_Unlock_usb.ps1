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
Write-Host "  IT-Tool by ITTOOL" -ForegroundColor Cyan
Write-Host "  Script: Emergency_Unlock_usb.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0656" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-23" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Master USB recovery. Reverses every USB lock mechanism" -ForegroundColor DarkCyan
Write-Host "  used by the IT-Tool USB scripts (storage policy, install restrictions," -ForegroundColor DarkCyan
Write-Host "  driver Start values, disabled devices) in a single pass." -ForegroundColor DarkCyan
Write-Host "  (c) 2026 ITTOOL - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Admin check ───────────────────────────────────────────────────────────────
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# ── Direct recovery (proven raw commands, run first) ──────────────────────────
Write-Host "  Running direct recovery commands..." -ForegroundColor Cyan
Remove-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices' -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions' -Recurse -Force -ErrorAction SilentlyContinue
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR' -Name Start -Value 3 -Type DWord
Set-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\UASPStor' -Name Start -Value 3 -Type DWord -ErrorAction SilentlyContinue
gpupdate /force
pnputil /scan-devices
Write-Host "  [OK] Direct recovery commands executed." -ForegroundColor Green
Write-Host ""

# ── Helper: remove a policy key and report ────────────────────────────────────
function Remove-PolicyKey {
    param([string]$Path, [string]$Label)
    if (Test-Path $Path) {
        try {
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Host "  [OK] Removed: $Label" -ForegroundColor Green
        } catch {
            Write-Host "  [ERR] $Label : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  [--] Not present: $Label" -ForegroundColor DarkGray
    }
}

Write-Host "  Reverting all USB lock mechanisms..." -ForegroundColor Cyan
Write-Host ""

# ── 1) Removable Storage Access policy (cause of 'Access is denied') ──────────
Write-Host "  [1] Removable storage access policy" -ForegroundColor White
Remove-PolicyKey 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices' 'HKLM RemovableStorageDevices'
Remove-PolicyKey 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\RemovableStorageDevices' 'HKCU RemovableStorageDevices'

# ── 2) Device installation restrictions (DenyUnspecified / DenyNewUSBDevices /
#       DenyDeviceIDs / DenyDeviceClasses / DenyRemovableDevices) ──────────────
Write-Host "  [2] Device installation restrictions" -ForegroundColor White
Remove-PolicyKey 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions' 'DeviceInstall\Restrictions'

# ── 3) Re-enable storage drivers ──────────────────────────────────────────────
Write-Host "  [3] Storage drivers" -ForegroundColor White
foreach ($svc in @('USBSTOR', 'UASPStor')) {
    $p = "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
    if (Test-Path $p) {
        try {
            Set-ItemProperty -Path $p -Name 'Start' -Value 3 -Type DWord -ErrorAction Stop
            Write-Host "  [OK] $svc Start = 3 (enabled)." -ForegroundColor Green
        } catch {
            Write-Host "  [ERR] $svc : $_" -ForegroundColor Red
        }
    } else {
        Write-Host "  [--] Service not present: $svc" -ForegroundColor DarkGray
    }
}

# ── 4) Re-enable any disabled USB devices ─────────────────────────────────────
Write-Host "  [4] Disabled USB devices" -ForegroundColor White
$fixed = 0
Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object {
    ($_.InstanceId -like 'USB\*' -or $_.InstanceId -like 'USBSTOR\*') -and ($_.Status -ne 'OK')
} | ForEach-Object {
    try {
        Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false -ErrorAction Stop
        $fixed++
    } catch {
        # Continue with the remaining devices.
    }
}
Write-Host "  [OK] Re-enabled $fixed USB device(s)." -ForegroundColor Green

# ── 5) Apply policy changes and rescan hardware ───────────────────────────────
Write-Host "  [5] Applying changes" -ForegroundColor White
try { & gpupdate /force | Out-Null;     Write-Host "  [OK] Group policy refreshed." -ForegroundColor Green } catch { Write-Host "  [ERR] gpupdate: $_" -ForegroundColor Red }
try { & pnputil /scan-devices | Out-Null; Write-Host "  [OK] Hardware rescan triggered." -ForegroundColor Green } catch { Write-Host "  [ERR] rescan: $_" -ForegroundColor Red }

# ── 6) Archive any lock state file ────────────────────────────────────────────
$stateFile = 'C:\ProgramData\ITTOOL\usb_lock_state.json'
if (Test-Path $stateFile) {
    $bak = 'C:\ProgramData\ITTOOL\usb_lock_state_' + (Get-Date -Format 'yyyyMMdd_HHmmss') + '.bak.json'
    Move-Item -Path $stateFile -Destination $bak -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host "  USB ACCESS RESTORED." -ForegroundColor Green
Write-Host "  Unplug and reconnect your USB device. If it still shows" -ForegroundColor Green
Write-Host "  'Access denied', reboot once to fully release the policy." -ForegroundColor Green
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
Read-Host "Press Enter to exit..."