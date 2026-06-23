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
Write-Host "  Script: 248.VMware_Check.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0248" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Monitoring" -ForegroundColor DarkCyan
Write-Host "  Description: Detects VMware services on the system and displays their name, status, startup type, and executable path" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

try {
    $svcs = Get-Service | Where-Object { $_.Name -like '*VMware*' -or $_.DisplayName -like '*VMware*' }

    if (-not $svcs) {
        Write-Host "  INFO: VMware is not installed or no VMware services were found." -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 0
    }

    $results = $svcs | ForEach-Object {
        $s   = $_
        $wmi = Get-CimInstance -ClassName Win32_Service -Filter ("Name='{0}'" -f $s.Name) -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            Name        = $s.Name
            DisplayName = $s.DisplayName
            Status      = $s.Status
            StartType   = $s.StartType
            Path        = if ($wmi) { $wmi.PathName } else { '(not accessible)' }
        }
    }

    Write-Host "  SUCCESS: $($results.Count) VMware service(s) found." -ForegroundColor Green
    Write-Host ""
    $results | Format-Table -AutoSize
} catch {
    Write-Host "  ERROR: Failed to retrieve VMware services. $_" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."