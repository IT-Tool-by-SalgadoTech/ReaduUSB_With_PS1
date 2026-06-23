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
Write-Host "  Script: 206.DeleteSimpleAndRAIDVolume.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0206" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Removes all virtual disks and storage pools, then clears specified disks to RAW, including any Storage Spaces volumes" -ForegroundColor DarkCyan
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

$rawInput = Read-Host "Enter disk number(s) to clear to RAW (e.g. 0,1,2)"
$nums     = $rawInput.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

# Remove all virtual disks and storage pools
Get-VirtualDisk -ErrorAction SilentlyContinue | Remove-VirtualDisk -Confirm:$false -ErrorAction SilentlyContinue
Get-StoragePool -ErrorAction SilentlyContinue | Where-Object { -not $_.IsPrimordial } | Remove-StoragePool -Confirm:$false -ErrorAction SilentlyContinue
Update-HostStorageCache

# Clear any remaining Spaces disks
$spaceDisks = Get-Disk -ErrorAction SilentlyContinue | Where-Object { $_.BusType -eq 'Spaces' }
foreach ($d in $spaceDisks) {
    Get-Partition -DiskNumber $d.Number -ErrorAction SilentlyContinue |
        Sort-Object PartitionNumber -Descending |
        ForEach-Object { Remove-Partition -DiskNumber $d.Number -PartitionNumber $_.PartitionNumber -Confirm:$false -ErrorAction SilentlyContinue }
    Set-Disk -Number $d.Number -IsReadOnly $false -ErrorAction SilentlyContinue
    Set-Disk -Number $d.Number -IsOffline $false -ErrorAction SilentlyContinue
    Clear-Disk -Number $d.Number -RemoveData -RemoveOEM -Confirm:$false -ErrorAction SilentlyContinue
}

Update-HostStorageCache

# Clear user-specified disks (skip System/Boot)
foreach ($n in $nums) {
    $d = Get-Disk -Number $n -ErrorAction SilentlyContinue
    if ($d -and -not $d.IsSystem -and -not $d.IsBoot) {
        Set-Disk -Number $n -IsReadOnly $false -ErrorAction SilentlyContinue
        Set-Disk -Number $n -IsOffline $false -ErrorAction SilentlyContinue
        Clear-Disk -Number $n -RemoveData -RemoveOEM -Confirm:$false -ErrorAction SilentlyContinue
        Write-Host "  SUCCESS: Disk $n cleared to RAW." -ForegroundColor Green
    } elseif ($d -and ($d.IsSystem -or $d.IsBoot)) {
        Write-Host "  SKIPPED: Disk $n is System/Boot - protected." -ForegroundColor Yellow
    } else {
        Write-Host "  WARNING: Disk $n not found." -ForegroundColor Red
    }
}

Update-HostStorageCache

Write-Host ""
Write-Host "  == DISKS ==" -ForegroundColor Cyan
Get-Disk | Select-Object Number, FriendlyName, BusType, PartitionStyle, IsOffline, IsReadOnly, IsSystem, IsBoot, Size |
    Sort-Object Number | Format-Table -AutoSize

Write-Host "  == PHYSICAL DISKS ==" -ForegroundColor Cyan
Get-PhysicalDisk | Select-Object DeviceId, FriendlyName, CanPool, Usage, OperationalStatus |
    Sort-Object DeviceId | Format-Table -AutoSize

Write-Host ""
Read-Host "Press Enter to exit..."