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
Write-Host "  Script: 300_DirectTx.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0300" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads the DirectX June 2010 redistributable ZIP, extracts it, and runs the silent installer" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url      = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/directx_Jun2010_redist.zip"
$zipDest  = Join-Path $env:USERPROFILE "Downloads\directx_Jun2010_redist.zip"
$deskDest = Join-Path ([Environment]::GetFolderPath("Desktop")) "directx_Jun2010_redist"

Remove-Item $deskDest -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "  Downloading DirectX Jun 2010 redistributable..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $url -OutFile $zipDest -UseBasicParsing
    Write-Host "  SUCCESS: Download complete." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host ""
Write-Host "  Extracting archive..." -ForegroundColor Cyan

try {
    Expand-Archive -Path $zipDest -DestinationPath $deskDest -Force
    Write-Host "  SUCCESS: Extracted to $deskDest" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Extraction failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$exe = Join-Path $deskDest "DXSETUP.exe"
if (-not (Test-Path $exe)) {
    Write-Host "  ERROR: DXSETUP.exe not found after extraction." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Unblock-File -Path $exe -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "  Running DirectX silent installer..." -ForegroundColor Cyan
$proc = Start-Process -FilePath $exe -WorkingDirectory $deskDest -ArgumentList "/silent" -Verb RunAs -PassThru -Wait
$code = $proc.ExitCode

switch ($code) {
    0       { Write-Host "  SUCCESS: DirectX installed/updated." -ForegroundColor Green }
    1       { Write-Host "  INFO: DirectX - no changes needed." -ForegroundColor Yellow }
    default { Write-Host "  WARNING: Installer exit code: $code" -ForegroundColor Yellow }
}

Write-Host ""
Read-Host "Press Enter to exit..."