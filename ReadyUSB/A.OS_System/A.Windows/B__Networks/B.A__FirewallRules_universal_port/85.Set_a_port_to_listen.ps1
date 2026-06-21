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
Write-Host "  Script: 84.Set_a_port_to_listen.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0084" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Firewall & Ports" -ForegroundColor DarkCyan
Write-Host "  Description: Starts a temporary TCP listener on a specified port and waits for one incoming connection, then exits" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$port = Read-Host "  Enter port to listen on"

if ($port -notmatch '^\d+$') {
    Write-Host "  ERROR: Invalid port number." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, [int]$port)
    $listener.Start()
    Write-Host "  Listening on port $port... (waiting for one connection)" -ForegroundColor Cyan
    Write-Host "  Press Ctrl+C to cancel." -ForegroundColor Yellow

    $client = $listener.AcceptTcpClient()
    $remote = $client.Client.RemoteEndPoint
    Write-Host "  Connection received from $remote." -ForegroundColor Green
    $client.Close()
    $listener.Stop()
    Write-Host "  Listener stopped." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to start listener on port $port." -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    try { $listener.Stop() } catch {}
}

Write-Host ""
Read-Host "Press Enter to exit..."