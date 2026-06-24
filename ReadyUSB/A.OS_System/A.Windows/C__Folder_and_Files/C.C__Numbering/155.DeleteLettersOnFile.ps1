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
Write-Host "  Script: 155.DeleteLettersOnFile.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0155" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > File Renaming" -ForegroundColor DarkCyan
Write-Host "  Description: Removes leading letter prefixes (e.g. 'A. ', 'BC. ') from filenames in a specified folder" -ForegroundColor DarkCyan
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

Get-ChildItem -LiteralPath $path -File | ForEach-Object {
    $bn   = $_.BaseName
    $ext  = $_.Extension
    $dir  = $_.DirectoryName
    $core = [regex]::Replace($bn, '^\s*\p{L}+\.\s*', '')
    if ($core -eq $bn) { return }
    $cand = "$core$ext"
    $n    = 1
    while (Test-Path (Join-Path $dir $cand)) {
        $cand = "$core ($n)$ext"
        $n++
    }
    Rename-Item -LiteralPath $_.FullName -NewName $cand -Force
    $count++
}

if ($count -gt 0) {
    Write-Host "  $count file(s) had their letter prefix removed." -ForegroundColor Green
} else {
    Write-Host "  No files with letter prefixes found." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."