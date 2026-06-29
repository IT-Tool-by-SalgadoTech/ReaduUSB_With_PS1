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
Write-Host "  Script: 85.Taskkill.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0085" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Processes" -ForegroundColor DarkCyan
Write-Host "  Description: Lists running processes and kills a selected one interactively by index" -ForegroundColor DarkCyan
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

try {
    $p = Get-Process | Sort-Object Name

    Write-Host "  Running processes:" -ForegroundColor Cyan
    Write-Host ""
    for ($i = 0; $i -lt $p.Count; $i++) {
        Write-Host ("  {0,4} - {1}.exe" -f $i, $p[$i].Name)
    }

    Write-Host ""
    $choice = Read-Host "  Enter number of process to kill"

    if ($choice -match '^\d+$' -and [int]$choice -lt $p.Count) {
        $name = $p[[int]$choice].Name
        Stop-Process -Name $name -Force
        Write-Host "  Process '$name' killed successfully." -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Invalid selection." -ForegroundColor Red
    }
} catch {
    Write-Host "  ERROR: Failed to kill process." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."