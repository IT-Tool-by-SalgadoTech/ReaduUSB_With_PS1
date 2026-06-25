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
Write-Host "  Script: 652.B._Enable_SystemProtection.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0652" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Restore" -ForegroundColor DarkCyan
Write-Host "  Description: Enables System Protection for drive C:" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Verificar privilegios de administrador ────────────────────────────────────
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = [Security.Principal.WindowsPrincipal]$currentUser
$isAdmin     = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "  ERROR: Este script requiere privilegios de administrador." -ForegroundColor Red
    Write-Host "  Cierra esta ventana, haz clic derecho en el script y selecciona" -ForegroundColor Yellow
    Write-Host "  'Ejecutar con PowerShell como administrador'." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Presiona Enter para salir..."
    exit 1
}

# ── Habilitar proteccion del sistema en C:\ ───────────────────────────────────
Write-Host "  Enabling System Protection on C:\..." -ForegroundColor Cyan
Enable-ComputerRestore -Drive "C:\"
Write-Host "Protection system successfully enabled.." -ForegroundColor Green
Write-Host ""
Read-Host "Press ENTER to exit..."