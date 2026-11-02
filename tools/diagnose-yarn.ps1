# Yarn 安装状态诊断脚本
Write-Host "🔍 正在诊断 yarn 安装状态..." -ForegroundColor Yellow

# 1. 检查 yarn 命令是否存在
Write-Host "`n1. 检查 yarn 命令:" -ForegroundColor Cyan
try {
    $yarnVersion = yarn --version 2>$null
    if ($yarnVersion) {
        Write-Host "✅ yarn 已安装，版本: $yarnVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ yarn 命令存在但无法获取版本" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ yarn 命令不存在或无法执行" -ForegroundColor Red
}

# 2. 检查 npm 全局包
Write-Host "`n2. 检查 npm 全局包中的 yarn:" -ForegroundColor Cyan
try {
    $npmList = npm list -g --depth=0 2>$null
    if ($npmList -match "yarn") {
        Write-Host "✅ npm 全局包中找到 yarn" -ForegroundColor Green
        $npmList | Select-String "yarn" | ForEach-Object { Write-Host "   $_" }
    } else {
        Write-Host "❌ npm 全局包中未找到 yarn" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ 无法检查 npm 全局包" -ForegroundColor Red
}

# 3. 检查 nvm 目录
Write-Host "`n3. 检查 nvm 目录中的 yarn 文件:" -ForegroundColor Cyan
$nvmPath = "C:\Users\myste\AppData\Local\nvm\v24.13.1"
if (Test-Path $nvmPath) {
    $yarnFiles = Get-ChildItem $nvmPath -Filter "*yarn*" -ErrorAction SilentlyContinue
    if ($yarnFiles) {
        Write-Host "✅ 在 nvm 目录中找到 yarn 相关文件:" -ForegroundColor Green
        $yarnFiles | ForEach-Object { Write-Host "   $($_.Name)" }
    } else {
        Write-Host "❌ nvm 目录中未找到 yarn 文件" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ nvm 目录不存在: $nvmPath" -ForegroundColor Red
}

# 4. 检查 PATH 环境变量
Write-Host "`n4. 检查 PATH 中的 yarn 相关路径:" -ForegroundColor Cyan
$yarnInPath = $env:PATH -split ';' | Where-Object { $_ -like '*yarn*' }
if ($yarnInPath) {
    Write-Host "✅ PATH 中找到 yarn 相关路径:" -ForegroundColor Green
    $yarnInPath | ForEach-Object { Write-Host "   $_" }
} else {
    Write-Host "❌ PATH 中未找到 yarn 相关路径" -ForegroundColor Yellow
}

# 5. 检查可能的 yarn 安装位置
Write-Host "`n5. 检查常见的 yarn 安装位置:" -ForegroundColor Cyan
$possiblePaths = @(
    "C:\Program Files (x86)\Yarn\bin\yarn.cmd",
    "C:\Program Files\Yarn\bin\yarn.cmd",
    "$env:LOCALAPPDATA\Yarn\bin\yarn.cmd",
    "$env:APPDATA\npm\yarn.cmd"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        Write-Host "✅ 找到 yarn: $path" -ForegroundColor Green
    }
}

Write-Host "`n✅ 诊断完成!" -ForegroundColor Green