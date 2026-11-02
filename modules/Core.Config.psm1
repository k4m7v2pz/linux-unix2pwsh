# === System Environment Configuration Module ===
# Disable Homebrew auto update
$env:HOMEBREW_NO_AUTO_UPDATE = "1"

# Get the profile root directory (parent of modules directory)
$ProfileRoot = Split-Path -Parent $PSScriptRoot

# Load platform-specific environment configuration from JSON
$platform = $PSVersionTable.Platform
$configFileName = switch ($platform) {
    "Win32NT" { "windows.json" }
    "Unix" { 
        if ($IsMacOS) { "darwin.json" } 
        else { "linux.json" }
    }
    default { "windows.json" }
}

$configPath = Join-Path $ProfileRoot "configs\$configFileName"
if (Test-Path $configPath) {
    try {
        $config = Get-Content $configPath -Raw | ConvertFrom-Json
        
        # Java Environment Variables
        $env:JAVA_HOME = $config.java.home
        $env:PATH += ";" + $config.java.binPath
        
        # Maven Environment
        $env:MAVEN_HOME = $config.maven.home
        $env:PATH += ";" + $config.maven.binPath
        
        # Node.js Environment (nvm4w)
        $env:NVM4W_HOME = $config.nodejs.nvm4wHome
        $env:PATH += ";" + $config.nodejs.nodePath
        
        # Handle nvm-windows PATH (ensure current Node.js version is in PATH)
        if ($platform -eq "Win32NT" -and (Get-Command "nvm" -ErrorAction SilentlyContinue)) {
            try {
                # Get current Node.js version from nvm
                $nvmList = nvm list 2>$null
                $currentVersion = $nvmList | Select-String "\*" | ForEach-Object { 
                    ($_.ToString() -split '\s+')[1] -replace '[\*\s]', '' 
                }
                
                if ($currentVersion) {
                    $nodePath = "C:\Users\$env:USERNAME\AppData\Local\nvm\v$currentVersion"
                    if (Test-Path $nodePath -and ($env:PATH -notlike "*$nodePath*")) {
                        $env:PATH = "$nodePath;$env:PATH"
                        Write-Host "✅ Added nvm Node.js $currentVersion to PATH" -ForegroundColor Green
                    }
                }
            } catch {
                # Silent fail - nvm might not be configured properly
            }
        }
        
        # uv Environment (expand environment variables)
        $uvHomeExpanded = [System.Environment]::ExpandEnvironmentVariables($config.uv.home)
        $env:UV_HOME = $uvHomeExpanded
        
        # Database Password (if configured)
        if ($null -ne $config.database.password) {
            $env:DB_PASSWORD = $config.database.password
        }
        
        Write-Host "✅ System environment loaded successfully from $configFileName config!" -ForegroundColor Green
        Write-Host "   Config file: $configPath" -ForegroundColor Gray
        Write-Host "   Java: $($env:JAVA_HOME)" -ForegroundColor Cyan
        Write-Host "   Maven: $($env:MAVEN_HOME)" -ForegroundColor Cyan
        
        # Show nvm and Node.js version information
        if (Get-Command "nvm" -ErrorAction SilentlyContinue) {
            try {
                $nvmList = nvm list 2>$null
                $currentVersion = $nvmList | Select-String "\*" | ForEach-Object { 
                    ($_.ToString() -split '\s+')[1] -replace '[\*\s]', '' 
                }
                if ($currentVersion) {
                    Write-Host "   nvm: Node.js Version Manager (current: $currentVersion)" -ForegroundColor Cyan
                } else {
                    Write-Host "   nvm: Node.js Version Manager" -ForegroundColor Cyan
                }
            } catch {
                Write-Host "   nvm: Node.js Version Manager" -ForegroundColor Cyan
            }
        } else {
            Write-Host "   nvm: Not found" -ForegroundColor Gray
        }
        
        # Show current Node.js version
        try {
            $nodePath = "$($config.nodejs.nodePath)\node.exe"
            if (Test-Path $nodePath) {
                $nodeVer = & $nodePath --version 2>$null
                if ($nodeVer) {
                    Write-Host "   Node.js: $nodeVer" -ForegroundColor Cyan
                } else {
                    Write-Host "   Node.js: $($config.nodejs.nodePath)" -ForegroundColor Cyan
                }
            } else {
                Write-Host "   Node.js: $($config.nodejs.nodePath)" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "   Node.js: $($config.nodejs.nodePath)" -ForegroundColor Cyan
        }
        
        # Show uv version
        try {
            $uvPath = Join-Path $uvHomeExpanded "uv.exe"
            if (Test-Path $uvPath) {
                $uvVer = & $uvPath --version 2>$null
                if ($uvVer) {
                    Write-Host "   uv: $uvVer" -ForegroundColor Cyan
                } else {
                    Write-Host "   uv: $($config.uv.home)" -ForegroundColor Cyan
                }
            } else {
                Write-Host "   uv: $($config.uv.home)" -ForegroundColor Cyan
            }
        } catch {
            Write-Host "   uv: $($config.uv.home)" -ForegroundColor Cyan
        }
        
    } catch {
        Write-Error "Failed to load configuration: $_"
    }
} else {
    Write-Warning "Configuration file not found: $configPath"
}
