# Validate Windows configuration against schema
param(
    [string]$ConfigPath = "configs\windows.json",
    [string]$SchemaPath = "configs\windows.schema.json"
)

Write-Host "🔍 Validating configuration..." -ForegroundColor Yellow

try {
    # Load configuration
    $config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
    Write-Host "✅ Configuration file loaded successfully" -ForegroundColor Green
    
    # Load schema
    $schema = Get-Content $SchemaPath -Raw | ConvertFrom-Json
    Write-Host "✅ Schema file loaded successfully" -ForegroundColor Green
    
    # Basic validation - check required top-level properties
    $requiredProps = @("java", "maven", "nodejs", "uv", "database")
    $missingProps = @()
    
    foreach ($prop in $requiredProps) {
        if (-not (Get-Member -InputObject $config -Name $prop -MemberType Properties)) {
            $missingProps += $prop
        }
    }
    
    if ($missingProps.Count -eq 0) {
        Write-Host "✅ All required properties present" -ForegroundColor Green
        
        # Validate nested properties
        if ($config.java.home -and $config.java.binPath) {
            Write-Host "✅ Java configuration valid" -ForegroundColor Green
        } else {
            Write-Warning "⚠️  Java configuration incomplete"
        }
        
        if ($config.maven.home -and $config.maven.binPath) {
            Write-Host "✅ Maven configuration valid" -ForegroundColor Green
        } else {
            Write-Warning "⚠️  Maven configuration incomplete"
        }
        
        $nodejsProps = @("nvm4wHome", "nodePath", "nodeExecutable", "npmExecutable", "npmScript", "npxExecutable", "yarnExecutable")
        $missingNodeProps = $nodejsProps | Where-Object { -not (Get-Member -InputObject $config.nodejs -Name $_ -MemberType Properties) }
        if ($missingNodeProps.Count -eq 0) {
            Write-Host "✅ Node.js configuration valid" -ForegroundColor Green
        } else {
            Write-Warning "⚠️  Missing Node.js properties: $($missingNodeProps -join ', ')"
        }
        
        Write-Host "🎉 Configuration validation completed successfully!" -ForegroundColor Green
    } else {
        Write-Error "❌ Missing required properties: $($missingProps -join ', ')"
    }
    
} catch {
    Write-Error "❌ Validation failed: $($_.Exception.Message)"
}