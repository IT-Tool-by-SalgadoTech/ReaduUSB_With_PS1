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
Write-Host "  Script: 272_B_LocateNmap.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0272" -ForegroundColor Cyan
Write-Host "  Version: 1.2" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Nmap" -ForegroundColor DarkCyan
Write-Host "  Description: Searches all local drives for nmap.exe and shows full path" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

Write-Host "  Searching all local drives for nmap.exe..." -ForegroundColor Cyan
Write-Host ""

$localDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object {
    ($_.DriveType -eq 'Fixed' -or $_.DriveType -eq 'Removable') -and $_.IsReady
}

$results = foreach ($drive in $localDrives) {
    Get-ChildItem -Path $drive.RootDirectory -Filter nmap.exe -Recurse -ErrorAction SilentlyContinue
}

if ($results) {
    Write-Host "  nmap.exe found at:" -ForegroundColor Green
    $results | ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor White }
} else {
    Write-Host "  nmap.exe not found on any local drive." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."