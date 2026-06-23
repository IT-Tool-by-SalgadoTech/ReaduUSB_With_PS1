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
Write-Host "  Script: 190.Number_files_with_path.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0190" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Adds a sequential numeric prefix to all files in a specified folder, sorting them alphabetically before numbering" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$folderPath = Read-Host "Enter the folder path to rename files"

if ([string]::IsNullOrWhiteSpace($folderPath)) {
    Write-Host "  ERROR: No folder path provided." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if (-not (Test-Path -LiteralPath $folderPath -PathType Container)) {
    Write-Host "  ERROR: Folder not found: '$folderPath'" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$files   = Get-ChildItem -Path $folderPath -File | Sort-Object Name
$counter = 1

foreach ($file in $files) {
    $newName = "$counter.$($file.Name)"
    try {
        Rename-Item -Path $file.FullName -NewName $newName
        $counter++
    } catch {
        Write-Host "  WARNING: Could not rename '$($file.Name)'. $_" -ForegroundColor Red
    }
}

Write-Host "  SUCCESS: $($counter - 1) file(s) renamed with a numerical prefix." -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."