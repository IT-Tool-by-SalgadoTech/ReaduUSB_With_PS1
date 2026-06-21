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
Write-Host "  Script: 192.CreateVolume.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0192" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Prepares selected disks (RAW/pool-ready) then creates a Simple, Spanned, or RAID (0/1/5) volume interactively" -ForegroundColor DarkCyan
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

# --- PREP DISKS ---
$rawInput = Read-Host "Enter disk numbers to PREP (e.g. 0,1,2)"
$diskNums = $rawInput.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

if ($diskNums.Count -eq 0) {
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

Start-Service -Name StorSvc -ErrorAction SilentlyContinue

# --- CREATE VOLUME ---
$opt = Read-Host "Choose volume type: 1) Simple  2) Spanned  3) RAID (0/1/5)"

switch ($opt) {
    '1' {
        $diskNum = Read-Host "Disk number (e.g. 0)"
        $letter  = (Read-Host "Drive letter (e.g. E)").TrimEnd(':').ToUpper()
        $label   = Read-Host "Volume label (e.g. DATA)"

        $d = Get-Disk -Number $diskNum -ErrorAction Stop
        if ($d.IsSystem -or $d.IsBoot) {
            Write-Host "  ERROR: Disk $diskNum is System/Boot. Aborting." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $tmpFile = Join-Path $env:TEMP ("simple_{0}.txt" -f ([guid]::NewGuid().ToString('N')))
        $lines = @(
            "select disk $diskNum",
            "online disk noerr",
            "attributes disk clear readonly",
            "convert gpt noerr",
            "rescan",
            "create partition primary",
            "format fs=ntfs label=`"$label`" quick",
            "assign letter=$letter",
            "exit"
        )
        $lines | Set-Content -LiteralPath $tmpFile -Encoding ASCII
        diskpart /s $tmpFile
        Remove-Item -LiteralPath $tmpFile -Force -ErrorAction SilentlyContinue

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  SUCCESS: Simple volume '$label' created on drive ${letter}:." -ForegroundColor Green
        } else {
            Write-Host "  ERROR: diskpart reported an error (exit code $LASTEXITCODE)." -ForegroundColor Red
        }
    }

    '2' {
        $disksInput = Read-Host "Disk numbers separated by comma (e.g. 1,2 or 1,2,3)"
        $letter     = (Read-Host "Drive letter (e.g. F)").TrimEnd(':').ToUpper()
        $label      = Read-Host "Volume label (e.g. SPANNED)"
        $dList      = ($disksInput -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }

        if ($dList.Count -lt 2) {
            Write-Host "  ERROR: At least 2 disks are required for a Spanned volume." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $tmpFile = Join-Path $env:TEMP ("spanned_{0}.txt" -f ([guid]::NewGuid().ToString('N')))
        $prep    = ($dList | ForEach-Object {
            "select disk $_`nonline disk noerr`nattributes disk clear readonly`nconvert gpt noerr`nconvert dynamic noerr"
        }) -join "`n"
        $first   = $dList[0]
        $rest    = $dList[1..($dList.Count - 1)]
        $extend  = ($rest | ForEach-Object { "extend disk=$_" }) -join "`n"
        $script  = "rescan`n$prep`nselect disk $first`ncreate volume simple`n$extend`nformat fs=ntfs label=`"$label`" quick`nassign letter=$letter`nexit"
        $script | Set-Content -LiteralPath $tmpFile -Encoding ASCII
        diskpart /s $tmpFile
        Remove-Item -LiteralPath $tmpFile -Force -ErrorAction SilentlyContinue

        if ($LASTEXITCODE -eq 0) {
            Write-Host "  SUCCESS: Spanned volume '$label' created on drive ${letter}:." -ForegroundColor Green
        } else {
            Write-Host "  ERROR: diskpart reported an error (exit code $LASTEXITCODE)." -ForegroundColor Red
        }
    }

    '3' {
        $svc = Get-Service -Name StorSvc -ErrorAction SilentlyContinue
        if (-not $svc -or $svc.Status -ne 'Running') {
            Start-Service -Name StorSvc
            Start-Sleep -Seconds 2
        }

        $raidType = Read-Host "RAID type? Enter 0, 1, or 5"
        $idsRaw   = Read-Host "Enter disk numbers to use (e.g. 0,1,2)"
        $ids      = $idsRaw.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }

        if (-not $ids) {
            Write-Host "  ERROR: No disk numbers provided." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $minNeeded = switch ($raidType) { '0' { 2 } '1' { 2 } '5' { 3 } default { 0 } }
        if ($minNeeded -eq 0) {
            Write-Host "  ERROR: Invalid RAID type '$raidType'. Use 0, 1, or 5." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }
        if ($ids.Count -lt $minNeeded) {
            Write-Host "  ERROR: RAID $raidType requires at least $minNeeded disks. Provided: $($ids.Count)." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $subsys = Get-StorageSubsystem | Select-Object -First 1
        if (-not $subsys) {
            Write-Host "  ERROR: Storage subsystem not found." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $physAll  = Get-PhysicalDisk
        $phys     = $physAll | Where-Object { $ids -contains $_.DeviceId }
        if ($phys.Count -ne $ids.Count) {
            $missing = $ids | Where-Object { $physAll.DeviceId -notcontains $_ }
            Write-Host "  ERROR: Could not resolve DeviceId(s): $($missing -join ',')" -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $notPoolable = $phys | Where-Object { -not $_.CanPool }
        if ($notPoolable) {
            Write-Host "  ERROR: Some disks are not poolable:" -ForegroundColor Red
            $notPoolable | Select-Object DeviceId, Usage, OperationalStatus, HealthStatus | Format-Table -AutoSize
            Write-Host "  Run PREP again until CanPool=True." -ForegroundColor Yellow
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $poolName = Read-Host "Storage Pool name (default: ITToolPool)"
        if ([string]::IsNullOrWhiteSpace($poolName)) { $poolName = 'ITToolPool' }
        $vdName = Read-Host "Virtual Disk name (default: ITToolVD)"
        if ([string]::IsNullOrWhiteSpace($vdName)) { $vdName = 'ITToolVD' }
        $label = Read-Host "Volume label (default: RAIDVolume)"
        if ([string]::IsNullOrWhiteSpace($label)) { $label = 'RAIDVolume' }

        if (Get-StoragePool -FriendlyName $poolName -ErrorAction SilentlyContinue) {
            Write-Host "  ERROR: Storage Pool '$poolName' already exists. Use a different name or delete it first." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }
        if (Get-VirtualDisk -FriendlyName $vdName -ErrorAction SilentlyContinue) {
            Write-Host "  ERROR: Virtual Disk '$vdName' already exists. Use a different name or delete it first." -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            exit 1
        }

        $resil = switch ($raidType) { '0' { 'Simple' } '1' { 'Mirror' } '5' { 'Parity' } }

        try {
            $pool     = New-StoragePool -FriendlyName $poolName -StorageSubsystemFriendlyName $subsys.FriendlyName -PhysicalDisks $phys
            $vdParams = @{
                StoragePoolFriendlyName = $poolName
                FriendlyName           = $vdName
                ResiliencySettingName  = $resil
                UseMaximumSize         = $true
            }
            if ($raidType -eq '1') { $vdParams['NumberOfDataCopies'] = 2 }
            $vd   = New-VirtualDisk @vdParams
            $disk = $vd | Get-Disk
            Initialize-Disk -Number $disk.Number -PartitionStyle GPT
            $part = New-Partition -DiskNumber $disk.Number -UseMaximumSize -AssignDriveLetter
            Format-Volume -Partition $part -FileSystem NTFS -NewFileSystemLabel $label -Confirm:$false
            $vol  = Get-Volume -FileSystemLabel $label | Select-Object -First 1
            $dl   = $vol.DriveLetter
            Write-Host "  SUCCESS: RAID $raidType volume '$label' created on drive ${dl}:." -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: Failed to create RAID volume. $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    default {
        Write-Host "  ERROR: Invalid option. Exiting." -ForegroundColor Red
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."