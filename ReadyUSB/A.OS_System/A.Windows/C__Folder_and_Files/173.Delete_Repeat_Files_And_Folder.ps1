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
Write-Host "  Script: 173.Delete_Repeat_Files_And_Folder.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0173" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the Delete_Repeat_Files_And_Folder.ps1 script from the SalgadoTech GitHub repository to the Desktop and executes it" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$destPath  = "$env:USERPROFILE\Desktop\Delete_Repeat_Files_And_Folder.ps1"
$sourceUrl = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/Delete_Repeat_Files_And_Folder.ps1"

$destDir = Split-Path $destPath
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
}

try {
    curl.exe -L $sourceUrl -o $destPath
    Write-Host "  SUCCESS: Delete_Repeat_Files_And_Folder.ps1 downloaded to Desktop." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed. $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (-not (Test-Path $destPath)) {
    Write-Host "  ERROR: File not found after download. Check your internet connection." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    & $destPath
    Write-Host "  SUCCESS: Delete_Repeat_Files_And_Folder.ps1 executed." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Execution failed. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."