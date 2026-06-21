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
Write-Host "  Script: 149.CapitalLettersOnFiles.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0149" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > File Renaming" -ForegroundColor DarkCyan
Write-Host "  Description: Renames files in a folder by adding an alphabetical letter prefix starting from a specified letter, replacing any existing letter prefix" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$path  = Read-Host "Enter folder path"
$start = Read-Host "Starting letter (A-Z)"

if (-not (Test-Path $path -PathType Container)) {
    Write-Host "  ERROR: Folder not found: $path" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$start  = [char]$start.ToUpper()
$A      = [byte][char]'A'
$offset = ([byte][char]$start) - $A

$toAZ = {
    param($n)
    $s = ''
    $n++
    while ($n -gt 0) {
        $n--
        $s = [char](($n % 26) + 65) + $s
        $n = [math]::Floor($n / 26)
    }
    $s
}

$files = Get-ChildItem -LiteralPath $path -File | Sort-Object Name
$count = 0

for ($i = 0; $i -lt $files.Count; $i++) {
    $f    = $files[$i]
    $bn   = $f.BaseName
    $ext  = $f.Extension
    $dir  = $f.DirectoryName
    $core = [regex]::Replace($bn, '^\s*[A-Za-z]+\.\s*', '')
    if ([string]::IsNullOrWhiteSpace($core)) { $core = $bn }
    $prefix = & $toAZ ($offset + $i)
    $cand   = "$prefix. $core$ext"
    $n      = 1
    while (Test-Path (Join-Path $dir $cand)) {
        $cand = "$prefix. $core ($n)$ext"
        $n++
    }
    if ($cand -ne $f.Name) {
        Rename-Item -LiteralPath $f.FullName -NewName $cand -Force
        $count++
    }
}

if ($count -gt 0) {
    Write-Host "  $count file(s) renamed with alphabetical prefix starting at '$start'." -ForegroundColor Green
} else {
    Write-Host "  No files needed renaming." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."