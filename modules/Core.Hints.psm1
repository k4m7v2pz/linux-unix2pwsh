# === Hints and Tips Module ===

function Show-PwshHint {
    param(
        [string]$CmdName,
        [string]$PwshCmdlet,
        [string]$Alias
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        Write-Host "💡 Unix-Like command '$CmdName' was called (Unix-style habit)" -ForegroundColor Yellow
        Write-Host "   Actual execution: $PwshCmdlet (PowerShell Cmdlet)" -ForegroundColor Cyan
        Write-Host "   Recommended PowerShell usage: $Alias" -ForegroundColor Green
    }
}

function Show-PythonUvHint {
    param(
        [string]$CmdName
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        Write-Host "💡 Python/$CmdName detected" -ForegroundColor Yellow
        
        # Check if uv is available
        if (Get-Command "uv" -ErrorAction SilentlyContinue) {
            Write-Host "✅ Using 'uv' package manager (faster than pip)" -ForegroundColor Green
            Write-Host "   Recommended: uv pip install <package>" -ForegroundColor Cyan
        } else {
            Write-Host "💡 Consider installing 'uv' for faster Python package management" -ForegroundColor Cyan
            Write-Host "   Install: curl -LsSf https://astral.sh/uv/install.sh | sh" -ForegroundColor Gray
        }
    }
}

function Show-NodeJsHint {
    param(
        [string]$CmdName
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        Write-Host "💡 Node.js/$CmdName detected" -ForegroundColor Yellow
        
        # Determine platform-specific recommendations
        $platform = $PSVersionTable.Platform
        
        switch ($CmdName.ToLower()) {
            "npm" {
                if ($platform -eq "Win32NT") {
                    # Windows: recommend yarn
                    Write-Host "✅ Recommended for Windows: yarn (faster, better Windows integration)" -ForegroundColor Green
                    Write-Host "   Alternatives:" -ForegroundColor Gray
                    Write-Host "   - pnpm (recommended for macOS due to better link handling and disk efficiency)" -ForegroundColor Cyan
                    Write-Host "   - bun (emerging alternative with speed improvements)" -ForegroundColor Cyan
                } elseif ($IsMacOS) {
                    # macOS: recommend pnpm
                    Write-Host "✅ Recommended for macOS: pnpm (better link handling and disk efficiency)" -ForegroundColor Green
                    Write-Host "   Alternatives:" -ForegroundColor Gray
                    Write-Host "   - yarn (stable, widely used)" -ForegroundColor Cyan
                    Write-Host "   - bun (emerging alternative with speed improvements)" -ForegroundColor Cyan
                } else {
                    # Linux or general
                    Write-Host "✅ Recommended: pnpm (efficient disk usage and speed)" -ForegroundColor Green
                    Write-Host "   Alternatives:" -ForegroundColor Gray
                    Write-Host "   - yarn (stable, widely used)" -ForegroundColor Cyan
                    Write-Host "   - bun (emerging alternative with speed improvements)" -ForegroundColor Cyan
                }
            }
            
            default {
                Write-Host "   💡 Tip: Consider using modern alternatives like pnpm, yarn, or bun" -ForegroundColor Cyan
            }
        }
        
        Write-Host ""  # Empty line
    }
}

function Show-VenvActivationHint {
    param(
        [string]$CmdName
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        Write-Host "💡 Virtual environment activation detected: $CmdName" -ForegroundColor Yellow
        Write-Host "   ✅ PowerShell way: Just use the venv's Python directly!" -ForegroundColor Green
        Write-Host "   Example: .venv\Scripts\python.exe your_script.py" -ForegroundColor Cyan
        Write-Host "   Or activate permanently in your shell session." -ForegroundColor Gray
        Write-Host ""  # Empty line
    }
}

function Show-WindowsSudoHint {
    param(
        [string]$CmdName
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        Write-Host "💡 Windows sudo-style command '$CmdName' was called" -ForegroundColor Yellow
        Write-Host "   Actual execution: Running with elevated privileges" -ForegroundColor Cyan
        Write-Host "   💡 On Windows, this will prompt for UAC elevation" -ForegroundColor Gray
        Write-Host "   🌐 Alternative: Run PowerShell as Administrator once" -ForegroundColor Cyan
        Write-Host ""  # Empty line
    }
}

function Show-NetworkProxyHint {
    param(
        [string]$CmdName
    )
    
    # Show hints only in interactive ConsoleHost
    if ($host.Name -eq "ConsoleHost") {
        # Simple check: if command failed or timed out
        # In practice, you might want to check actual network connectivity
        
        Write-Host "🌐 Network connectivity hint for '$CmdName'" -ForegroundColor Yellow
        Write-Host "💡 If you're experiencing network access issues, try configuring proxy:" -ForegroundColor Cyan
        Write-Host ""  # Empty line
        
        # Show current proxy settings if available
        $httpProxy = $env:HTTP_PROXY ?? $env:http_proxy
        $httpsProxy = $env:HTTPS_PROXY ?? $env:https_proxy
        
        if ($httpProxy -or $httpsProxy) {
            Write-Host "Current proxy configuration:" -ForegroundColor Gray
            if ($httpProxy) { Write-Host "  HTTP:  $httpProxy" -ForegroundColor Cyan }
            if ($httpsProxy) { Write-Host "  HTTPS: $httpsProxy" -ForegroundColor Cyan }
        } else {
            Write-Host "No proxy configured. Common proxy addresses:" -ForegroundColor Gray
            Write-Host "  HTTP:  http://127.0.0.1:7890" -ForegroundColor Cyan
            Write-Host "  HTTPS: http://127.0.0.1:7890" -ForegroundColor Cyan
            Write-Host "  SOCKS: socks5://127.0.0.1:7890" -ForegroundColor Cyan
        }
        
        Write-Host ""  # Empty line
    }
}
