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
Write-Host "  Script: 191.Encrypt_Decrypt_Files.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0191" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Encrypts or decrypts a file using EFS (Windows Encrypting File System) or CMS (certificate-based message encryption)" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$rawMode  = (Read-Host "Mode (E/Encrypt or D/Decrypt)").Trim().ToUpper()
$mode     = if ($rawMode.StartsWith("E")) { "E" } elseif ($rawMode.StartsWith("D")) { "D" } else { $rawMode }

if ($mode -notin "E", "D") {
    Write-Host "  ERROR: Invalid mode. Enter E (Encrypt) or D (Decrypt)." -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

$filePath = Read-Host "Enter file path"

if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
    Write-Host "  ERROR: File not found: '$filePath'" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if ($mode -eq "E") {
    $method = (Read-Host "Encryption method (EFS / CMS)").Trim().ToUpper()

    if ($method -eq "EFS") {
        cipher /E /A /I /F /H "$filePath" | Out-Host
        Write-Host "  SUCCESS: File encrypted with EFS." -ForegroundColor Green

    } elseif ($method -eq "CMS") {
        $cert = Get-ChildItem Cert:\CurrentUser\My |
            Where-Object { $_.EnhancedKeyUsageList.FriendlyName -contains "Document Encryption" } |
            Select-Object -First 1

        if (-not $cert) {
            $cert = New-SelfSignedCertificate `
                -Subject "CN=IT-Tool File Encrypt" `
                -CertStoreLocation "Cert:\CurrentUser\My" `
                -KeyUsage KeyEncipherment, DataEncipherment `
                -Type DocumentEncryptionCert
        }

        $outputFile = "$filePath.p7m"
        try {
            Protect-CmsMessage -To $cert -Path $filePath -OutFile $outputFile
            Write-Host "  SUCCESS: File encrypted with CMS -> '$outputFile'" -ForegroundColor Green
            Write-Host "  To decrypt: run this script again, choose Mode=D, and enter the full .p7m path." -ForegroundColor Cyan
        } catch {
            Write-Host "  ERROR: CMS encryption failed. $_" -ForegroundColor Red
        }

    } else {
        Write-Host "  ERROR: Invalid method. Use EFS or CMS." -ForegroundColor Red
    }

} elseif ($mode -eq "D") {
    if ($filePath.ToLower().EndsWith(".p7m")) {
        $outputFile = Read-Host "Enter output file path (e.g. C:\Users\user\Desktop\file.txt)"
        try {
            (Unprotect-CmsMessage -Path $filePath) | Set-Content -LiteralPath $outputFile -Encoding UTF8
            Write-Host "  SUCCESS: CMS decrypted -> '$outputFile'" -ForegroundColor Green
        } catch {
            Write-Host "  ERROR: CMS decryption failed. $_" -ForegroundColor Red
        }
    } else {
        cipher /D /A "$filePath" | Out-Host
        Write-Host "  SUCCESS: EFS decryption applied." -ForegroundColor Green
    }
}

Write-Host ""
Read-Host "Press Enter to exit..."