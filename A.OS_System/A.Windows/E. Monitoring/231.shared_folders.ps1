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
Write-Host "  Script: 231.shared_folders.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0231" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all active SMB shared folders on the machine, excluding the IPC$ administrative share" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $shares = Get-SmbShare | Where-Object { $_.Name -ne 'IPC$' } |
        Select-Object Name, Path, Description, ShareState, FolderEnumerationMode

    if ($shares) {
        Write-Host "  SUCCESS: $($shares.Count) shared folder(s) found." -ForegroundColor Green
        Write-Host ""
        $shares | Format-Table -AutoSize
    } else {
        Write-Host "  INFO: No shared folders found (excluding IPC$)." -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to retrieve shared folders. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."