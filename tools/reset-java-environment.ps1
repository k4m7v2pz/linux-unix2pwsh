# Java 环境清理和重置脚本
Write-Host "🔧 正在清理和重置 Java 环境..." -ForegroundColor Yellow

# 1. 清理 PATH 中的 Java 相关路径
Write-Host "1. 清理 PATH 中的 Java 路径..." -ForegroundColor Cyan
$currentPaths = $env:PATH -split ';'
$cleanedPaths = $currentPaths | Where-Object { 
    $_ -notlike '*Eclipse Adoptium*' -and 
    $_ -notlike '*Java*' -and 
    $_ -notlike '*jdk*' 
}
$env:PATH = $cleanedPaths -join ';'

# 2. 设置正确的 JAVA_HOME
Write-Host "2. 设置 JAVA_HOME 为 Java 21..." -ForegroundColor Cyan
$env:JAVA_HOME = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot"

# 3. 添加正确的 Java 路径到 PATH 开头
Write-Host "3. 添加 Java 21 路径到 PATH..." -ForegroundColor Cyan
$java21Path = "C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot\bin"
$env:PATH = "$java21Path;$env:PATH"

# 4. 验证设置
Write-Host "`n✅ 环境设置完成!" -ForegroundColor Green
Write-Host "JAVA_HOME: $env:JAVA_HOME" -ForegroundColor White
Write-Host "Java 版本验证:" -ForegroundColor White
java -version

Write-Host "`n💡 提示: 这些更改仅在当前会话有效" -ForegroundColor Yellow
Write-Host "   如需永久生效，请运行: . `$PROFILE" -ForegroundColor Yellow