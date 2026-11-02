# Configuration Guide

## Windows Environment Configuration

The PowerShell profile now loads environment paths from a JSON configuration file located at `configs/windows.json`.

### Configuration Structure

```json
{
  "$schema": "./windows.schema.json",
  "java": {
    "home": "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.2.10-hotspot",
    "binPath": "C:\\Program Files\\Eclipse Adoptium\\jdk-25.0.2.10-hotspot\\bin"
  },
  "maven": {
    "home": "C:\\Program Files\\Apache\\maven-3.9.6",
    "binPath": "C:\\Program Files\\Apache\\maven-3.9.6\\bin"
  },
  "nodejs": {
    "nvm4wHome": "C:\\nvm4w",
    "nodePath": "C:\\nvm4w\\nodejs",
    "nodeExecutable": "C:\\nvm4w\\nodejs\\node.exe",
    "npmExecutable": "C:\\nvm4w\\nodejs\\npm.cmd",
    "npmScript": "C:\\nvm4w\\nodejs\\npm.ps1",
    "npxExecutable": "C:\\nvm4w\\nodejs\\npx.cmd",
    "yarnExecutable": "C:\\nvm4w\\nodejs\\yarn.cmd"
  },
  "uv": {
    "home": "%USERPROFILE%\\.local\\bin"
  },
  "database": {
    "password": null
  }
}
```

### Key Features

1. **JSON Schema Validation**: The configuration file includes a schema reference for validation
2. **Environment Variable Expansion**: Supports `%USERPROFILE%` and other Windows environment variables
3. **Fallback Mechanism**: If the config file is missing or invalid, falls back to hardcoded defaults
4. **Graceful Error Handling**: Continues to work even if configuration loading fails

### Customization

To customize your environment paths:

1. Edit `configs/windows.json` with your specific paths
2. The profile will automatically use your custom configuration
3. Invalid configurations will fall back to default paths with warnings

### Schema Validation

The JSON schema (`configs/windows.schema.json`) provides:
- Field validation and type checking
- Required field enforcement
- Example values for reference
- Documentation for each configuration option

### Example Custom Configuration

```json
{
  "$schema": "./windows.schema.json",
  "java": {
    "home": "D:\\Development\\Java\\jdk-17.0.8",
    "binPath": "D:\\Development\\Java\\jdk-17.0.8\\bin"
  },
  "maven": {
    "home": "D:\\Development\\apache-maven-3.9.4",
    "binPath": "D:\\Development\\apache-maven-3.9.4\\bin"
  },
  "nodejs": {
    "nvm4wHome": "D:\\Tools\\nvm",
    "nodePath": "D:\\Tools\\nvm\\nodejs",
    "nodeExecutable": "D:\\Tools\\nvm\\nodejs\\node.exe",
    "npmExecutable": "D:\\Tools\\nvm\\nodejs\\npm.cmd",
    "npmScript": "D:\\Tools\\nvm\\nodejs\\npm.ps1",
    "npxExecutable": "D:\\Tools\\nvm\\nodejs\\npx.cmd",
    "yarnExecutable": "D:\\Tools\\nvm\\nodejs\\yarn.cmd"
  },
  "uv": {
    "home": "D:\\Tools\\uv\\bin"
  },
  "database": {
    "password": "your_secure_password"
  }
}
```