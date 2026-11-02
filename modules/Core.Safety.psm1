# === Safety and Security Module ===

function Test-DangerousCommand {
    param(
        [string]$CommandName,
        [object[]]$Arguments
    )
    
    # Check if arguments are null or empty
    if (-not $Arguments -or $Arguments.Count -eq 0) {
        return $false
    }
    
    $dangerousPatterns = @(
        @{ Pattern = 'rm.*-rf'; Description = "Recursive force delete" },
        @{ Pattern = 'rm.*-\*'; Description = "Wildcard delete" },
        @{ Pattern = 'kill.*-9'; Description = "Force kill process" },
        @{ Pattern = 'del.*\/f.*\*'; Description = "Force delete all" }
    )
    
    $argString = "$CommandName $($Arguments -join ' ')"
    
    foreach ($pattern in $dangerousPatterns) {
        if ($argString -match $pattern.Pattern) {
            Write-Host "⚠️  WARNING: Dangerous command detected - $($pattern.Description)" -ForegroundColor Red
            Write-Host "   Command: $argString" -ForegroundColor Yellow
            Write-Host "   💡 Tip: Double-check your paths before executing!" -ForegroundColor Cyan
            return $true
        }
    }
    
    return $false
}

function Invoke-SafeCommand {
    param(
        [scriptblock]$Command,
        [string]$CommandName,
        [object[]]$Arguments
    )
    
    # Check for dangerous patterns
    if (Test-DangerousCommand -CommandName $CommandName -Arguments $Arguments) {
        Write-Host "   ⏳ Executing anyway... (proceeding without blocking)" -ForegroundColor Gray
    }
    
    # Execute the command
    & $Command
}
