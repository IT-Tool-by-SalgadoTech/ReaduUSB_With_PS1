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
Write-Host "  Script: 38.ResetPowershell.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0038" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Console Customization" -ForegroundColor DarkCyan
Write-Host "  Description: Resets PowerShell console colors, profiles, and Windows Terminal settings" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ============================================================
#  Full Console Reset Script
#  Limpia colores del registro, Windows Terminal y perfiles PS
# ============================================================

#region 1 — Propiedades de color a eliminar
$colorProps = @('ScreenColors', 'PopupColors') + (0..15 | ForEach-Object { "ColorTable$_" })
#endregion

#region 2 — Limpiar claves de registro de consola
$registryPaths = @(
    'HKCU:\Console',
    'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console'
)

foreach ($regPath in $registryPaths) {
    if (Test-Path $regPath) {
        # Limpiar subclaves recursivamente
        Get-ChildItem $regPath -Recurse | ForEach-Object {
            $keyPath = $_.PSPath
            foreach ($prop in $colorProps) {
                Remove-ItemProperty -Path $keyPath -Name $prop -ErrorAction SilentlyContinue
            }
        }
        # Limpiar la clave raíz también
        foreach ($prop in $colorProps) {
            Remove-ItemProperty -Path $regPath -Name $prop -ErrorAction SilentlyContinue
        }
    }
}
#endregion

#region 3 — Eliminar claves específicas de PowerShell en el registro
$psConsoleKeys = @(
    'HKCU:\Console\%SystemRoot%_system32_powershell.exe',
    'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe',
    'HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe'
)

foreach ($key in $psConsoleKeys) {
    if (Test-Path $key) {
        Remove-Item $key -Recurse -Force
    }
}
#endregion

#region 4 — Eliminar settings.json de Windows Terminal
$wtSettingsPaths = @(
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"
)

foreach ($settingsFile in $wtSettingsPaths) {
    if (Test-Path $settingsFile) {
        Remove-Item $settingsFile -Force -ErrorAction SilentlyContinue
    }
}
#endregion

#region 5 — Vaciar perfiles de PowerShell (con backup)
$profilePaths = @(
    $PROFILE,
    $PROFILE.CurrentUserAllHosts,
    $PROFILE.AllUsersCurrentHost,
    $PROFILE.AllUsersAllHosts
) | Select-Object -Unique | Where-Object { $_ }

foreach ($pf in $profilePaths) {
    if (Test-Path $pf) {
        try {
            $timestamp  = Get-Date -Format 'yyyyMMddHHmmss'
            $backupPath = "$pf.bak_$timestamp"
            Copy-Item $pf $backupPath -Force
            Clear-Content $pf -ErrorAction SilentlyContinue
            Set-Content $pf "" -Encoding UTF8
        }
        catch {
            # Ignorar errores por archivo bloqueado o sin permisos
        }
    }
}
#endregion

#region 6 — Restablecer colores de la consola y mensaje final
try {
    $Host.UI.RawUI.ForegroundColor = 'Gray'
    $Host.UI.RawUI.BackgroundColor = 'Black'
} catch {}

Write-Host ""
Write-Host "  Reset completo: registro limpiado, Windows Terminal reseteado, perfiles PS desactivados." -ForegroundColor Green
Write-Host "  Cierra TODAS las consolas y vuelve a abrirlas para aplicar los cambios." -ForegroundColor White
Write-Host ""
#endregion
Read-Host "Presiona Enter para salir..."