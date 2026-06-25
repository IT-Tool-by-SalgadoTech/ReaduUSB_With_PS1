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
Write-Host "  Script: 39.FontColorPowershell.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0039" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-23" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Console Customization" -ForegroundColor DarkCyan
Write-Host "  Description: Sets console color to orange or green system-wide" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

# ── Constants ──────────────────────────────────────────────────────────────────
$ORANGE_BGR = 0x0000C2FF
$GREEN_BGR  = 0x00008000
$BLACK      = 0x00000000

# ── Registry helper: set ConHost colors for one SID ───────────────────────────
function Set-ConHost-HKU {
    param(
        [string]$Sid,
        [ValidateSet('orange','green','restore')] [string]$Mode
    )

    $base = "Registry::HKEY_USERS\$Sid\Console"
    if (-not (Test-Path $base)) { New-Item -Path $base -Force | Out-Null }

    switch ($Mode) {
        'orange' {
            New-ItemProperty -Path $base -Name ScreenColors  -PropertyType DWord -Value 0x06         -Force | Out-Null
            New-ItemProperty -Path $base -Name PopupColors   -PropertyType DWord -Value 0x06         -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable6   -PropertyType DWord -Value $ORANGE_BGR  -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable0   -PropertyType DWord -Value $BLACK       -Force | Out-Null
        }
        'green' {
            New-ItemProperty -Path $base -Name ScreenColors  -PropertyType DWord -Value 0x02         -Force | Out-Null
            New-ItemProperty -Path $base -Name PopupColors   -PropertyType DWord -Value 0x02         -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable2   -PropertyType DWord -Value $GREEN_BGR   -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable0   -PropertyType DWord -Value $BLACK       -Force | Out-Null
        }
        'restore' {
            New-ItemProperty -Path $base -Name ScreenColors  -PropertyType DWord -Value 0x07         -Force | Out-Null
            New-ItemProperty -Path $base -Name PopupColors   -PropertyType DWord -Value 0xF5         -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable0   -PropertyType DWord -Value 0x00000000   -Force | Out-Null
            New-ItemProperty -Path $base -Name ColorTable7   -PropertyType DWord -Value 0x00C0C0C0   -Force | Out-Null
            foreach ($i in 0..15) {
                if ($i -ne 0 -and $i -ne 7) {
                    $ct = "ColorTable$i"
                    if (Get-ItemProperty -Path $base -Name $ct -ErrorAction SilentlyContinue) {
                        Remove-ItemProperty -Path $base -Name $ct -Force
                    }
                }
            }
        }
    }

    # Per-executable subkeys (CMD paths)
    foreach ($sub in '%SystemRoot%_system32_cmd.exe','%SystemRoot%_SysWOW64_cmd.exe') {
        $k = Join-Path $base $sub
        if (-not (Test-Path $k)) { New-Item -Path $k -Force | Out-Null }

        switch ($Mode) {
            'orange' {
                New-ItemProperty -Path $k -Name ScreenColors  -PropertyType DWord -Value 0x06        -Force | Out-Null
                New-ItemProperty -Path $k -Name PopupColors   -PropertyType DWord -Value 0x06        -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable6   -PropertyType DWord -Value $ORANGE_BGR -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable0   -PropertyType DWord -Value $BLACK      -Force | Out-Null
            }
            'green' {
                New-ItemProperty -Path $k -Name ScreenColors  -PropertyType DWord -Value 0x02        -Force | Out-Null
                New-ItemProperty -Path $k -Name PopupColors   -PropertyType DWord -Value 0x02        -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable2   -PropertyType DWord -Value $GREEN_BGR  -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable0   -PropertyType DWord -Value $BLACK      -Force | Out-Null
            }
            'restore' {
                New-ItemProperty -Path $k -Name ScreenColors  -PropertyType DWord -Value 0x07        -Force | Out-Null
                New-ItemProperty -Path $k -Name PopupColors   -PropertyType DWord -Value 0xF5        -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable0   -PropertyType DWord -Value 0x00000000  -Force | Out-Null
                New-ItemProperty -Path $k -Name ColorTable7   -PropertyType DWord -Value 0x00C0C0C0  -Force | Out-Null
                foreach ($i in 0..15) {
                    if ($i -ne 0 -and $i -ne 7) {
                        $ct = "ColorTable$i"
                        if (Get-ItemProperty -Path $k -Name $ct -ErrorAction SilentlyContinue) {
                            Remove-ItemProperty -Path $k -Name $ct -Force
                        }
                    }
                }
            }
        }
    }
}

# ── Helper: upsert a JSON property ────────────────────────────────────────────
function Upsert-Prop {
    param([object]$obj, [string]$name, $value)
    if ($obj.PSObject.Properties.Match($name).Count -eq 0) {
        Add-Member -InputObject $obj -NotePropertyName $name -NotePropertyValue $value -Force
    } else {
        $obj.$name = $value
    }
}

# ── Patch Windows Terminal settings.json ──────────────────────────────────────
function Patch-WT-Settings {
    param(
        [string] $SettingsPath,
        [ValidateSet('orange','green','restore')] [string]$Mode
    )

    try   { $j = Get-Content $SettingsPath -Raw | ConvertFrom-Json }
    catch { return }
    if (-not $j) { return }

    if (-not $j.profiles) {
        Add-Member -InputObject $j -NotePropertyName profiles -NotePropertyValue (@{ defaults=@{}; list=@() })
    }

    $defaults = $null
    $list     = @()

    if ($j.profiles -isnot [System.Array]) {
        if (-not $j.profiles.defaults) { $j.profiles.defaults = @{} }
        $defaults = $j.profiles.defaults
        if ($j.profiles.list) { $list = $j.profiles.list }
    }

    switch ($Mode) {
        'orange' {
            if ($defaults) {
                Upsert-Prop $defaults 'foreground' '#FFC200'
                Upsert-Prop $defaults 'background' '#000000'
                if ($defaults.PSObject.Properties.Match('colorScheme').Count) {
                    $defaults.PSObject.Properties.Remove('colorScheme') | Out-Null
                }
            }
            foreach ($p in $list) {
                $isCmd = ($p.commandline -match 'cmd\.exe')        -or ($p.name -match 'Command\s*Prompt')
                $isPs  = ($p.commandline -match 'powershell\.exe') -or ($p.name -match 'Windows\s*PowerShell')
                if ($isCmd -or $isPs) {
                    Upsert-Prop $p 'foreground' '#FFC200'
                    Upsert-Prop $p 'background' '#000000'
                    if ($p.PSObject.Properties.Match('colorScheme').Count) {
                        $p.PSObject.Properties.Remove('colorScheme') | Out-Null
                    }
                }
            }
        }
        'green' {
            if ($defaults) {
                Upsert-Prop $defaults 'foreground' '#008000'
                Upsert-Prop $defaults 'background' '#000000'
                if ($defaults.PSObject.Properties.Match('colorScheme').Count) {
                    $defaults.PSObject.Properties.Remove('colorScheme') | Out-Null
                }
            }
            foreach ($p in $list) {
                $isCmd = ($p.commandline -match 'cmd\.exe')        -or ($p.name -match 'Command\s*Prompt')
                $isPs  = ($p.commandline -match 'powershell\.exe') -or ($p.name -match 'Windows\s*PowerShell')
                if ($isCmd -or $isPs) {
                    Upsert-Prop $p 'foreground' '#008000'
                    Upsert-Prop $p 'background' '#000000'
                    if ($p.PSObject.Properties.Match('colorScheme').Count) {
                        $p.PSObject.Properties.Remove('colorScheme') | Out-Null
                    }
                }
            }
        }
        'restore' {
            if ($defaults) {
                foreach ($n in 'foreground','background','colorScheme') {
                    if ($defaults.PSObject.Properties.Match($n).Count) {
                        $defaults.PSObject.Properties.Remove($n) | Out-Null
                    }
                }
            }
            foreach ($p in $list) {
                foreach ($n in 'foreground','background','colorScheme') {
                    if ($p.PSObject.Properties.Match($n).Count) {
                        $p.PSObject.Properties.Remove($n) | Out-Null
                    }
                }
            }
        }
    }

    ($j | ConvertTo-Json -Depth 30) | Set-Content -Path $SettingsPath -Encoding UTF8
}

# ── Apply to all loaded user profiles ─────────────────────────────────────────
function Apply-All {
    param([ValidateSet('orange','green','restore')] [string]$Mode)

    $loadedSids = @()
    $uKeys = Get-ChildItem Registry::HKEY_USERS | Where-Object {
        $_.PSChildName -match '^S-1-5-21-.*$' -and $_.PSChildName -notmatch '_Classes$'
    }
    foreach ($k in $uKeys) { $loadedSids += $k.PSChildName }

    foreach ($sid in $loadedSids) { Set-ConHost-HKU -Sid $sid -Mode $Mode }

    Get-Process WindowsTerminal -ErrorAction SilentlyContinue | Stop-Process -Force | Out-Null

    $profileRoots = @()
    foreach ($sid in $loadedSids) {
        try {
            $pi = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction Stop
            if ($pi.ProfileImagePath -and (Test-Path $pi.ProfileImagePath)) {
                $profileRoots += $pi.ProfileImagePath
            }
        } catch {}
    }
    $profileRoots = $profileRoots | Select-Object -Unique

    foreach ($root in $profileRoots) {
        $cand = @(
            (Join-Path $root 'AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
            (Join-Path $root 'AppData\Local\Microsoft\Windows Terminal\settings.json'),
            (Join-Path $root 'AppData\Local\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json')
        )
        foreach ($f in $cand) {
            if (Test-Path $f) { Patch-WT-Settings -SettingsPath $f -Mode $Mode }
        }
    }
}

# ── Interactive menu ───────────────────────────────────────────────────────────
function Show-Menu {
    param([switch]$ClearFirst)
    if ($ClearFirst) { Clear-Host }
    Write-Host ""
    Write-Host "  === Console Colors - All-in-One ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  1) Orange (bright)  [#FFC200]" -ForegroundColor Yellow
    Write-Host "  2) Dark Green       [#008000]" -ForegroundColor Green
    Write-Host "  3) Restore defaults" -ForegroundColor White
    Write-Host "  4) Exit" -ForegroundColor DarkGray
    Write-Host ""
    $c = Read-Host "  Choose [1-4]"
    switch ($c) {
        '1' { Apply-All -Mode 'orange';  Write-Host "  Aplicado: Orange. Reabre las consolas." -ForegroundColor Yellow }
        '2' { Apply-All -Mode 'green';   Write-Host "  Aplicado: Green. Reabre las consolas."  -ForegroundColor Green  }
        '3' { Apply-All -Mode 'restore'; Write-Host "  Restaurado. Reabre las consolas."        -ForegroundColor White  }
        '4' { return }
        default { Write-Host "  Opcion invalida." -ForegroundColor Red }
    }
    Pause
    Show-Menu -ClearFirst
}

# ── Entry point ───────────────────────────────────────────────────────────────
Show-Menu

Read-Host "Presiona Enter para salir..."