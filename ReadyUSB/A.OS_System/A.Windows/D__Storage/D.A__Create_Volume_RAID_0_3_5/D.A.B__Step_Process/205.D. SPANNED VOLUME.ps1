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
Write-Host "  Script: 205.D._SPANNED_VOLUME.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0205" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Combines two or more disks into a single spanned NTFS volume using diskpart, converting them to dynamic GPT first" -ForegroundColor DarkCyan
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

$disksInput = Read-Host "Disk numbers separated by comma (e.g. 1,2 or 1,2,3)"
$letter     = (Read-Host "Drive letter (e.g. F)").TrimEnd(':').ToUpper()
$label      = Read-Host "Volume label (e.g. SPANNED)"

$dList = ($disksInput -split ',') | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' }

if ($dList.Count -lt 2) {
    Write-Host "  ERROR: At least 2 disks are required for a Spanned volume." -ForegroundColor Red
    Write-Host ""
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

Write-Host ""
Read-Host "Press Enter to exit..."