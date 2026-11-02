# PowerShell profile installer script
Write-Host "Installing PowerShell profile from linux-unix2pwsh project..." -ForegroundColor Green

# Resolve the source profile path from the current script directory
$sourceProfile = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"

# Determine the destination profile directory by OS
if ($IsMacOS -or $IsLinux) {
    $destinationDir = "$env:HOME/.config/powershell/"
} else {
    $destinationDir = "$env:USERPROFILE/Documents/PowerShell/"
}

$destinationProfile = Join-Path $destinationDir "Microsoft.PowerShell_profile.ps1"

# Ensure the source profile exists
if (-not (Test-Path $sourceProfile)) {
    Write-Host "Error: Source profile file not found at $sourceProfile" -ForegroundColor Red
    exit 1
}

# Create destination directory if it does not exist
if (-not (Test-Path $destinationDir)) {
    Write-Host "Creating directory: $destinationDir" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $destinationDir -Force | Out-Null
}

# Backup existing profile if present
if (Test-Path $destinationProfile) {
    $backupPath = $destinationProfile + ".backup"
    Write-Host "Backing up existing profile to: $backupPath" -ForegroundColor Yellow
    Copy-Item $destinationProfile $backupPath
    Write-Host "Backup created successfully." -ForegroundColor Green
}

# Copy profile file to destination
Write-Host "Copying profile from $sourceProfile to $destinationProfile" -ForegroundColor Yellow
Copy-Item $sourceProfile $destinationProfile -Force

# Verify installation result
if (Test-Path $destinationProfile) {
    Write-Host "✅ PowerShell profile installed successfully!" -ForegroundColor Green
    Write-Host "📁 Source: $sourceProfile" -ForegroundColor Cyan
    Write-Host "📁 Destination: $destinationProfile" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To load the new profile in the current session, run:" -ForegroundColor Yellow
    Write-Host "   . `$PROFILE" -ForegroundColor White
    Write-Host ""
    Write-Host "Or restart your PowerShell session to load the new profile automatically." -ForegroundColor Yellow
} else {
    Write-Host "❌ Failed to install PowerShell profile." -ForegroundColor Red
}
