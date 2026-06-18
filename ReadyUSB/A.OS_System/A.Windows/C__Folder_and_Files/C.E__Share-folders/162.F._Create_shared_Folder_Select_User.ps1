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
Write-Host "  Script: 162.F._Create_shared_Folder_Select_User.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0162" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Shared Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Creates a network share for a folder and grants access to an existing or newly created local user, with optional Everyone read access" -ForegroundColor DarkCyan
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

$folderPath = Read-Host "Enter folder path to share (e.g. D:\Apps)"

if (-not (Test-Path -LiteralPath $folderPath)) {
    Write-Host "  ERROR: Folder not found: '$folderPath'" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$shareNameDefault = Split-Path $folderPath -Leaf
$shareName = Read-Host "Share name (press Enter to use '$shareNameDefault')"
if ([string]::IsNullOrWhiteSpace($shareName)) { $shareName = $shareNameDefault }

$mode = Read-Host "Press 1 for existing user, 2 to create a new local user"

if ($mode -eq '2') {
    $newUser = Read-Host "Enter new local username"
    if ([string]::IsNullOrWhiteSpace($newUser)) {
        Write-Host "  ERROR: Username cannot be empty." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
    try {
        if (Get-LocalUser -Name $newUser -ErrorAction Stop) {
            Write-Host "  ERROR: User '$newUser' already exists." -ForegroundColor Red
            Write-Host ""
            Read-Host "Press Enter to exit..."
            exit 1
        }
    } catch {}

    $pass1 = Read-Host "Enter password" -AsSecureString
    $pass2 = Read-Host "Confirm password" -AsSecureString

    if (([PSCredential]::new('u', $pass1).GetNetworkCredential().Password) -ne ([PSCredential]::new('u', $pass2).GetNetworkCredential().Password)) {
        Write-Host "  ERROR: Passwords do not match." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }

    New-LocalUser -Name $newUser -Password $pass1 -PasswordNeverExpires:$true -AccountNeverExpires:$true | Out-Null
    try { Add-LocalGroupMember -Group "Users" -Member $newUser -ErrorAction SilentlyContinue } catch {}
    $account = "$env:COMPUTERNAME\$newUser"
    Write-Host "  SUCCESS: Local user '$newUser' created." -ForegroundColor Green

} elseif ($mode -eq '1') {
    $inputName = Read-Host "Enter existing username (DOMAIN\User or COMPUTER\User)"
    if ([string]::IsNullOrWhiteSpace($inputName)) {
        Write-Host "  ERROR: Username cannot be empty." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
    try {
        $null = ([System.Security.Principal.NTAccount]$inputName).Translate([System.Security.Principal.SecurityIdentifier]).Value
    } catch {
        Write-Host "  ERROR: Account '$inputName' not found." -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit..."
        exit 1
    }
    $account = $inputName
} else {
    Write-Host "  ERROR: Invalid option. Choose 1 or 2." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

# Enable LanmanServer (File Sharing)
Set-Service -Name LanmanServer -StartupType Automatic
Start-Service -Name LanmanServer

# Enable SMB firewall rules
$smbRules = Get-NetFirewallRule -Name 'FPS-SMB-In-TCP', 'FPS-SMB-In-UDP' -ErrorAction SilentlyContinue
if ($smbRules) {
    Enable-NetFirewallRule -Name ($smbRules | Select-Object -ExpandProperty Name) | Out-Null
} else {
    $fallback = Get-NetFirewallRule -ErrorAction SilentlyContinue | Where-Object { $_.DisplayGroup -match 'File and Printer|Uso compartido de archivos' }
    if ($fallback) { $fallback | Enable-NetFirewallRule | Out-Null }
}

# Create or update the share
$existingShare = Get-SmbShare -Name $shareName -ErrorAction SilentlyContinue
if ($existingShare) {
    try {
        Grant-SmbShareAccess -Name $shareName -AccountName $account -AccessRight Full -Force | Out-Null
        Write-Host "  SUCCESS: Full access granted to '$account' on existing share '$shareName'." -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Could not grant access on existing share. $_" -ForegroundColor Red
    }
} else {
    New-SmbShare -Name $shareName -Path $folderPath -CachingMode None -FullAccess $account | Out-Null
    Write-Host "  SUCCESS: Share '$shareName' created at '$folderPath'." -ForegroundColor Green
}

# Optional Everyone read
$everyoneAnswer = Read-Host "Grant Everyone READ access on the share? (Y/N, default Y)"
if ([string]::IsNullOrWhiteSpace($everyoneAnswer) -or $everyoneAnswer.ToUpper() -eq 'Y') {
    try {
        Grant-SmbShareAccess -Name $shareName -AccountName 'Everyone' -AccessRight Read -Force | Out-Null
        Write-Host "  SUCCESS: Everyone READ access granted." -ForegroundColor Green
    } catch {
        Write-Host "  ERROR: Could not grant Everyone READ. $_" -ForegroundColor Red
    }
}

# Set NTFS permissions
$acl  = Get-Acl -LiteralPath $folderPath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    $account, "Modify,Synchronize", "ContainerInherit, ObjectInherit", "None", "Allow"
)
$acl.SetAccessRule($rule)
Set-Acl -LiteralPath $folderPath -AclObject $acl

$unc = "\\$($env:COMPUTERNAME)\$shareName"
Write-Host ""
Write-Host "  Share path : $unc" -ForegroundColor Cyan
Write-Host "  Account    : $account (Share Full, NTFS Modify)" -ForegroundColor Cyan

Write-Host ""
Read-Host "Press Enter to exit..."