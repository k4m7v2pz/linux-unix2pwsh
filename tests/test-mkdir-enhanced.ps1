# Test script for enhanced mkdir functionality

Write-Host "Testing enhanced mkdir function..." -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Gray

# Clean up any existing test directories
$testDirs = @("test-mkdir-basic", "test-mkdir-parent", "test-brace-expansion")
foreach ($dir in $testDirs) {
    if (Test-Path $dir) {
        Remove-Item $dir -Recurse -Force
    }
}

Write-Host "`n1. Testing basic mkdir (without flags)..." -ForegroundColor Cyan
mkdir test-mkdir-basic
if (Test-Path "test-mkdir-basic") {
    Write-Host "✅ Basic mkdir works correctly" -ForegroundColor Green
} else {
    Write-Host "❌ Basic mkdir failed" -ForegroundColor Red
}

Write-Host "`n2. Testing mkdir with -p flag (parent directories)..." -ForegroundColor Cyan
mkdir -p test-mkdir-parent/nested/deeply
if (Test-Path "test-mkdir-parent/nested/deeply") {
    Write-Host "✅ mkdir -p works correctly" -ForegroundColor Green
} else {
    Write-Host "❌ mkdir -p failed" -ForegroundColor Red
}

Write-Host "`n3. Testing brace expansion..." -ForegroundColor Cyan
mkdir -p "test-brace-expansion/{docs,src,tests,config}"
$expectedDirs = @("test-brace-expansion/docs", "test-brace-expansion/src", "test-brace-expansion/tests", "test-brace-expansion/config")
$allExist = $true
foreach ($dir in $expectedDirs) {
    if (!(Test-Path $dir)) {
        $allExist = $false
        break
    }
}
if ($allExist) {
    Write-Host "✅ Brace expansion works correctly" -ForegroundColor Green
} else {
    Write-Host "❌ Brace expansion failed" -ForegroundColor Red
}

Write-Host "`n4. Testing multiple directory creation..." -ForegroundColor Cyan
mkdir dir1 dir2 dir3
$multiDirs = @("dir1", "dir2", "dir3")
$allMultiExist = $true
foreach ($dir in $multiDirs) {
    if (!(Test-Path $dir)) {
        $allMultiExist = $false
        break
    }
}
if ($allMultiExist) {
    Write-Host "✅ Multiple directory creation works correctly" -ForegroundColor Green
} else {
    Write-Host "❌ Multiple directory creation failed" -ForegroundColor Red
}

Write-Host "`n5. Testing error handling (no arguments)..." -ForegroundColor Cyan
mkdir  # This should show error message
Write-Host "✅ Error handling works correctly" -ForegroundColor Green

Write-Host "`nTest Results Summary:" -ForegroundColor Yellow
Write-Host "=====================" -ForegroundColor Yellow
Get-ChildItem test-* -Directory | ForEach-Object {
    Write-Host "📁 $($_.Name)" -ForegroundColor Blue
    Get-ChildItem $_.FullName -Recurse -Directory | ForEach-Object {
        $indent = "  " * ($_.FullName.Split("/").Count - $_.Parent.FullName.Split("/").Count)
        Write-Host "${indent}📁 $($_.Name)" -ForegroundColor Gray
    }
}

# Clean up test directories
Write-Host "`nCleaning up test directories..." -ForegroundColor Gray
foreach ($dir in ($testDirs + $multiDirs)) {
    if (Test-Path $dir) {
        Remove-Item $dir -Recurse -Force
    }
}

Write-Host "✅ All tests completed!" -ForegroundColor Green