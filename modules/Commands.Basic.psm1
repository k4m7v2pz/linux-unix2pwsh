# === Basic Unix Commands Module ===

function pwd { Show-PwshHint "pwd" "Get-Location" "gl"; Get-Location @args }
function cd { Show-PwshHint "cd" "Set-Location" "sl"; Set-Location @args }

function ls {
    # Smart handling for Unix-style parameters
    $forceFlag = $false
    $otherArgs = @()
    
    # Parse parameters
    for ($i = 0; $i -lt $args.Count; $i++) {
        $arg = $args[$i]
        if ($arg -eq '-la' -or $arg -eq '-al' -or $arg -eq '-lah' -or $arg -eq '-hal') {
            # -l is default behavior in PowerShell; -a is equivalent to -Force
            $forceFlag = $true
        }
        elseif ($arg -eq '-a') {
            $forceFlag = $true
        }
        elseif ($arg -eq '-l') {
            # -l is default behavior in PowerShell; ignore it
            continue
        }
        else {
            # Keep other parameters unchanged
            $otherArgs += $arg
        }
    }
    
    Show-PwshHint "ls" "Get-ChildItem" "gci"
    
    # Choose invocation mode based on parameters
    if ($forceFlag) {
        if ($otherArgs.Count -gt 0) {
            Get-ChildItem -Force @otherArgs
        } else {
            Get-ChildItem -Force
        }
    } else {
        Get-ChildItem @otherArgs
    }
}

function cat {
    if ($args.Count -eq 0) {
        # Show hints only in interactive ConsoleHost
        if ($host.Name -eq "ConsoleHost") {
            Write-Host "❌ cat in PowerShell requires Path or piped input" -ForegroundColor Red
            Write-Host "👉 Correct usage:" -ForegroundColor Green
            Write-Host "   Get-Content file.txt" -ForegroundColor Cyan
            Write-Host "   gc file.txt" -ForegroundColor Cyan
            Write-Host "   \"text\" | Select-String ..." -ForegroundColor Cyan
        }
        return
    } else {
        Show-PwshHint "cat" "Get-Content" "gc"
        Get-Content @args
    }
}

function ps {
    # Detect Unix-style parameters such as aux
    $auxParam = $args | Where-Object { $_ -match "aux" }
    
    if ($auxParam) {
        # Show hints only in interactive ConsoleHost
        if ($host.Name -eq "ConsoleHost") {
            Write-Host "❌ Execution blocked: Unix-style command 'ps aux' cannot run directly in PowerShell" -ForegroundColor Red
            Write-Host "   Recommended PowerShell usage: Get-Process, gps" -ForegroundColor Green
            Write-Host "   Equivalent command: Get-Process | Select-Object ProcessName, Id, CPU, WS" -ForegroundColor Green
        }
        return
    } else {
        Show-PwshHint "ps" "Get-Process" "gps"
        Get-Process @args
    }
}
