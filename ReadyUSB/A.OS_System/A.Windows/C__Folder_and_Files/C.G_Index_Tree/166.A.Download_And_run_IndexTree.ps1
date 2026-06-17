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
Write-Host "  Script: 166_A_Download_Run_PyDocument.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0166" -ForegroundColor Cyan
Write-Host "  Version: 1.4" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Downloads Folder_tree.py from GitHub to the Desktop and runs it using Python 3" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# -- Step 1: Download Folder_tree.py ------------------------------------------
$downloadUrl = "https://github.com/IT-Tool-by-SalgadoTech/ittool-External_Tools/raw/refs/heads/main/Folder_tree.py"
$scriptPath  = "$env:USERPROFILE\Desktop\Folder_tree.py"

Write-Host "  [1/3] Downloading Folder_tree.py to Desktop..." -ForegroundColor Cyan

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $scriptPath -UseBasicParsing
    Write-Host "  SUCCESS: Folder_tree.py downloaded to Desktop." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Download failed - $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# -- Step 2: Locate Python 3 --------------------------------------------------
Write-Host ""
Write-Host "  [2/3] Locating Python 3..." -ForegroundColor Cyan

$pythonExe = $null

# 1) Check python/python3 already in PATH and confirm version 3
foreach ($cmd in @("python", "python3")) {
    try {
        $p = Get-Command $cmd -ErrorAction Stop
        $ver = & $p.Source --version 2>&1
        if ("$ver" -match "Python 3") {
            $pythonExe = $p.Source
            break
        }
    } catch {}
}

# 2) Scan known Windows Python install locations directly (no deep recurse)
if (-not $pythonExe) {
    $pyBase = "$env:LOCALAPPDATA\Programs\Python"
    if (Test-Path $pyBase) {
        $dirs = Get-ChildItem -Path $pyBase -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match "^Python3" } |
                Sort-Object Name -Descending
        foreach ($dir in $dirs) {
            $candidate = Join-Path $dir.FullName "python.exe"
            if (Test-Path $candidate) {
                $ver = & "$candidate" --version 2>&1
                if ("$ver" -match "Python 3") {
                    $pythonExe = $candidate
                    break
                }
            }
        }
    }
}

# 3) Check registry for Python 3 install path
if (-not $pythonExe) {
    $regPaths = @(
        "HKCU:\Software\Python\PythonCore",
        "HKLM:\Software\Python\PythonCore",
        "HKLM:\Software\Wow6432Node\Python\PythonCore"
    )
    foreach ($reg in $regPaths) {
        if (-not (Test-Path $reg)) { continue }
        $versions = Get-ChildItem $reg -ErrorAction SilentlyContinue |
                    Where-Object { $_.PSChildName -match "^3\." } |
                    Sort-Object PSChildName -Descending
        foreach ($v in $versions) {
            $installPath = (Get-ItemProperty -Path "$($v.PSPath)\InstallPath" -ErrorAction SilentlyContinue)."(default)"
            if (-not $installPath) {
                $installPath = (Get-ItemProperty -Path "$($v.PSPath)\InstallPath" -ErrorAction SilentlyContinue).ExecutablePath
            }
            if ($installPath) {
                $candidate = Join-Path $installPath "python.exe"
                if (Test-Path $candidate) {
                    $pythonExe = $candidate
                    break
                }
            }
        }
        if ($pythonExe) { break }
    }
}

if (-not $pythonExe) {
    Write-Host "  ERROR: Python 3 not found." -ForegroundColor Red
    Write-Host "  Run 300_Python3_13_5.ps1 to install Python, then 279_Python_activate.ps1 to add it to PATH." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "  SUCCESS: Python 3 found at $pythonExe" -ForegroundColor Green

# -- Step 3: Run Folder_tree.py -----------------------------------------------
Write-Host ""
Write-Host "  [3/3] Running Folder_tree.py..." -ForegroundColor Cyan
Write-Host ""

Set-Location "$env:USERPROFILE\Desktop"
& "$pythonExe" "$scriptPath"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "  SUCCESS: Folder_tree.py completed." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  ERROR: Folder_tree.py exited with code $LASTEXITCODE." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."