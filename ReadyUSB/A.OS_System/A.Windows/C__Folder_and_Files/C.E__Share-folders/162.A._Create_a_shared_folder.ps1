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
Write-Host "  Script: 162.A._Create_a_shared_folder.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0162" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Shared Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Creates a network share for a specified folder and grants full access to a given user" -ForegroundColor DarkCyan
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

$folderPath  = Read-Host "Enter folder path to share"
$shareName   = Read-Host "Enter shared name"
$userName    = Read-Host "Enter username to grant access"

net share "$shareName=$folderPath" /grant:"$userName,full" | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "  SUCCESS: Folder '$folderPath' shared as '$shareName' with full access for '$userName'." -ForegroundColor Green
} else {
    Write-Host "  ERROR: Failed to create shared folder '$shareName'." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."