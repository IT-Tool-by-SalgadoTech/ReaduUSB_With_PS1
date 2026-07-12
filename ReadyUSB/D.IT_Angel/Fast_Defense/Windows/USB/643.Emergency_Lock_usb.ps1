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
Write-Host "  Script: 693.Lock_all_usb_except_bt.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0693" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-23" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Emergency usblock. Disables every connected USB device" -ForegroundColor DarkCyan
Write-Host "  and blocks new USB installs, EXCEPT the Bluetooth radio chain, so the" -ForegroundColor DarkCyan
Write-Host "  unlock can be delivered over BLE." -ForegroundColor DarkCyan
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

# ── Configuration ─────────────────────────────────────────────────────────────
$stateDir  = 'C:\ProgramData\ITTOOL'
$stateFile = Join-Path $stateDir 'usb_lock_state.json'

# USB device class codes blocked from NEW installation while locked.
# Hub (09) and Wireless/Bluetooth (E0) are intentionally NOT in this list so the
# USB tree and the Bluetooth radio stay alive for the BLE-delivered unlock.
$denyClasses = @('01','02','03','05','06','07','08','0A','0B','0D','0E','EF','FF')

# ── Scan connected devices once (single fast call) ────────────────────────────
# The Bluetooth radio reaches the system through USB hubs/controllers (class
# 'USB', which we never disable) and is itself class 'Bluetooth'. There is no
# need to walk parent chains: skipping class 'USB' and class 'Bluetooth' keeps
# the entire Bluetooth path alive. This avoids slow per-device property lookups.
Write-Host "  Scanning connected devices..." -ForegroundColor Cyan
$present  = @(Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue)
Write-Host "  [OK] $($present.Count) present device(s) found." -ForegroundColor Green

$btRadios = @($present | Where-Object { $_.Class -eq 'Bluetooth' })
if ($btRadios.Count -gt 0) {
    Write-Host "  [OK] Bluetooth radio detected: $($btRadios.Count) device(s)." -ForegroundColor Green
} else {
    Write-Host "  WARNING: No Bluetooth radio detected on this system." -ForegroundColor Red
    Write-Host "  BLE unlock will NOT be possible. Recovery would then require a PS/2" -ForegroundColor Yellow
    Write-Host "  keyboard, Safe Mode, or offline registry editing." -ForegroundColor Yellow
    Write-Host ""
}

# ── Warning and confirmation (all input happens BEFORE anything is disabled) ───
Write-Host "  ------------------------------------------------------------------" -ForegroundColor White
Write-Host "  EMERGENCY USB USBLOCK" -ForegroundColor Red
Write-Host "  This DISABLES every USB device (keyboard, mouse, storage, network)" -ForegroundColor Yellow
Write-Host "  EXCEPT the Bluetooth radio. Local USB input WILL stop working." -ForegroundColor Yellow
Write-Host ""
Write-Host "  Before continuing, confirm that:" -ForegroundColor White
Write-Host "   - The IT-Tool is ALREADY paired and connected over Bluetooth." -ForegroundColor White
Write-Host "   - You can run the unlock script (318) over BLE afterwards." -ForegroundColor White
Write-Host "  Fallbacks if BLE fails: PS/2 keyboard, Safe Mode, offline registry." -ForegroundColor White
Write-Host "  Recovery state file: $stateFile" -ForegroundColor White
Write-Host "  ------------------------------------------------------------------" -ForegroundColor White
Write-Host ""
$confirm = Read-Host "  Type USBLOCK to proceed"
if ($confirm -ne 'USBLOCK') {
    Write-Host "  Aborted. No changes made." -ForegroundColor Green
    Read-Host "Press Enter to exit..."
    exit 0
}

# ── Enumerate USB targets to disable ──────────────────────────────────────────
# USB-attached function devices (HID, storage, network, etc.). We skip the USB
# hub/controller class and the Bluetooth radio class so the BLE path survives.
$targets = @($present | Where-Object {
    ($_.InstanceId -like 'USB\*' -or $_.InstanceId -like 'USBSTOR\*') -and
    ($_.Class -ne 'USB') -and
    ($_.Class -ne 'Bluetooth')
})

# ── Save recovery state BEFORE making any change ──────────────────────────────
if (-not (Test-Path $stateDir)) { New-Item -Path $stateDir -ItemType Directory -Force | Out-Null }
$state = [ordered]@{
    timestamp           = (Get-Date).ToString('s')
    denyClasses         = $denyClasses
    bluetoothExcluded   = @($btRadios | ForEach-Object { $_.InstanceId })
    plannedTargets      = @($targets | ForEach-Object { $_.InstanceId })
    disabledInstanceIds = @()
}
($state | ConvertTo-Json -Depth 5) | Set-Content -Path $stateFile -Encoding ASCII

# ── Block NEW USB installs by class compatible ID ─────────────────────────────
$restr = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions'
$idKey = "$restr\DenyDeviceIDs"
try {
    if (-not (Test-Path $idKey)) { New-Item -Path $idKey -Force | Out-Null }
    Set-ItemProperty -Path $restr -Name 'DenyDeviceIDs'            -Value 1 -Type DWord -ErrorAction Stop
    Set-ItemProperty -Path $restr -Name 'DenyDeviceIDsRetroactive' -Value 1 -Type DWord -ErrorAction Stop
    $existing = @((Get-Item -Path $idKey).Property)
    $n = 1
    foreach ($c in $denyClasses) {
        while ($existing -contains "$n") { $n++ }
        Set-ItemProperty -Path $idKey -Name "$n" -Value ("USB\Class_" + $c) -Type String -ErrorAction Stop
        $existing += "$n"; $n++
    }
    Write-Host "  [OK] New USB installs blocked for classes: $($denyClasses -join ', ')." -ForegroundColor Green
} catch {
    Write-Host "  [ERR] Install restriction: $_" -ForegroundColor Red
}

# ── Disable currently connected USB devices (immediate effect) ────────────────
Write-Host "  Disabling $($targets.Count) connected USB device(s)..." -ForegroundColor Cyan
$disabledIds = @()
foreach ($d in $targets) {
    try {
        Disable-PnpDevice -InstanceId $d.InstanceId -Confirm:$false -ErrorAction Stop
        $disabledIds += $d.InstanceId
    } catch {
        # Ignore individual failures and continue the usblock.
    }
}
$state.disabledInstanceIds = $disabledIds
($state | ConvertTo-Json -Depth 5) | Set-Content -Path $stateFile -Encoding ASCII
Write-Host "  [OK] Disabled $($disabledIds.Count) USB device(s)." -ForegroundColor Green

Write-Host ""
Write-Host "  USBLOCK ACTIVE. Connect over Bluetooth and run 318.Unlock_all_usb.ps1" -ForegroundColor Green
Write-Host "  to restore USB access." -ForegroundColor Green
Write-Host ""