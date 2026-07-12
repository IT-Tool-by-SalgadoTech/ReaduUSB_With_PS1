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
Write-Host "  Script: 674.Check_VID_PID_Dispositives.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0674" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all present PnP devices that expose a VID and PID in their instance ID" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$pattern = [regex]'VID_([0-9A-F]{4})&PID_([0-9A-F]{4})'

$results = Get-PnpDevice -PresentOnly |
    Where-Object { $_.InstanceId -match 'VID_' } |
    ForEach-Object {
        $m = $pattern.Match($_.InstanceId)
        if ($m.Success) {
            [pscustomobject]@{
                Name = $_.FriendlyName
                VID  = $m.Groups[1].Value
                PID  = $m.Groups[2].Value
            }
        }
    }

if ($results) {
    Write-Host "  SUCCESS: Devices with VID/PID found." -ForegroundColor Green
    Write-Host ""
    $results | Format-Table -AutoSize
} else {
    Write-Host "  INFO: No PnP devices with VID/PID found." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."