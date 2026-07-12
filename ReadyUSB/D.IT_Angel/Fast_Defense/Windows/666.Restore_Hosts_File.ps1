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
Write-Host "  IT-Tool by ITTOOL" -ForegroundColor Cyan
Write-Host "  Script: 666.Restore_Hosts_File.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0666" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Admin & Security" -ForegroundColor DarkCyan
Write-Host "  Description: Backs up the current hosts file then restores it to the clean Windows default to undo DNS hijack entries" -ForegroundColor DarkCyan
Write-Host "  (c) 2026 ITTOOL - All Rights Reserved" -ForegroundColor DarkCyan
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

$hostsPath = Join-Path $env:SystemRoot "System32\drivers\etc\hosts"

$defaultHosts = @"
# Copyright (c) 1993-2009 Microsoft Corp.
#
# This is a sample HOSTS file used by Microsoft TCP/IP for Windows.
#
# This file contains the mappings of IP addresses to host names. Each
# entry should be kept on an individual line. The IP address should
# be placed in the first column followed by the corresponding host name.
# The IP address and the host name should be separated by at least one
# space.
#
# Additionally, comments (such as these) may be inserted on individual
# lines or following the machine name denoted by a '#' symbol.
#
# For example:
#
#      102.54.94.97     rhino.acme.com          # source server
#       38.25.63.10     x.acme.com              # x client host

# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@

if (-not (Test-Path $hostsPath)) {
    Write-Host "  ERROR: hosts file not found at expected location." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$stamp  = Get-Date -Format "yyyyMMdd_HHmmss"
$backup = "$hostsPath.bak_$stamp"

try {
    Copy-Item -Path $hostsPath -Destination $backup -Force -ErrorAction Stop
    Write-Host ("  Backup created: {0}" -f $backup) -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Could not back up the current hosts file. Aborting." -ForegroundColor Red
    Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    Set-Content -Path $hostsPath -Value $defaultHosts -Encoding ASCII -Force -ErrorAction Stop
    Write-Host "  hosts file restored to clean Windows default." -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Could not write the default hosts file." -ForegroundColor Red
    Write-Host ("  " + $_.Exception.Message) -ForegroundColor Yellow
    Write-Host "  The previous content is preserved in the backup above." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

try {
    Clear-DnsClientCache
    Write-Host "  DNS client cache flushed." -ForegroundColor Green
} catch {
    Write-Host "  WARNING: Could not flush DNS cache." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."