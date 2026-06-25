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
Write-Host "  Script: Toggle-VMwareServices.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0085" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Virtualization" -ForegroundColor DarkCyan
Write-Host "  Description: Stops and disables, or restores, VMware services interactively" -ForegroundColor DarkCyan
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

Write-Host ""
Write-Host "  Select an option:" -ForegroundColor Cyan
Write-Host "    [1] Stop and disable all VMware services"
Write-Host "    [2] Restore VMware services (set to Manual and start)"
Write-Host ""
$choice = Read-Host "  Enter your choice (1 or 2)"
Write-Host ""
if ($choice -eq '1') {
    $mode = 'stop'
} elseif ($choice -eq '2') {
    $mode = 'start'
} else {
    Write-Host "  ERROR: Invalid option. Please run the script again." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# Lista de servicios comunes de VMware que suelen instalarse en Horizon/Tools
$vmwareServices = @(
    'VMAuthdService',           # VMware Workstation/Tools auth
    'VMTools',                  # nombre posible, algunos sistemas usan otros
    'VMwareViewAgent',          # ejemplo de nombre; puede variar
    'VMwareGmsvc',              # VMware Authorization Service (varia)
    'VMwareGraphicsService',
    'VMware USB Arbitration Service','VMUSBArbService',
    'VMwareViewAgent', 'VMwareViewComposerGA', 'VMwareViewComposer', 'VMwareViewPersona',
    'VMwareViewLogon'           # si existen
)

# Detectar nombres reales que contengan 'VMware' (mas seguro que lista fija)
$detected = Get-Service | Where-Object { $_.Name -like '*VMware*' -or $_.DisplayName -like '*VMware*' } |
            Select-Object -ExpandProperty Name -ErrorAction SilentlyContinue
$targets = ($vmwareServices + $detected) | Sort-Object -Unique

if (-not $targets -or $targets.Count -eq 0) {
    Write-Host "No se encontraron servicios de VMware en este equipo."
    return
}

if ($mode -eq 'stop') {
    foreach ($s in $targets) {
        try {
            $svc = Get-Service -Name $s -ErrorAction Stop
            if ($svc.Status -ne 'Stopped') {
                Write-Host "Stopping $s..."
                Stop-Service -Name $s -Force -ErrorAction Stop
            }
            Write-Host "Setting $s startup to Disabled..."
            Set-Service -Name $s -StartupType Disabled
        } catch {
            Write-Host "No encontrado o error con $($s): $($_.Exception.Message)"
        }
    }
    Write-Host "Hecho. Reinicia el PC para asegurar que los controladores se descarguen."
} else {
    foreach ($s in $targets) {
        try {
            Write-Host "Setting $s startup to Manual and starting..."
            Set-Service -Name $s -StartupType Manual
            Start-Service -Name $s -ErrorAction SilentlyContinue
        } catch {
            Write-Host "No encontrado o error con $($s): $($_.Exception.Message)"
        }
    }
    Write-Host "Hecho: servicios intentados para restaurar."
}

Write-Host ""
Read-Host "Press Enter to exit..."