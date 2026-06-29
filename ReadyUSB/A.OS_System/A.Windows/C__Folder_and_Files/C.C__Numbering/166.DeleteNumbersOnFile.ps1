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
Write-Host "  Script: 166.DeleteNumbersOnFile.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0166" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > File Renaming" -ForegroundColor DarkCyan
Write-Host "  Description: Removes leading numeric prefixes (e.g. '1. ', '23.') from filenames in a specified folder" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$path = Read-Host "Enter folder path"

if (-not (Test-Path $path -PathType Container)) {
    Write-Host "  ERROR: Folder not found: $path" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$count = 0

Get-ChildItem -LiteralPath $path -File -Force | ForEach-Object {
    $baseName = $_.BaseName
    $ext      = $_.Extension
    $dir      = $_.DirectoryName
    $newBase  = ($baseName -replace '^\d+\.', '').Trim()
    if ([string]::IsNullOrWhiteSpace($newBase) -or $newBase -eq $baseName) { return }
    $candidate = "$newBase$ext"
    $n         = 1
    while (Test-Path -LiteralPath (Join-Path $dir $candidate)) {
        $candidate = "$newBase ($n)$ext"
        $n++
    }
    Rename-Item -LiteralPath $_.FullName -NewName $candidate -Force
    $count++
}

if ($count -gt 0) {
    Write-Host "  $count file(s) had their numeric prefix removed." -ForegroundColor Green
} else {
    Write-Host "  No files with numeric prefixes found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."