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
Write-Host "  Script: 159.D._Zip_Files__folders_and_sub_folders.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0159" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Compression" -ForegroundColor DarkCyan
Write-Host "  Description: Compresses a source folder including all files and subfolders into a ZIP archive at a specified destination" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$sourcePath = Read-Host "Enter the source folder path"
$destZip    = Read-Host "Enter the destination ZIP file path (e.g. C:\Backup\archive.zip)"

if (-not (Test-Path $sourcePath)) {
    Write-Host "  ERROR: Source folder '$sourcePath' not found." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($sourcePath, $destZip)
    Write-Host "  SUCCESS: '$sourcePath' compressed to '$destZip'." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Compression failed. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."