# Test script for tree and find commands
. /home/user/.config/powershell/Microsoft.PowerShell_profile.ps1

Write-Host "Testing enhanced tree and find functions..." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Gray

# Create test directory structure
$testRoot = "test-tree-find"
if (Test-Path $testRoot) {
    Remove-Item $testRoot -Recurse -Force
}

Write-Host "`n1. Creating test directory structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path "$testRoot/docs" -Force | Out-Null
New-Item -ItemType Directory -Path "$testRoot/src" -Force | Out-Null
New-Item -ItemType Directory -Path "$testRoot/tests" -Force | Out-Null
New-Item -ItemType Directory -Path "$testRoot/config" -Force | Out-Null
New-Item -ItemType File -Path "$testRoot/README.md" -Force | Out-Null
New-Item -ItemType File -Path "$testRoot/main.ps1" -Force | Out-Null
New-Item -ItemType File -Path "$testRoot/test.ps1" -Force | Out-Null
New-Item -ItemType File -Path "$testRoot/config.json" -Force | Out-Null
Write-Host "✅ Test structure created" -ForegroundColor Green

Write-Host "`n2. Testing basic tree command..." -ForegroundColor Cyan
Write-Host "Command: tree $testRoot" -ForegroundColor Yellow
tree $testRoot

Write-Host "`n3. Testing tree with depth limit (-L 2)..." -ForegroundColor Cyan
Write-Host "Command: tree $testRoot -L 2" -ForegroundColor Yellow
tree $testRoot -L 2

Write-Host "`n4. Testing tree with exclusion pattern (-I '*.json|*.ps1')..." -ForegroundColor Cyan
Write-Host "Command: tree $testRoot -I '*.json|*.ps1'" -ForegroundColor Yellow
tree $testRoot -I '*.json|*.ps1'

Write-Host "`n5. Testing tree with --dirsfirst..." -ForegroundColor Cyan
Write-Host "Command: tree $testRoot --dirsfirst" -ForegroundColor Yellow
tree $testRoot --dirsfirst

Write-Host "`n6. Testing tree with all options combined..." -ForegroundColor Cyan
Write-Host "Command: tree $testRoot -L 2 -I 'docs|tests' --dirsfirst" -ForegroundColor Yellow
tree $testRoot -L 2 -I 'docs|tests' --dirsfirst

Write-Host "`n7. Testing basic find command..." -ForegroundColor Cyan
Write-Host "Command: find $testRoot" -ForegroundColor Yellow
find $testRoot | Select-Object -First 10 FullName

Write-Host "`n8. Testing find with -type f (files only)..." -ForegroundColor Cyan
Write-Host "Command: find $testRoot -type f" -ForegroundColor Yellow
find $testRoot -type f | Select-Object -First 10 FullName

Write-Host "`n9. Testing find with -type d (directories only)..." -ForegroundColor Cyan
Write-Host "Command: find $testRoot -type d" -ForegroundColor Yellow
find $testRoot -type d | Select-Object -First 10 FullName

Write-Host "`n10. Testing find with -name pattern..." -ForegroundColor Cyan
Write-Host "Command: find $testRoot -name '*.ps1'" -ForegroundColor Yellow
find $testRoot -name '*.ps1' | Select-Object FullName

Write-Host "`n11. Testing find piped to Where-Object (replacing grep)..." -ForegroundColor Cyan
Write-Host "Command: find $testRoot -type f | Where-Object { `$_.Name -notmatch 'test' }" -ForegroundColor Yellow
find $testRoot -type f | Where-Object { $_.Name -notmatch 'test' } | Select-Object FullName

Write-Host "`n✅ All tests completed!" -ForegroundColor Green

# Cleanup
Write-Host "`nCleaning up test directory..." -ForegroundColor Gray
Remove-Item $testRoot -Recurse -Force
Write-Host "✅ Cleanup complete" -ForegroundColor Green
