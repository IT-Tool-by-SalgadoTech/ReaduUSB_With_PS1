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
Write-Host "  Script: 214.DeleteSpannedVolume.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0214" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Storage & Disks" -ForegroundColor DarkCyan
Write-Host "  Description: Wipes selected dynamic disks used by a spanned volume back to RAW using diskpart clean" -ForegroundColor DarkCyan
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

$rawInput = Read-Host "Enter disk numbers to clean (e.g. 1,2)"
$dList    = @($rawInput -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -match '^\d+$' })

if ($dList.Count -eq 0) {
    Write-Host "  ERROR: No valid disk numbers provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$tmpFile = Join-Path $env:TEMP ("raw_{0}.txt" -f ([guid]::NewGuid().ToString('N')))
$lines   = @("rescan")
foreach ($n in $dList) {
    $lines += "select disk $n"
    $lines += "online disk noerr"
    $lines += "attributes disk clear readonly"
    $lines += "clean"
}
$lines += "exit"
$lines | Set-Content -LiteralPath $tmpFile -Encoding ASCII

Write-Host "  Disks to clean: $($dList -join ', ')" -ForegroundColor Cyan
$confirm = Read-Host "Press Enter to proceed (or Ctrl+C to cancel)"

diskpart /s $tmpFile
Remove-Item -LiteralPath $tmpFile -Force -ErrorAction SilentlyContinue
Update-HostStorageCache

if ($LASTEXITCODE -eq 0) {
    Write-Host "  SUCCESS: Disks cleaned. Refresh Disk Management (F5) to confirm." -ForegroundColor Green
} else {
    Write-Host "  ERROR: diskpart reported an error (exit code $LASTEXITCODE)." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."