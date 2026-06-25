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
Write-Host "  Script: 41.FontColorReset.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0041" -ForegroundColor Cyan
Write-Host "  Version: 1.3" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-23" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Console Customization" -ForegroundColor DarkCyan
Write-Host "  Description: Resets PowerShell and CMD console colors to Windows defaults" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── 1. Limpiar propiedades de color en el registro ────────────────────────────
$regProps = @('ScreenColors','PopupColors') + (0..15 | ForEach-Object { "ColorTable$_" })

$regRoots = @(
    'HKCU:\Console',
    'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console'
)

foreach ($regRoot in $regRoots) {
    if (Test-Path $regRoot) {
        # Subkeys
        Get-ChildItem $regRoot -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
            $subPath = $_.PSPath
            foreach ($rp in $regProps) {
                Remove-ItemProperty -Path $subPath -Name $rp -ErrorAction SilentlyContinue
            }
        }
        # Root key
        foreach ($rp in $regProps) {
            Remove-ItemProperty -Path $regRoot -Name $rp -ErrorAction SilentlyContinue
        }
    }
}

# ── 2. Eliminar subkeys especificas de PowerShell ─────────────────────────────
$psSubkeys = @(
    'HKCU:\Console\%SystemRoot%_system32_powershell.exe',
    'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe',
    'HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'
)

foreach ($psKey in $psSubkeys) {
    if (Test-Path $psKey) {
        Remove-Item $psKey -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# ── 3. Parchear Windows Terminal settings.json ────────────────────────────────
$wtCandidates = @(
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)

$colorKeys = @('foreground','background','colorScheme')

foreach ($wtFile in $wtCandidates) {
    if (-not (Test-Path $wtFile)) { continue }

    try   { $j = Get-Content $wtFile -Raw | ConvertFrom-Json }
    catch { continue }
    if (-not $j) { continue }

    if ($j.profiles -and ($j.profiles -isnot [Array])) {

        # Limpiar defaults
        if ($j.profiles.defaults) {
            foreach ($ck in $colorKeys) {
                if ($j.profiles.defaults.PSObject.Properties.Match($ck).Count) {
                    $j.profiles.defaults.PSObject.Properties.Remove($ck) | Out-Null
                }
            }
        }

        # Limpiar perfiles CMD y PowerShell
        $profileList = @()
        if ($j.profiles.list) { $profileList = @($j.profiles.list) }

        foreach ($prof in $profileList) {
            if ($prof -isnot [pscustomobject]) { continue }
            $isCmd = ($prof.commandline -match 'cmd\.exe')        -or ($prof.name -match 'Command\s*Prompt')
            $isPs  = ($prof.commandline -match 'powershell\.exe') -or ($prof.name -match 'Windows\s*PowerShell')
            if ($isCmd -or $isPs) {
                foreach ($ck in $colorKeys) {
                    if ($prof.PSObject.Properties.Match($ck).Count) {
                        $prof.PSObject.Properties.Remove($ck) | Out-Null
                    }
                }
            }
        }
    }

    ($j | ConvertTo-Json -Depth 30) | Set-Content -Path $wtFile -Encoding UTF8
}

# ── 4. Resetear colores de la sesion actual ───────────────────────────────────
try {
    $Host.UI.RawUI.ForegroundColor = 'Gray'
    $Host.UI.RawUI.BackgroundColor = 'Black'
} catch {}

Write-Host ""
Write-Host "  Colores revertidos a los valores por defecto." -ForegroundColor Green
Write-Host "  Cierra y reabre la consola para ver los cambios." -ForegroundColor White
Write-Host ""

Read-Host "Presiona Enter para salir..."