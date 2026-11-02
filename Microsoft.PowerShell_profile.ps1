# === Linux/Unix to PowerShell Profile ===
# Main profile file that loads modular components
# This file should be installed to your PowerShell profile location

# Get the directory where this profile script is located
$ProfileRoot = Split-Path -Parent $PSCommandPath
$ModulesDir = Join-Path $ProfileRoot "modules"

# Suppress Homebrew auto update
$env:HOMEBREW_NO_AUTO_UPDATE = "1"

Write-Host "`n🚀 Loading PowerShell Profile with Unix-like enhancements..." -ForegroundColor Cyan

# Load core modules first (in order)
$coreModules = @(
    "Core.Config",      # System environment configuration
    "Core.Safety",      # Safety checks and dangerous command detection  
    "Core.Hints"        # Hint and tip functions
)

foreach ($module in $coreModules) {
    $modulePath = Join-Path $ModulesDir "$module.psm1"
    if (Test-Path $modulePath) {
        Import-Module $modulePath -Global
        Write-Host "   ✅ Loaded: $module" -ForegroundColor Gray
    } else {
        Write-Warning "Module not found: $modulePath"
    }
}

# Load command modules
$commandModules = @(
    "Commands.Basic"    # Basic Unix command mappings (ls, cd, pwd, cat, ps)
)

foreach ($module in $commandModules) {
    $modulePath = Join-Path $ModulesDir "$module.psm1"
    if (Test-Path $modulePath) {
        Import-Module $modulePath -Global
        Write-Host "   ✅ Loaded: $module" -ForegroundColor Gray
    }
}

# Display welcome message in interactive sessions
if ($host.Name -eq "ConsoleHost") {
    Write-Host "`n🚀 Welcome to PowerShell with Unix-like enhancements!" -ForegroundColor Green
    Write-Host "   Type 'helpunix <command>' for help with any command" -ForegroundColor Cyan
    
    if ($IsWindows) {
        Write-Host "   💡 Windows sudo available: try 'sudo notepad'" -ForegroundColor Cyan
    }
    
    Write-Host "   🌐 Network issues? Try proxies:" -ForegroundColor Cyan
    Write-Host "      HTTP: http://localhost:7890" -ForegroundColor Gray
    Write-Host "      SOCKS: socks://localhost:7890" -ForegroundColor Gray
}
