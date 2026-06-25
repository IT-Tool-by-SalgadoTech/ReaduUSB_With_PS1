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
Write-Host "  Script: 671.Empty_content_any_folder.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0671" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Clears all files and subfolders from a specified folder without deleting the folder itself" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "  ERROR: This script requires administrator privileges." -ForegroundColor Red
    Write-Host "  Right-click the script and select 'Run as Administrator'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$folderPath = Read-Host "Enter full path of folder to clear"

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

$resolvedPath = (Resolve-Path -LiteralPath $folderPath).Path

# Remove hidden/system/read-only attributes recursively
& cmd.exe /c "attrib -s -h -r `"$resolvedPath\*`" /S /D" | Out-Null

# Attempt standard removal
$wildPath = Join-Path $resolvedPath '*'
$needsFallback = $false

try {
    Remove-Item -Path $wildPath -Recurse -Force -ErrorAction Stop
} catch {
    $needsFallback = $true
}

if (-not $needsFallback) {
    $remaining = (Get-ChildItem -LiteralPath $resolvedPath -Force | Measure-Object).Count
    if ($remaining -gt 0) { $needsFallback = $true }
}

# Fallback: use Robocopy mirror with empty temp folder
if ($needsFallback) {
    $tempDir = Join-Path $env:TEMP ("empty-" + [guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    $logFile  = Join-Path $env:TEMP ("robocopy-" + [guid]::NewGuid().ToString("N") + ".log")
    $rcArgs   = @("`"$tempDir`"", "`"$resolvedPath`"", "/MIR", "/R:1", "/W:1", "/NFL", "/NDL", "/NJH", "/NJS", "/NC", "/NS")
    $rcProc   = Start-Process -FilePath robocopy -ArgumentList $rcArgs -NoNewWindow -PassThru -Wait -RedirectStandardOutput $logFile

    if ($rcProc.ExitCode -notin 0, 1) {
        Write-Host "  ERROR: Robocopy failed with exit code $($rcProc.ExitCode). Log: $logFile" -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
    Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
}

$leftover = Get-ChildItem -LiteralPath $resolvedPath -Force
if ($leftover.Count -eq 0) {
    Write-Host "  SUCCESS: Folder '$resolvedPath' has been cleared." -ForegroundColor Green
} else {
    Write-Host "  WARNING: $($leftover.Count) item(s) could not be removed:" -ForegroundColor Red
    $leftover | Select-Object -First 10 FullName | Format-Table -AutoSize
}

Write-Host ""
Read-Host "Press Enter to exit..."