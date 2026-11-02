# 网络代理配置指南

## 概述

本项目现在支持自动网络代理检测和提示功能。当检测到网络连接问题时，会自动显示代理配置建议。

## 默认代理设置

- **地址**: `localhost:7890`
- **类型**: HTTP/SOCKS5 混合端口
- **适用工具**: curl, wget, npm, yarn, git 等

## 自动提示功能

当以下网络命令执行失败时，会自动显示代理配置提示：

- `curl`
- `wget` 
- `npm`
- `yarn`

提示内容包括：
- 代理服务器信息
- PowerShell 环境变量设置
- Git 配置命令
- NPM/Yarn 配置命令

## 手动配置代理

### 使用配置工具脚本

项目提供了专用的代理配置工具：

```powershell
# 启用代理（默认 localhost:7890）
.\tools\setup-proxy.ps1 -Enable

# 启用代理（自定义端口）
.\tools\setup-proxy.ps1 -Enable -Port 8080

# 禁用代理
.\tools\setup-proxy.ps1 -Disable

# 查看当前状态
.\tools\setup-proxy.ps1 -Status

# 测试网络连接
.\tools\setup-proxy.ps1 -TestConnection
```

### 手动配置

#### PowerShell 环境变量
```powershell
$env:HTTP_PROXY = "http://localhost:7890"
$env:HTTPS_PROXY = "http://localhost:7890"
$env:NO_PROXY = "localhost,127.0.0.1,.local"
```

#### Git 配置
```bash
git config --global http.proxy http://localhost:7890
git config --global https.proxy http://localhost:7890
```

#### NPM 配置
```bash
npm config set proxy http://localhost:7890
npm config set https-proxy http://localhost:7890
```

#### Yarn 配置
```bash
yarn config set proxy http://localhost:7890
yarn config set https-proxy http://localhost:7890
```

## 禁用代理

### 使用工具脚本
```powershell
.\tools\setup-proxy.ps1 -Disable
```

### 手动禁用

#### 移除 PowerShell 环境变量
```powershell
Remove-Item Env:HTTP_PROXY, Env:HTTPS_PROXY, Env:NO_PROXY
```

#### 移除 Git 配置
```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

#### 移除 NPM 配置
```bash
npm config delete proxy
npm config delete https-proxy
```

#### 移除 Yarn 配置
```bash
yarn config delete proxy
yarn config delete https-proxy
```

## 故障排除

### 1. 代理不生效
- 确认代理服务正在运行
- 检查端口是否正确（默认 7890）
- 验证代理类型是否匹配

### 2. 某些工具仍无法连接
- 检查工具是否读取正确的环境变量
- 确认 NO_PROXY 设置是否包含必要的本地地址
- 尝试重启终端会话

### 3. 性能问题
- 考虑将频繁访问的域名添加到 NO_PROXY
- 检查代理服务器性能

## 开发者说明

### 添加新的网络工具支持

在 `Profile.ps1` 中找到 `Invoke-WithNetworkCheck` 函数，可以为其他网络工具添加类似的包装：

```powershell
function new-tool { 
    Invoke-WithNetworkCheck -CommandName "new-tool" -ScriptBlock {
        # 原始工具调用逻辑
        & "new-tool.exe" @args 
    }
}
```

### 自定义代理检测逻辑

修改 `Test-NetworkConnectivity` 函数来自定义网络检测逻辑：

```powershell
function Test-NetworkConnectivity {
    param(
        [string]$Url = "https://www.google.com",
        [int]$TimeoutSeconds = 5
    )
    # 自定义检测逻辑
}
```

## 相关资源

- [Clash 配置文档](https://github.com/Dreamacro/clash)
- [Windows Terminal 代理设置](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-appearances)
- [PowerShell 网络配置](https://learn.microsoft.com/en-us/powershell/)
