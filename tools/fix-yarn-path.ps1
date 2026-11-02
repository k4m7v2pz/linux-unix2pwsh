# 修复 yarn PATH 配置脚本
Write-Host "🔧 正在修复 yarn PATH 配置..." -ForegroundColor Yellow

# 1. 检查当前 Node.js 版本路径
$currentNodePath = "C:\Users\myste\AppData\Local\nvm\v24.13.1"
Write-Host "当前 Node.js 路径: $currentNodePath" -ForegroundColor White

# 2. 检查该路径是否已在 PATH 中
$nodeInPath = $env:PATH -split ';' | Where-Object { $_ -eq $currentNodePath }

if ($nodeInPath) {
    Write-Host "✅ Node.js 路径已在 PATH 中" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js 路径不在 PATH 中，正在添加..." -ForegroundColor Yellow
    # 临时添加到当前会话
    $env:PATH = "$currentNodePath;$env:PATH"
    Write-Host "✅ 已添加到当前会话 PATH" -ForegroundColor Green
}

# 3. 验证 yarn 是否可用
Write-Host "`n🔍 验证 yarn 可用性:" -ForegroundColor Cyan
try {
    $yarnVersion = yarn --version 2>$null
    if ($yarnVersion) {
        Write-Host "✅ yarn 可用，版本: $yarnVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ yarn 仍然不可用" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ yarn 命令执行失败" -ForegroundColor Red
}

# 4. 检查 nvm-windows 的自动 PATH 管理
Write-Host "`n⚙️  检查 nvm-windows 配置:" -ForegroundColor Cyan
$nvmSettings = "$env:USERPROFILE\AppData\Roaming\nvm\settings.txt"
if (Test-Path $nvmSettings) {
    $settingsContent = Get-Content $nvmSettings
    Write-Host "nvm settings 内容:" -ForegroundColor White
    $settingsContent | ForEach-Object { Write-Host "   $_" }
    
    # 检查是否启用了自动 PATH 管理
    if ($settingsContent -match "PATH") {
        Write-Host "✅ 发现 PATH 相关配置" -ForegroundColor Green
    }
} else {
    Write-Host "❌ 未找到 nvm settings 文件" -ForegroundColor Yellow
}

# 5. 提供永久解决方案
Write-Host "`n💡 永久解决方案建议:" -ForegroundColor Yellow
Write-Host "1. 重启 PowerShell 让 nvm 重新初始化" -ForegroundColor White
Write-Host "2. 或者手动运行: nvm use 24.13.1" -ForegroundColor White
Write-Host "3. 或者将以下路径添加到系统 PATH:" -ForegroundColor White
Write-Host "   $currentNodePath" -ForegroundColor Cyan

Write-Host "`n✅ PATH 修复脚本执行完成!" -ForegroundColor Green