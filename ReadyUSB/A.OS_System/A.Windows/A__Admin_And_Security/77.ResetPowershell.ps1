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
Write-Host "  Script: 77.ResetPowershell.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0077" -ForegroundColor Cyan
Write-Host "  Version: 1.2" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Resets PowerShell console colors, profiles, and Windows Terminal settings to defaults" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# --- Clean Console registry color keys ---
$props = @('ScreenColors', 'PopupColors') + (0..15 | ForEach-Object { "ColorTable$_" })

'HKCU:\Console', 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console' | ForEach-Object {
    if (Test-Path $_) {
        Get-ChildItem $_ -Recurse | ForEach-Object {
            $k = $_.PSPath
            foreach ($p in $props) {
                Remove-ItemProperty -Path $k -Name $p -ErrorAction SilentlyContinue
            }
        }
        foreach ($p in $props) {
            Remove-ItemProperty -Path $_ -Name $p -ErrorAction SilentlyContinue
        }
    }
}

# --- Remove PowerShell-specific Console registry keys ---
@(
    'HKCU:\Console\%SystemRoot%_system32_powershell.exe',
    'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe',
    'HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'
) | ForEach-Object {
    if (Test-Path $_) {
        Remove-Item $_ -Recurse -Force
    }
}

# --- Reset Windows Terminal settings ---
$wtPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)
foreach ($p in $wtPaths) {
    if (Test-Path $p) {
        Remove-Item $p -Force -ErrorAction SilentlyContinue
    }
}

# --- Clear PowerShell profiles (backup first) ---
$profiles = @(
    $PROFILE,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.AllUsersAllHosts
) | Select-Object -Unique | Where-Object { $_ }

foreach ($pf in $profiles) {
    try {
        if (Test-Path $pf) {
            $bak = "$pf.bak_$(Get-Date -Format 'yyyyMMddHHmmss')"
            Copy-Item $pf $bak -Force
            Clear-Content $pf -ErrorAction SilentlyContinue
            Set-Content $pf "" -Encoding UTF8
        }
    } catch {}
}

# --- Reset console colors for current session ---
$Host.UI.RawUI.ForegroundColor = 'Gray'
$Host.UI.RawUI.BackgroundColor = 'Black'

Write-Host ""
Write-Host "  Full reset done: Console registry cleaned, Windows Terminal reset, PowerShell profiles disabled." -ForegroundColor Green
Write-Host "  Close ALL consoles and reopen for changes to take effect." -ForegroundColor Yellow

Write-Host ""
Read-Host "Press Enter to exit..."