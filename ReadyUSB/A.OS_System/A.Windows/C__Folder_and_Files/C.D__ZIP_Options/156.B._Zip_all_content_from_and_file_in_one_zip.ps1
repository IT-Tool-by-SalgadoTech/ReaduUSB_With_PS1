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
Write-Host "  Script: 155.B._Zip_all_content_from_and_file_in_one_zip.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0155" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Compression" -ForegroundColor DarkCyan
Write-Host "  Description: Compresses all files in a source folder into a single ZIP file at a specified output path" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$sourceFolder = Read-Host "Enter source folder"
$zipFile      = Read-Host "Enter full path for the output ZIP file (e.g. C:\output.zip)"

if (-not (Test-Path $sourceFolder -PathType Container)) {
    Write-Host "  ERROR: Source folder not found: $sourceFolder" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Compress-Archive -Path "$sourceFolder\*" -DestinationPath $zipFile -Force

if (Test-Path $zipFile) {
    Write-Host "  All content compressed into: $zipFile" -ForegroundColor Green
} else {
    Write-Host "  ERROR: ZIP file was not created." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."