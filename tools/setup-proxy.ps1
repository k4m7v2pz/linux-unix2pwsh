<#
.SYNOPSIS
    Network Proxy Configuration Tool for linux-unix2pwsh
.DESCRIPTION
    This script helps configure HTTP/SOCKS5 proxy settings for common development tools.
    Default proxy: localhost:7890 (HTTP/SOCKS5 mixed port)
.PARAMETER Enable
    Enable proxy settings
.PARAMETER Disable
    Disable proxy settings
.PARAMETER Status
    Show current proxy status
.PARAMETER Port
    Specify custom proxy port (default: 7890)
.EXAMPLE
    .\setup-proxy.ps1 -Enable
    Enable proxy with default settings (localhost:7890)
.EXAMPLE
    .\setup-proxy.ps1 -Disable
    Disable all proxy settings
.EXAMPLE
    .\setup-proxy.ps1 -Status
    Show current proxy configuration status
#>

param(
    [Parameter(ParameterSetName="Action")]
    [switch]$Enable,
    
    [Parameter(ParameterSetName="Action")]
    [switch]$Disable,
    
    [Parameter(ParameterSetName="Action")]
    [switch]$Status,
    
    [Parameter(ParameterSetName="Action")]
    [int]$Port = 7890,
    
    [Parameter(ParameterSetName="Test")]
    [switch]$TestConnection
)

function Show-Header {
    Write-Host "==================================" -ForegroundColor Green
    Write-Host "  Network Proxy Configuration Tool" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
}

function Show-CurrentStatus {
    Write-Host "🔍 Current Proxy Status:" -ForegroundColor Yellow
    Write-Host ""
    
    # PowerShell Environment Variables
    Write-Host "PowerShell Environment Variables:" -ForegroundColor Cyan
    if ($env:HTTP_PROXY) {
        Write-Host "  HTTP_PROXY: $($env:HTTP_PROXY)" -ForegroundColor Green
    } else {
        Write-Host "  HTTP_PROXY: Not set" -ForegroundColor Gray
    }
    
    if ($env:HTTPS_PROXY) {
        Write-Host "  HTTPS_PROXY: $($env:HTTPS_PROXY)" -ForegroundColor Green
    } else {
        Write-Host "  HTTPS_PROXY: Not set" -ForegroundColor Gray
    }
    
    if ($env:NO_PROXY) {
        Write-Host "  NO_PROXY: $($env:NO_PROXY)" -ForegroundColor Green
    } else {
        Write-Host "  NO_PROXY: Not set" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Git Configuration
    Write-Host "Git Configuration:" -ForegroundColor Cyan
    $gitHttpProxy = git config --global --get http.proxy 2>$null
    $gitHttpsProxy = git config --global --get https.proxy 2>$null
    
    if ($gitHttpProxy) {
        Write-Host "  http.proxy: $gitHttpProxy" -ForegroundColor Green
    } else {
        Write-Host "  http.proxy: Not set" -ForegroundColor Gray
    }
    
    if ($gitHttpsProxy) {
        Write-Host "  https.proxy: $gitHttpsProxy" -ForegroundColor Green
    } else {
        Write-Host "  https.proxy: Not set" -ForegroundColor Gray
    }
    Write-Host ""
    
    # NPM Configuration
    Write-Host "NPM Configuration:" -ForegroundColor Cyan
    $npmProxy = npm config get proxy 2>$null
    $npmHttpsProxy = npm config get https-proxy 2>$null
    
    if ($npmProxy -and $npmProxy -ne "null") {
        Write-Host "  proxy: $npmProxy" -ForegroundColor Green
    } else {
        Write-Host "  proxy: Not set" -ForegroundColor Gray
    }
    
    if ($npmHttpsProxy -and $npmHttpsProxy -ne "null") {
        Write-Host "  https-proxy: $npmHttpsProxy" -ForegroundColor Green
    } else {
        Write-Host "  https-proxy: Not set" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Yarn Configuration
    Write-Host "Yarn Configuration:" -ForegroundColor Cyan
    $yarnProxy = yarn config get proxy 2>$null
    $yarnHttpsProxy = yarn config get https-proxy 2>$null
    
    if ($yarnProxy -and $yarnProxy -ne "null") {
        Write-Host "  proxy: $yarnProxy" -ForegroundColor Green
    } else {
        Write-Host "  proxy: Not set" -ForegroundColor Gray
    }
    
    if ($yarnHttpsProxy -and $yarnHttpsProxy -ne "null") {
        Write-Host "  https-proxy: $yarnHttpsProxy" -ForegroundColor Green
    } else {
        Write-Host "  https-proxy: Not set" -ForegroundColor Gray
    }
}

function Enable-Proxy {
    param([int]$Port)
    
    $proxyUrl = "http://localhost:$Port"
    $noProxy = "localhost,127.0.0.1,.local"
    
    Write-Host "🔧 Enabling proxy settings..." -ForegroundColor Yellow
    Write-Host "   HTTP Proxy: $proxyUrl" -ForegroundColor Cyan
    Write-Host "   SOCKS Proxy: socks://localhost:$Port" -ForegroundColor Cyan
    Write-Host ""
    
    # Set PowerShell environment variables
    Write-Host "Setting PowerShell environment variables..." -ForegroundColor Gray
    $env:HTTP_PROXY = $proxyUrl
    $env:HTTPS_PROXY = $proxyUrl
    $env:ALL_PROXY = "socks://localhost:$Port"
    $env:NO_PROXY = $noProxy
    Write-Host "✅ PowerShell proxy settings applied" -ForegroundColor Green
    Write-Host ""
    
    # Configure Git
    Write-Host "Configuring Git proxy..." -ForegroundColor Gray
    git config --global http.proxy $proxyUrl 2>$null
    git config --global https.proxy $proxyUrl 2>$null
    git config --global core.gitproxy "socks://localhost:$Port" 2>$null
    Write-Host "✅ Git proxy settings applied" -ForegroundColor Green
    Write-Host ""
    
    # Configure NPM
    Write-Host "Configuring NPM proxy..." -ForegroundColor Gray
    npm config set proxy $proxyUrl 2>$null
    npm config set https-proxy $proxyUrl 2>$null
    npm config set socks-proxy "socks://localhost:$Port" 2>$null
    Write-Host "✅ NPM proxy settings applied" -ForegroundColor Green
    Write-Host ""
    
    # Configure Yarn
    Write-Host "Configuring Yarn proxy..." -ForegroundColor Gray
    yarn config set proxy $proxyUrl 2>$null
    yarn config set https-proxy $proxyUrl 2>$null
    yarn config set socks-proxy "socks://localhost:$Port" 2>$null
    Write-Host "✅ Yarn proxy settings applied" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "🎉 Proxy configuration completed!" -ForegroundColor Green
    Write-Host "💡 To disable later, run: .\setup-proxy.ps1 -Disable" -ForegroundColor Yellow
}

function Disable-Proxy {
    Write-Host "🔧 Disabling proxy settings..." -ForegroundColor Yellow
    Write-Host ""
    
    # Remove PowerShell environment variables
    Write-Host "Removing PowerShell environment variables..." -ForegroundColor Gray
    if (Test-Path Env:HTTP_PROXY) { Remove-Item Env:HTTP_PROXY }
    if (Test-Path Env:HTTPS_PROXY) { Remove-Item Env:HTTPS_PROXY }
    if (Test-Path Env:ALL_PROXY) { Remove-Item Env:ALL_PROXY }
    if (Test-Path Env:NO_PROXY) { Remove-Item Env:NO_PROXY }
    Write-Host "✅ PowerShell proxy settings removed" -ForegroundColor Green
    Write-Host ""
    
    # Remove Git configuration
    Write-Host "Removing Git proxy configuration..." -ForegroundColor Gray
    git config --global --unset http.proxy 2>$null
    git config --global --unset https.proxy 2>$null
    git config --global --unset core.gitproxy 2>$null
    Write-Host "✅ Git proxy settings removed" -ForegroundColor Green
    Write-Host ""
    
    # Remove NPM configuration
    Write-Host "Removing NPM proxy configuration..." -ForegroundColor Gray
    npm config delete proxy 2>$null
    npm config delete https-proxy 2>$null
    npm config delete socks-proxy 2>$null
    Write-Host "✅ NPM proxy settings removed" -ForegroundColor Green
    Write-Host ""
    
    # Remove Yarn configuration
    Write-Host "Removing Yarn proxy configuration..." -ForegroundColor Gray
    yarn config delete proxy 2>$null
    yarn config delete https-proxy 2>$null
    yarn config delete socks-proxy 2>$null
    Write-Host "✅ Yarn proxy settings removed" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "🎉 Proxy configuration disabled!" -ForegroundColor Green
}

function Test-ProxyConnection {
    Write-Host "🧪 Testing proxy connection..." -ForegroundColor Yellow
    Write-Host ""
    
    # Test direct connection
    Write-Host "Testing direct connection to google.com..." -ForegroundColor Gray
    try {
        $request = [System.Net.WebRequest]::Create("https://www.google.com")
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        Write-Host "✅ Direct connection: SUCCESS" -ForegroundColor Green
    } catch {
        Write-Host "❌ Direct connection: FAILED" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Test proxy connection if proxy is set
    if ($env:HTTP_PROXY) {
        Write-Host "Testing proxy connection ($($env:HTTP_PROXY))..." -ForegroundColor Gray
        try {
            $proxy = New-Object System.Net.WebProxy($env:HTTP_PROXY)
            $request = [System.Net.WebRequest]::Create("https://www.google.com")
            $request.Proxy = $proxy
            $request.Timeout = 5000
            $response = $request.GetResponse()
            $response.Close()
            Write-Host "✅ Proxy connection: SUCCESS" -ForegroundColor Green
        } catch {
            Write-Host "❌ Proxy connection: FAILED" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Gray
        }
    } else {
        Write-Host "⏭️  Skipping proxy test (proxy not configured)" -ForegroundColor Yellow
    }
}

# Main execution
Show-Header

if ($Status) {
    Show-CurrentStatus
}
elseif ($Enable) {
    Enable-Proxy -Port $Port
    Show-CurrentStatus
}
elseif ($Disable) {
    Disable-Proxy
    Show-CurrentStatus
}
elseif ($TestConnection) {
    Test-ProxyConnection
}
else {
    # Show help
    Write-Host "USAGE:" -ForegroundColor Yellow
    Write-Host "  .\setup-proxy.ps1 -Enable          # Enable proxy (localhost:7890)" -ForegroundColor White
    Write-Host "  .\setup-proxy.ps1 -Enable -Port 8080  # Enable proxy with custom port" -ForegroundColor White
    Write-Host "  .\setup-proxy.ps1 -Disable         # Disable all proxy settings" -ForegroundColor White
    Write-Host "  .\setup-proxy.ps1 -Status          # Show current proxy status" -ForegroundColor White
    Write-Host "  .\setup-proxy.ps1 -TestConnection  # Test network connectivity" -ForegroundColor White
    Write-Host ""
    Write-Host "DEFAULT PROXY: localhost:7890 (HTTP/SOCKS5 mixed)" -ForegroundColor Cyan
    Write-Host ""
    Show-CurrentStatus
}

Write-Host ""
Write-Host "Need help? Check the project README or run 'helpunix curl' for network command tips." -ForegroundColor Yellow
