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
Write-Host "  Script: Apps_And_Locations.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0027" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > System Info" -ForegroundColor DarkCyan
Write-Host "  Description: Lists installed applications with install date and location, sorted by date" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$paths = @(
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
)

Get-ItemProperty $paths -ErrorAction SilentlyContinue |
Where-Object { $_.DisplayName -and $_.InstallDate } |
ForEach-Object {
    $raw = $_.InstallDate.ToString().Trim()
    $dt = $null
    if ($raw -match '^\d{8}$') {
        try { $dt = [datetime]::ParseExact($raw, 'yyyyMMdd', $null) } catch { $dt = $null }
    } else {
        try { $dt = [datetime]::Parse($raw) } catch { $dt = $null }
    }
    [pscustomobject]@{
        InstallDate     = $(if ($dt) { $dt.ToString('yyyy-MM-dd') } else { $raw })
        DisplayName     = $_.DisplayName
        InstallLocation = $_.InstallLocation
    }
} |
Sort-Object InstallDate -Descending |
Format-List

Read-Host "Presiona Enter para salir..."