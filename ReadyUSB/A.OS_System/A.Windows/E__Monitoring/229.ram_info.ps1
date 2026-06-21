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
Write-Host "  Script: 228.ram_info.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0228" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Displays total and free physical RAM in GB, and per-slot RAM module details" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
    $totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $freeGB  = [math]::Round($os.FreePhysicalMemory  / 1MB, 2)
    $usedGB  = [math]::Round($totalGB - $freeGB, 2)

    Write-Host "  SUCCESS: RAM information retrieved." -ForegroundColor Green
    Write-Host ""
    Write-Host "  Total RAM : $totalGB GB" -ForegroundColor Cyan
    Write-Host "  Used RAM  : $usedGB GB" -ForegroundColor Cyan
    Write-Host "  Free RAM  : $freeGB GB" -ForegroundColor Cyan
    Write-Host ""

    $slots = Get-CimInstance -ClassName Win32_PhysicalMemory -ErrorAction SilentlyContinue |
        Select-Object BankLabel, Capacity, Speed, Manufacturer, MemoryType |
        ForEach-Object {
            [pscustomobject]@{
                Slot         = $_.BankLabel
                CapacityGB   = [math]::Round($_.Capacity / 1GB, 2)
                SpeedMHz     = $_.Speed
                Manufacturer = $_.Manufacturer
            }
        }

    if ($slots) {
        Write-Host "  RAM Slots:" -ForegroundColor Cyan
        $slots | Format-Table -AutoSize
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve RAM information. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."