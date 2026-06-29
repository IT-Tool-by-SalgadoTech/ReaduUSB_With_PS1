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
Write-Host "  Script: 226.Check_HID_Dispositives.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0226" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Lists all present HID keyboard and mouse devices with their VID and PID values" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$results = Get-PnpDevice -PresentOnly |
    Where-Object { $_.InstanceId -match 'HID\\' -or $_.Class -eq 'HIDClass' } |
    Where-Object { $_.FriendlyName -match 'keyboard|mouse|rat.n|teclado' -or $_.Class -eq 'Keyboard' -or $_.Class -eq 'Mouse' } |
    ForEach-Object {
        if ($_.InstanceId -match 'VID_([0-9A-F]{4}).*PID_([0-9A-F]{4})') {
            [pscustomobject]@{
                Name       = $_.FriendlyName
                Class      = $_.Class
                VID        = $Matches[1]
                PID        = $Matches[2]
                InstanceId = $_.InstanceId
                Status     = $_.Status
            }
        }
    } | Sort-Object Class, Name

if ($results) {
    Write-Host "  SUCCESS: HID devices found." -ForegroundColor Green
    Write-Host ""
    $results | Format-Table -AutoSize
} else {
    Write-Host "  INFO: No HID keyboard or mouse devices found." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit..."