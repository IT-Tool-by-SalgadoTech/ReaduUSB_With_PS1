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
Write-Host "  Script: Run_Python_Document.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0298" -ForegroundColor Cyan
Write-Host "  Version: 1.0" -ForegroundColor DarkCyan
Write-Host "  Date: 2026-06-17" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Tools" -ForegroundColor DarkCyan
Write-Host "  Description: Prompts for a Python document name and runs it from the Desktop folder." -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""
$py_Document = Read-Host "Enter Document_name.py"
cd $HOME\Desktop; python ".\$py_Document"

Write-Host ""
Read-Host "Press Enter to exit..."