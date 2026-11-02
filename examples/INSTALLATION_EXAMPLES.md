# Installation Examples

## Quick Start

### 1. Install the Profile
```powershell
# Clone or download the repository
git clone https://gitee.com/tuas/linux-unix2pwsh.git
cd linux-unix2pwsh

# Run the installer
.\install.ps1
```

### 2. Manual Installation
```powershell
# Copy profile manually
$source = ".\Microsoft.PowerShell_profile.ps1"
$destination = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
Copy-Item $source $destination -Force
```

### 3. Reload Profile
```powershell
# Reload in current session
. $PROFILE

# Or restart PowerShell
```

## Usage Examples

### Basic Commands
```powershell
# File operations (Unix-style)
ls -la
cat filename.txt
rm -rf directory/
mv oldname.txt newname.txt
cp file1.txt file2.txt

# System information
ps aux
pwd
which git
df
du

# Text processing
head -10 file.txt
tail -5 file.txt
grep "pattern" file.txt
```

### Development Tools
```powershell
# Node.js with intelligent hints
node --version
npm install
npm run dev

# Python with uv recommendations
python script.py  # Shows uv recommendation
pip install package  # Shows uv recommendation

# Direct uv usage
uv init my-project
uv add requests
uv run python script.py
```

### Utility Functions
```powershell
# Environment information
Get-DevEnvironmentInfo

# Command help
helpunix ls
helpunix node
helpunix uv

# Navigation shortcuts
cdcode  # Go to Code directory
cdhome  # Go to home directory
```

### Git Shortcuts
```powershell
gs    # git status
ga .  # git add .
gc -m "message"  # git commit -m "message"
gp    # git push
gl    # git pull
```

## Advanced Usage

### Customizing the Profile
Edit `Microsoft.PowerShell_profile.ps1` to:
- Add custom aliases
- Modify dangerous command patterns
- Add new Unix command mappings
- Adjust environment variables

### Environment Variables
The profile automatically sets:
- `JAVA_HOME` and Java PATH
- `MAVEN_HOME` and Maven PATH
- `NVM4W_HOME` and Node.js PATH
- `UV_HOME` for uv

### Safety Configuration
Modify `$dangerousPatterns` to customize which operations trigger warnings:
```powershell
$dangerousPatterns = @{
    'rm' = @('-rf', '-fr', '-r', '-f')
    'kill' = @('-9', '-KILL')
    # Add your own patterns
}
```

## Troubleshooting

### Profile Not Loading
```powershell
# Check if profile exists
Test-Path $PROFILE

# Check for execution policy issues
Get-ExecutionPolicy

# Set execution policy (if needed)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Command Conflicts
```powershell
# Remove conflicting aliases
Remove-Item Alias:ls -ErrorAction SilentlyContinue

# Check command resolution
Get-Command ls
```

### Environment Issues
```powershell
# Verify environment variables
Get-ChildItem env: | Where-Object {$_.Name -like "*JAVA*" -or $_.Name -like "*NODE*"}

# Test tool availability
Get-Command node, npm, uv -ErrorAction SilentlyContinue
```