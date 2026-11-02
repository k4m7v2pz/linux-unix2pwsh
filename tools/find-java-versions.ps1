# Java 版本发现和配置生成脚本
Write-Host "🔍 正在扫描系统中的 Java 安装..." -ForegroundColor Yellow

# 存储发现的 Java 版本
$javaVersions = @()

# 检查主要安装位置
$installLocations = @(
    "C:\Program Files\Eclipse Adoptium",
    "C:\Program Files\Java",
    "C:\Program Files (x86)\Java"
)

foreach ($location in $installLocations) {
    if (Test-Path $location) {
        Write-Host "📁 检查目录: $location" -ForegroundColor Cyan
        $jdkFolders = Get-ChildItem $location -Directory | Where-Object { $_.Name -like "jdk*" }
        
        foreach ($folder in $jdkFolders) {
            $javaExe = Join-Path $folder.FullName "bin\java.exe"
            if (Test-Path $javaExe) {
                try {
                    $versionOutput = & $javaExe -version 2>&1
                    $versionLine = $versionOutput | Select-String "version" | Select-Object -First 1
                    if ($versionLine) {
                        $version = $versionLine.ToString().Split('"')[1]
                        $javaInfo = [PSCustomObject]@{
                            Name = $folder.Name
                            Path = $folder.FullName
                            Version = $version
                            JavaExe = $javaExe
                            BinPath = Join-Path $folder.FullName "bin"
                        }
                        $javaVersions += $javaInfo
                        Write-Host "  ✅ 发现: $($folder.Name) (Java $version)" -ForegroundColor Green
                    }
                } catch {
                    Write-Host "  ⚠️  无法获取版本信息: $($folder.Name)" -ForegroundColor Yellow
                }
            }
        }
    }
}

# 使用 where.exe 查找额外的 Java 安装
Write-Host "`n🔍 使用 where.exe 查找更多 Java 安装..." -ForegroundColor Yellow
$whereResults = where.exe java 2>$null
foreach ($result in $whereResults) {
    $parentDir = Split-Path (Split-Path $result)
    $folderName = Split-Path $parentDir -Leaf
    if ($javaVersions.Path -notcontains $parentDir) {
        try {
            $versionOutput = & $result -version 2>&1
            $versionLine = $versionOutput | Select-String "version" | Select-Object -First 1
            if ($versionLine) {
                $version = $versionLine.ToString().Split('"')[1]
                $javaInfo = [PSCustomObject]@{
                    Name = $folderName
                    Path = $parentDir
                    Version = $version
                    JavaExe = $result
                    BinPath = Split-Path $result
                }
                $javaVersions += $javaInfo
                Write-Host "  ✅ 发现 (via where): $folderName (Java $version)" -ForegroundColor Green
            }
        } catch {
            # 忽略无法获取版本的安装
        }
    }
}

# 显示结果
Write-Host "`n📋 发现的 Java 版本汇总:" -ForegroundColor Yellow
Write-Host "=" * 50
$javaVersions | Format-Table Name, Version, Path -AutoSize

# 生成配置建议
Write-Host "`n🔧 配置建议:" -ForegroundColor Yellow
Write-Host "当前活动版本: $($javaVersions[0].Name) (Java $($javaVersions[0].Version))"
Write-Host "`n推荐的配置文件更新内容:"
Write-Host "{"
Write-Host "  ""java"": {"
Write-Host "    ""home"": ""$($javaVersions[0].Path.Replace('\', '\\'))"","
Write-Host "    ""binPath"": ""$($javaVersions[0].BinPath.Replace('\', '\\'))"""
Write-Host "  }"
Write-Host "}"

# 如果有多个版本，显示切换建议
if ($javaVersions.Count -gt 1) {
    Write-Host "`n🔄 多版本切换建议:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $javaVersions.Count; $i++) {
        Write-Host "  $($i + 1). $($javaVersions[$i].Name) - Java $($javaVersions[$i].Version)"
    }
    Write-Host "`n可以通过修改配置文件中的 java.home 和 java.binPath 来切换版本"
}

return $javaVersions