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
Write-Host "  Script: 126.OpenConections.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0126" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all established TCP connections with process name, local/remote address, and adapter; saves report to Desktop and opens it in Notepad" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $adapters     = Get-NetIPInterface | Where-Object { $_.ConnectionState -eq 'Connected' } |
                    Select-Object ifIndex, InterfaceAlias
    $connections  = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' } |
                    Select-Object LocalAddress, RemoteAddress, State, OwningProcess
    $defaultRoute = Get-NetRoute -DestinationPrefix '0.0.0.0/0' | Sort-Object RouteMetric | Select-Object -First 1
    $adapter      = $adapters | Where-Object { $_.ifIndex -eq $defaultRoute.ifIndex }

    $output = @()
    foreach ($conn in $connections) {
        $proc    = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
        $output += ('[{0}] {1} ({2}) --> {3} (via: {4})' -f
            $proc.ProcessName,
            $conn.LocalAddress,
            $conn.State,
            $conn.RemoteAddress,
            $adapter.InterfaceAlias)
    }

    $reportPath = "$env:USERPROFILE\Desktop\NetReport.txt"
    $output | Out-File -Encoding ASCII $reportPath
    Write-Host "  Report saved to: $reportPath" -ForegroundColor Green
    notepad $reportPath

} catch {
    Write-Host "  ERROR: Failed to retrieve network connections." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."