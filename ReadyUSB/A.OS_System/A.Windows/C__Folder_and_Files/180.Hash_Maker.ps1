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
Write-Host "  Script: 179.Hash_Maker.ps1" -ForegroundColor DarkCyan
Write-Host "  ScriptID: ST-WIN-0179" -ForegroundColor Cyan
Write-Host "  Version: 1.1" -ForegroundColor DarkCyan
Write-Host "  Date: 2025-05-22" -ForegroundColor DarkCyan
Write-Host "  Category: Windows > Files & Folders" -ForegroundColor DarkCyan
Write-Host "  Description: Computes and displays the cryptographic hash of a file using a user-selected algorithm (MD5, SHA1, SHA256, SHA384, SHA512)" -ForegroundColor DarkCyan
Write-Host "  (c) 2025 SalgadoTech - All Rights Reserved" -ForegroundColor DarkCyan
Write-Host "  Unauthorized distribution prohibited" -ForegroundColor DarkCyan
Write-Host "  ==================================================================" -ForegroundColor White
Write-Host ""

$filePath  = Read-Host "Enter file path"
$algorithm = (Read-Host "Algorithm (MD5 / SHA1 / SHA256 / SHA384 / SHA512)").ToUpper()

if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
    Write-Host "  ERROR: File not found: '$filePath'" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit..."
    exit 1
}

if ($algorithm -in "MD5", "SHA1", "SHA256", "SHA384", "SHA512") {
    try {
        $result = Get-FileHash -LiteralPath $filePath -Algorithm $algorithm
        Write-Host "  SUCCESS: Hash computed." -ForegroundColor Green
        Write-Host ""
        $result | Format-List Algorithm, Hash, Path
    } catch {
        Write-Host "  ERROR: Failed to compute hash. $_" -ForegroundColor Red
    }
} else {
    Write-Host "  ERROR: Invalid algorithm. Choose MD5, SHA1, SHA256, SHA384, or SHA512." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit..."