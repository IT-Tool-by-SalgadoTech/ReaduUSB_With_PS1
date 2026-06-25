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
Write-Host "  Script: 161.C._Zip_Files,_folders_and_sub_folders.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0161" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Compression" -ForegroundColor DarkCyan
Write-Host "  Description: Compresses each file and each subfolder in a source folder into separate ZIP files in a destination folder" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$sourceFolder      = Read-Host "Enter the source folder path"
$destinationFolder = Read-Host "Enter the destination folder path for the ZIP files"

if (-not (Test-Path $sourceFolder -PathType Container)) {
    Write-Host "  ERROR: Source folder not found: $sourceFolder" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (-not (Test-Path $destinationFolder)) {
    New-Item -ItemType Directory -Path $destinationFolder | Out-Null
}

$count = 0

Get-ChildItem -Path $sourceFolder -File | ForEach-Object {
    $zipName = Join-Path $destinationFolder "$($_.BaseName).zip"
    Compress-Archive -Path $_.FullName -DestinationPath $zipName -Force
    $count++
}

Get-ChildItem -Path $sourceFolder -Directory | ForEach-Object {
    $zipName = Join-Path $destinationFolder "$($_.Name).zip"
    Compress-Archive -Path $_.FullName -DestinationPath $zipName -Force
    $count++
}

if ($count -gt 0) {
    Write-Host "  $count item(s) compressed into separate ZIP files in: $destinationFolder" -ForegroundColor Green
} else {
    Write-Host "  No files or folders found in source folder." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."