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
Write-Host "  Script: 303_Fan_Control.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0303" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > App Downloader" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads FanControl ZIP from GitHub, extracts it to the Desktop, and launches FanControl.exe with elevated privileges" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$url     = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/FanControl_229_net_4_8.zip"
$zipDest = Join-Path $env:USERPROFILE "Downloads\FanControl_229_net_4_8.zip"
$outDir  = Join-Path ([Environment]::GetFolderPath("Desktop")) "FanControl_229_net_4_8"

Remove-Item $outDir -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "  Downloading FanControl ZIP from GitHub..." -ForegroundColor Cyan

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
Write-Host "  Extracting to Desktop\FanControl_229_net_4_8..." -ForegroundColor Cyan

try {
    Expand-Archive -Path $zipDest -DestinationPath $outDir -Force
    Write-Host "  SUCCESS: Extracted to $outDir" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Extraction failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$exe = $null
for ($i = 0; $i -lt 20 -and -not $exe; $i++) {
    Start-Sleep -Milliseconds 500
    $exe = (Get-ChildItem -Path $outDir -Recurse -Filter "FanControl.exe" -File -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
}

if (-not $exe) {
    Write-Host "  ERROR: FanControl.exe not found after extraction." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Unblock-File -Path $exe -ErrorAction SilentlyContinue
if (Get-Item $exe -Stream "Zone.Identifier" -ErrorAction SilentlyContinue) {
    Remove-Item $exe -Stream "Zone.Identifier" -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "  Launching FanControl..." -ForegroundColor Cyan
Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe -Parent) -Verb RunAs
Write-Host "  SUCCESS: FanControl launched." -ForegroundColor Green

Write-Host ""
Read-Host "Press Enter to exit..."