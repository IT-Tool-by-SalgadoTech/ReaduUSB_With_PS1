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
Write-Host "  Script: 82.Check_acssess_to_a_local_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0082" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Tests TCP connectivity to a specified port on localhost to verify if it is accessible" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$port = Read-Host "  Enter port to test"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    Write-Host "  Testing connectivity to localhost:$port ..." -ForegroundColor Cyan
    $result = Test-NetConnection -ComputerName localhost -Port $port
    $result | Format-List

    if ($result.TcpTestSucceeded) {
        Write-Host "  Port $port is accessible." -ForegroundColor Green
    } else {
        Write-Host "  Port $port is not accessible." -ForegroundColor Red
    }
} catch {
    Write-Host "  ERROR: Test failed." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."