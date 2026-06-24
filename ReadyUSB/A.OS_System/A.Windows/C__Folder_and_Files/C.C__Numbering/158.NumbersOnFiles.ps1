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
Write-Host "  Script: 158.NumbersOnFiles.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0158" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > File Renaming" -ForegroundColor DarkCyan
Write-Host "  Description: Renames files in a folder by prepending a sequential numeric prefix starting from a specified number" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$path  = Read-Host "Enter the folder path to rename files"
$start = [int](Read-Host "Enter the starting number")

if (-not (Test-Path $path -PathType Container)) {
    Write-Host "  ERROR: Folder not found: $path" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$i     = $start
$count = 0

Get-ChildItem -LiteralPath $path -File | Sort-Object Name | ForEach-Object {
    Rename-Item -LiteralPath $_.FullName -NewName ("{0}.{1}" -f $i, $_.Name) -Force
    $i++
    $count++
}

if ($count -gt 0) {
    Write-Host "  $count file(s) renamed starting from number $start." -ForegroundColor Green
} else {
    Write-Host "  No files found in folder." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."