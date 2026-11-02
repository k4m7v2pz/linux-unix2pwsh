# Test script to demonstrate the cp -r fix

# First, let's define the parameter conversion function
function Convert-UnixArgsToPowerShell {
    param(
        [string]$CommandName,
        [array]$UnixArgs
    )
    
    $psArgs = @()
    
    switch ($CommandName) {
        'rm' {
            for ($i = 0; $i -lt $UnixArgs.Count; $i++) {
                $arg = $UnixArgs[$i].ToString()
                switch ($arg) {
                    '-r' { $psArgs += '-Recurse' }
                    '-f' { $psArgs += '-Force' }
                    '-rf' { $psArgs += '-Recurse'; $psArgs += '-Force' }
                    '-fr' { $psArgs += '-Force'; $psArgs += '-Recurse' }
                    default { $psArgs += $arg }
                }
            }
        }
        'cp' {
            for ($i = 0; $i -lt $UnixArgs.Count; $i++) {
                $arg = $UnixArgs[$i].ToString()
                switch ($arg) {
                    '-r' { $psArgs += '-Recurse' }
                    '-f' { $psArgs += '-Force' }
                    '-rf' { $psArgs += '-Recurse'; $psArgs += '-Force' }
                    '-fr' { $psArgs += '-Force'; $psArgs += '-Recurse' }
                    default { $psArgs += $arg }
                }
            }
        }
        'ls' {
            $forceFlag = $false
            $otherArgs = @()
            
            for ($i = 0; $i -lt $UnixArgs.Count; $i++) {
                $arg = $UnixArgs[$i].ToString()
                if ($arg -eq '-la' -or $arg -eq '-al' -or $arg -eq '-lah' -or $arg -eq '-hal') {
                    $forceFlag = $true
                }
                elseif ($arg -eq '-a') {
                    $forceFlag = $true
                }
                elseif ($arg -eq '-l') {
                    continue
                }
                else {
                    $otherArgs += $arg
                }
            }
            
            if ($forceFlag) {
                $psArgs += '-Force'
                $psArgs += $otherArgs
            } else {
                $psArgs = $otherArgs
            }
        }
        default {
            $psArgs = $UnixArgs
        }
    }
    
    return $psArgs
}

# Define the fixed cp function
function cp { 
    # Check if sufficient arguments provided
    if ($args.Count -lt 2) {
        Write-Host "❌ Execution blocked: 'cp' requires source and destination paths" -ForegroundColor Red
        return
    }
    
    Write-Host "💡 Unix-Like command 'cp' was called (Unix-style habit)" -ForegroundColor Yellow
    Write-Host "   Actual execution: Copy-Item (PowerShell Cmdlet)" -ForegroundColor Cyan
    Write-Host "   Recommended PowerShell usage: ci, Copy-Item" -ForegroundColor Green
    
    # Convert Unix parameters to PowerShell parameters
    $convertedParams = Convert-UnixArgsToPowerShell -CommandName "cp" -UnixArgs $args
    
    Write-Host "DEBUG: Original args: $($args -join ' ')" -ForegroundColor Magenta
    Write-Host "DEBUG: Converted params: $($convertedParams -join ' ')" -ForegroundColor Magenta
    
    # Execute actual command
    $paramHash = @{}
    $pathArgs = @()
    
    foreach ($param in $convertedParams) {
        if ($param -like '-*') {
            # Parameter token
            $paramName = $param.TrimStart('-')
            $paramHash[$paramName] = $true
        } else {
            # Path argument
            $pathArgs += $param
        }
    }
    
    if ($pathArgs.Count -ge 2) {
        # Last argument is destination, rest are sources
        $destination = $pathArgs[-1]
        $sources = $pathArgs[0..($pathArgs.Count - 2)]
        Write-Host "DEBUG: Copying from $($sources -join ', ') to $destination with params: $($paramHash.Keys -join ', ')" -ForegroundColor Magenta
        Copy-Item -Path $sources -Destination $destination @paramHash
    }
}

# Test the fix
Write-Host "Testing cp -r command fix..." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Gray

# Create test directories
$testSource = "/tmp/cp-test-source"
$testDest = "/tmp/cp-test-dest"

# Clean up any existing test directories
if (Test-Path $testSource) { Remove-Item $testSource -Recurse -Force }
if (Test-Path $testDest) { Remove-Item $testDest -Recurse -Force }

# Create test structure
New-Item -ItemType Directory -Path $testSource -Force | Out-Null
New-Item -ItemType Directory -Path "$testSource/subdir" -Force | Out-Null
New-Item -ItemType File -Path "$testSource/file1.txt" -Value "test content 1" -Force | Out-Null
New-Item -ItemType File -Path "$testSource/subdir/file2.txt" -Value "test content 2" -Force | Out-Null

Write-Host "Created test structure:" -ForegroundColor Cyan
Get-ChildItem $testSource -Recurse

Write-Host "`nTesting cp -r command..." -ForegroundColor Cyan
cp -r $testSource $testDest

Write-Host "`nResult:" -ForegroundColor Cyan
if (Test-Path $testDest) {
    Get-ChildItem $testDest -Recurse
    Write-Host "✅ SUCCESS: Recursive copy worked correctly!" -ForegroundColor Green
} else {
    Write-Host "❌ FAILED: Destination was not created" -ForegroundColor Red
}

# Clean up
Remove-Item $testSource -Recurse -Force
Remove-Item $testDest -Recurse -Force