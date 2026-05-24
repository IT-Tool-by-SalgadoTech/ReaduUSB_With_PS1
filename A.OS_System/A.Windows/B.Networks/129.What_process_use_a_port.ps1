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
Write-Host "  Script: 129.What_process_use_a_port.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0129" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Networks" -ForegroundColor DarkCyan
Write-Host "  Description: Prompts for a port number and identifies the process currently using it via TCP" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$port = Read-Host "Enter port number to inspect"

$conn = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue

if ($conn) {
    $proc = Get-Process -Id $conn.OwningProcess -ErrorAction SilentlyContinue
    if ($proc) {
        $proc | Select-Object Id, ProcessName, CPU, StartTime | Format-Table -AutoSize
        Write-Host "  Process identified on port $port." -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Could not resolve process for port $port." -ForegroundColor Red
    }
} else {
    Write-Host "  ERROR: No TCP connection found on port $port." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."