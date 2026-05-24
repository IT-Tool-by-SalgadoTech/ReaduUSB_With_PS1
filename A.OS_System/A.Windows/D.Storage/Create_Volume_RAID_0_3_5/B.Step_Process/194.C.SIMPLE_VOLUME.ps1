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
Write-Host "  Script: 194.C.SIMPLE_VOLUME.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0194" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Initializes a single disk as GPT and formats it as a simple NTFS volume with a user-assigned drive letter and label" -ForegroundColor DarkCyan
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

$diskNum = Read-Host "Disk number (e.g. 0)"
$letter  = (Read-Host "Drive letter (e.g. E)").TrimEnd(':').ToUpper()
$label   = Read-Host "Volume label (e.g. DATA)"

$d = Get-Disk -Number $diskNum -ErrorAction Stop
if ($d.IsSystem -or $d.IsBoot) {
    Write-Host "  ERROR: Disk $diskNum is a System/Boot disk. Aborting." -ForegroundColor Red
    Write-Host ""
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

Write-Host ""
Read-Host "Press Enter to exit..."