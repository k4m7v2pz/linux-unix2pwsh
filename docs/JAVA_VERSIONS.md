# Java 版本切换指南

## 系统中发现的 Java 版本

你的系统上安装了以下 Java 版本：

1. **Java 8 (1.8.0_482)**
   - 路径: `C:\Program Files\Eclipse Adoptium\jdk-8.0.482.8-hotspot`
   - 适用场景: 老旧项目、企业遗留系统

2. **Java 11 (11.0.30)**
   - 路径: `C:\Program Files\Eclipse Adoptium\jdk-11.0.30.7-hotspot`
   - 适用场景: LTS 版本、广泛兼容性

3. **Java 17 (17.0.18)**
   - 路径: `C:\Program Files\Eclipse Adoptium\jdk-17.0.18.8-hotspot`
   - 适用场景: 最新 LTS 版本、现代应用开发

4. **Java 21 (21.0.10)** ⭐ **当前使用**
   - 路径: `C:\Program Files\Eclipse Adoptium\jdk-21.0.10.7-hotspot`
   - 适用场景: 最新 LTS 版本、前沿特性、推荐日常使用

5. **Java 25 (25.0.2)**
   - 路径: `C:\Program Files\Eclipse Adoptium\jdk-25.0.2.10-hotspot`
   - 适用场景: 最新版本、实验性功能

## 如何切换 Java 版本

要切换 Java 版本，请修改 `configs/windows.json` 文件中的 `java` 部分：

### 切换到 Java 8
```json
"java": {
  "home": "C:\\Program Files\\Eclipse Adoptium\\jdk-8.0.482.8-hotspot",
  "binPath": "C:\\Program Files\\Eclipse Adoptium\\jdk-8.0.482.8-hotspot\\bin"
}
```

### 切换到 Java 17
```json
"java": {
  "home": "C:\\Program Files\\Eclipse Adoptium\\jdk-17.0.18.8-hotspot",
  "binPath": "C:\\Program Files\\Eclipse Adoptium\\jdk-17.0.18.8-hotspot\\bin"
}
```

### 切换到 Java 21
```json
"java": {
  "home": "C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.10.7-hotspot",
  "binPath": "C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.10.7-hotspot\\bin"
}
```

### 切换到 Java 25
```json
"java": {
  "home": "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.2.10-hotspot",
  "binPath": "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.2.10-hotspot\\bin"
}
```

## 应用更改

修改配置文件后，重启 PowerShell 或运行以下命令重新加载配置：
```powershell
. $PROFILE
```

## 版本选择建议

- **日常开发**: Java 11 或 Java 17 (LTS 版本)
- **最新特性**: Java 21 或 Java 25
- **兼容性要求**: Java 8 或 Java 11
- **企业环境**: Java 8、11 或 17 (根据公司政策)

## 验证当前版本

运行以下命令验证当前使用的 Java 版本：
```powershell
java -version
Get-DevEnvironmentInfo
```