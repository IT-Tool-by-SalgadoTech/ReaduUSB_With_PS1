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
Write-Host "  Script: 55.Check_ram.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0055" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Hardware" -ForegroundColor DarkCyan
Write-Host "  Description: Displays total, used, and free RAM, plus the top 20 processes by memory consumption" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Format-GB($bytes) {
    return "{0:N2}" -f ($bytes / 1GB)
}

function Format-MB($bytes) {
    return "{0:N2}" -f ($bytes / 1MB)
}

try {
    Write-Host ""
    Write-Host "  ================ RAM STATUS ================" -ForegroundColor Cyan

    $os = Get-CimInstance Win32_OperatingSystem
    $cs = Get-CimInstance Win32_ComputerSystem

    $totalRAMBytes = [int64]$cs.TotalPhysicalMemory
    $freeRAMBytes  = [int64]$os.FreePhysicalMemory * 1KB
    $usedRAMBytes  = $totalRAMBytes - $freeRAMBytes
    $usedPercent   = [math]::Round(($usedRAMBytes / $totalRAMBytes) * 100, 2)

    Write-Host ("  Total RAM     : {0} GB" -f (Format-GB $totalRAMBytes))
    Write-Host ("  Used RAM      : {0} GB" -f (Format-GB $usedRAMBytes))
    Write-Host ("  Free RAM      : {0} GB" -f (Format-GB $freeRAMBytes))
    Write-Host ("  Usage Percent : {0} %" -f $usedPercent)

    Write-Host ""
    Write-Host "  =========== TOP PROCESSES USING RAM ===========" -ForegroundColor Yellow

    $topProcesses = Get-Process |
        Sort-Object WorkingSet64 -Descending |
        Select-Object -First 20 `
            Id,
            ProcessName,
            @{Name='RAM_MB';Expression={[math]::Round($_.WorkingSet64 / 1MB, 2)}},
            @{Name='Private_MB';Expression={
                if ($_.PrivateMemorySize64) {
                    [math]::Round($_.PrivateMemorySize64 / 1MB, 2)
                } else {
                    0
                }
            }},
            CPU

    $topProcesses | Format-Table -AutoSize

    Write-Host ""
    Write-Host "  ============= MEMORY DETAILS =============" -ForegroundColor Green

    $topProcesses | ForEach-Object {
        Write-Host ("  PID: {0} | Name: {1} | RAM: {2} MB | Private: {3} MB | CPU: {4}" -f `
            $_.Id, $_.ProcessName, $_.RAM_MB, $_.Private_MB, $_.CPU)
    }

    Write-Host ""
    Write-Host "  Done." -ForegroundColor Green
} catch {
    Write-Host ""
    Write-Host ("  ERROR: {0}" -f $_.Exception.Message) -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."