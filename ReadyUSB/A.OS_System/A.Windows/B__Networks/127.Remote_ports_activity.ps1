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
Write-Host "  Script: 127.Remote_ports_activity.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0127" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Displays all established TCP connections to remote addresses with their owning process" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$cn = Get-NetTCPConnection -State Established | Where-Object {
    $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne $_.LocalAddress
}

if (-not $cn) {
    Write-Host "  No established remote TCP connections found." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 0
}

$cn | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State,
    @{Name="PID";     Expression={$_.OwningProcess}},
    @{Name="Process"; Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}} |
    Format-Table -AutoSize

Write-Host "  Remote connections listed successfully." -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to exit..."