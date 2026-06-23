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
Write-Host "  Script: 213.FormatDisk.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0213" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Interactive multi-disk format tool that initializes selected disks as GPT NTFS volumes, with System/Boot protection and EFI/Recovery override confirmation" -ForegroundColor DarkCyan
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

# Show available disks
Get-Disk | Select-Object Number, FriendlyName, Size, PartitionStyle, IsSystem, IsBoot | Format-Table -AutoSize

$sel  = Read-Host "Enter disk numbers to format (comma-separated, e.g. 0,1,2)"
$nums = ($sel -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

$safe    = @()
$warn    = @()
$skipped = @()

foreach ($n in $nums) {
    $d = Get-Disk -Number $n -ErrorAction SilentlyContinue
    if (-not $d) {
        $skipped += "Disk ${n}: not found"
        continue
    }
    $hasC = Get-Partition -DiskNumber $n -ErrorAction SilentlyContinue |
        Get-Volume -ErrorAction SilentlyContinue |
        Where-Object { $_.DriveLetter -eq 'C' }
    if ($d.IsSystem -or $d.IsBoot -or $hasC) {
        $skipped += "Disk ${n}: SYSTEM/BOOT/C: - blocked"
        continue
    }
    $flags = Get-Partition -DiskNumber $n -ErrorAction SilentlyContinue |
        Where-Object { $_.IsBoot -or $_.IsSystem -or $_.IsRecovery }
    if ($flags) { $warn += $n } else { $safe += $n }
}

if (-not $safe -and -not $warn) {
    Write-Host "  ERROR: No eligible disks selected." -ForegroundColor Red
    if ($skipped) { $skipped | ForEach-Object { Write-Host "  SKIPPED: $_" -ForegroundColor Yellow } }
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if ($warn)  { Write-Host "  WARNING: EFI/Recovery partitions present on disk(s): $($warn -join ', ') - override required." -ForegroundColor Yellow }
if ($safe)  { Write-Host "  Ready to format (safe): $($safe -join ', ')" -ForegroundColor Cyan }

$final = $safe + @()
if ($warn) {
    $expectedOverride = "OVERRIDE $($warn -join ',')"
    $ok = Read-Host "Type '$expectedOverride' to ALSO wipe EFI/Recovery disks (or press Enter to skip)"
    if ($ok -eq $expectedOverride) { $final += $warn }
}

if (-not $final) {
    Write-Host "  Aborted." -ForegroundColor Yellow
    if ($skipped) { $skipped | ForEach-Object { Write-Host "  SKIPPED: $_" -ForegroundColor Yellow } }
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

$expectedConfirm = "FORMAT $($final -join ',')"
$confirm = Read-Host "Type '$expectedConfirm' to proceed"
if ($confirm -ne $expectedConfirm) {
    Write-Host "  Aborted." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

foreach ($n in $final) {
    try {
        Get-Partition -DiskNumber $n -ErrorAction SilentlyContinue | Remove-Partition -Confirm:$false -ErrorAction SilentlyContinue
        Clear-Disk -Number $n -RemoveData -RemoveOEM -Confirm:$false
        Initialize-Disk -Number $n -PartitionStyle GPT
        $p = New-Partition -DiskNumber $n -UseMaximumSize -AssignDriveLetter
        Format-Volume -Partition $p -FileSystem NTFS -NewFileSystemLabel ("Disk$n") -Confirm:$false -Force
        Write-Host "  SUCCESS: Disk $n formatted successfully." -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Disk $n - $($_.Exception.Message)" -ForegroundColor Red
    }
}

if ($skipped) {
    Write-Host ""
    Write-Host "  Skipped disks:" -ForegroundColor Yellow
    $skipped | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }
}

Write-Host ""
Read-Host "Press Enter to exit..."