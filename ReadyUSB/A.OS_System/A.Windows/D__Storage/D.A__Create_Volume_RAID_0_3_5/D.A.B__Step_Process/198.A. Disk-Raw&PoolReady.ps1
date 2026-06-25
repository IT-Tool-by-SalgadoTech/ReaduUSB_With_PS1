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
Write-Host "  Script: 198.A._Disk-Raw_PoolReady.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0198" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Wipes selected disks to RAW and resets them to pool-ready state for use with Storage Spaces" -ForegroundColor DarkCyan
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

$rawInput = Read-Host "Enter disk numbers to PREP (e.g. 0,1,2)"
$diskNums = $rawInput.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

if (-not $diskNums) {
    Write-Host "  ERROR: No valid disk numbers provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

foreach ($n in $diskNums) {
    try {
        Write-Host "  Preparing Disk $n ..." -ForegroundColor Cyan
        Set-Disk -Number $n -IsReadOnly $false -ErrorAction SilentlyContinue
        Set-Disk -Number $n -IsOffline $false -ErrorAction SilentlyContinue
        Clear-Disk -Number $n -RemoveData -RemoveOEM -Confirm:$false -ErrorAction Stop
        Write-Host "  SUCCESS: Disk $n cleared to RAW." -ForegroundColor Green
    } catch {
        Write-Host "  WARNING: Could not fully prep Disk $n : $($_.Exception.Message)" -ForegroundColor Red
    }
}

$physDisks = foreach ($n in $diskNums) { Get-PhysicalDisk | Where-Object { $_.DeviceId -eq $n } }
if ($physDisks) {
    $physDisks | Reset-PhysicalDisk -ErrorAction SilentlyContinue
    $physDisks | Set-PhysicalDisk -Usage AutoSelect -ErrorAction SilentlyContinue
}

Update-HostStorageCache

Write-Host ""
Write-Host "  Selected disks status:" -ForegroundColor Cyan
Get-PhysicalDisk | Where-Object { $diskNums -contains $_.DeviceId } |
    Select-Object DeviceId, FriendlyName, CanPool, Usage, Size, BusType, OperationalStatus |
    Format-Table -AutoSize

Write-Host ""
Read-Host "Press Enter to exit..."