# Linux/Unix to PowerShell Command Alias Migration

## Overview

This project configures aliases in PowerShell `$PROFILE` to help users move from Unix/Linux shells to PowerShell. It defines functions and aliases that map common Linux/Unix commands (such as `ls`, `rm`, `rmdir`, `cat`) to equivalent PowerShell cmdlets. It also provides interactive hints and recommended PowerShell usage to reduce command conflicts and unsafe operations.

## Core Features

- Map Linux/Unix commands to PowerShell cmdlets.
- Show recommended aliases and PowerShell equivalents automatically.
- Extensible design for adding more command hints.
- Keep familiar command behavior for both scripts and interactive usage.
- Smart Unix-style argument handling:
  - `ls -la` maps to `Get-ChildItem -Force`
  - `ls -a` maps to hidden-file listing
  - `cp -r` maps to `Copy-Item -Recurse`
  - `rm -rf` maps to `Remove-Item -Recurse -Force`
  - `mkdir -p` supports parent directory creation
  - `mkdir {dir1,dir2,dir3}` supports brace expansion
- Enhanced safety checks for risky patterns like `rm -rf` with non-blocking warnings.
- Automatic conversion from Unix arguments to PowerShell equivalents.
- Built-in help command: `helpunix <command>`.
- **Windows Environment Integration**:
  - Automatic Java, Maven, Node.js (nvm4w), and uv environment setup
  - Intelligent hints for modern development tools
  - `Get-DevEnvironmentInfo` for quick environment overview
- **Development Tool Support**:
  - Node.js/npm with modern alternatives suggestions (bun, deno, pnpm, yarn)
  - Python/pip with uv workflow recommendations
  - Git shortcuts (gs, ga, gc, gp)
  - Navigation aliases (cdcode, cdhome)

## Use Cases

- Linux/Bash users migrating to PowerShell for the first time.
- Developers who want to keep Unix-like habits in PowerShell.
- **AI agents** that need stable command execution in PowerShell without hanging.
- Teams that want guided command hints in terminals or project environments.
- **Windows developers** working with Java, Node.js, Python ecosystems.
- **Cross-platform development** teams needing consistent tooling.

## Installation

### Method 1: Install Script (Recommended)

Use the bundled install script to copy the profile to the correct location:

```powershell
# Run the install script
./install.ps1
```

After installation, restart PowerShell or run `. $PROFILE` to load the profile immediately.

### Method 2: Manual Installation

1. Open PowerShell 7 and check your profile path:
   ```powershell
   $PROFILE
   ```
   Usually:
   `/Users/<username>/.config/powershell/Microsoft.PowerShell_profile.ps1`

2. Create the profile directory if needed:
   ```powershell
   New-Item -ItemType Directory -Force /Users/<username>/.config/powershell
   ```

3. Copy the content of `Microsoft.PowerShell_profile.ps1` into your `$PROFILE` file.

4. Load the profile:
   ```powershell
   . $PROFILE
   ```
   Note: `.` is PowerShell's source operator for loading the file into the current session.

## Usage Examples

### Basic Commands

- `pwd` - show current path
- `cd ..` - change directory
- `ls` - list files (supports smart conversion of `-la`, `-a`, `-l`)
- `ls -la` - list all files including hidden files (maps to `Get-ChildItem -Force`)
- `cat file.txt` - show file content
- `ps` - show processes (`ps aux` is blocked)
- `kill 1234` - stop process
- `mv file1 file2` - move file
- `cp file1 file2` - copy file
- `cp -r sourcedir destdir` - recursive copy (maps to `Copy-Item -Recurse`)
- `rm file` - remove file
- `rm -rf directory` - recursive force remove (maps to `Remove-Item -Recurse -Force`)
- `mkdir dirname` - create directory
- `mkdir -p parent/child/grandchild` - create directory with parent directories
- `mkdir -p packages/{core,aur,fonts,applications,development,multimedia}` - create multiple directories with brace expansion
- `touch newfile` - create new file
- `head file` - show first lines
- `tail file` - show last lines
- `grep "pattern"` - search piped input (`grep -E` is blocked)
- `clear` - clear screen (recommends `cls` or `Clear-Host`)

### Development Tools

- `node --version` - JavaScript runtime (shows modern alternatives)
- `npm install` - Package manager (suggests pnpm/yarn/bun)
- `python script.py` - Python execution (recommends uv workflow)
- `pip install package` - Package installer (recommends uv)
- `uv init project` - Python project initialization
- `uv add requests` - Add Python dependencies
- `uv run python script.py` - Run Python with virtual environment

### Utility Functions

- `Get-DevEnvironmentInfo` - Show all development tool versions
- `helpunix node` - Help for Node.js commands
- `helpunix uv` - Help for Python uv commands
- `cdcode` - Navigate to Code directory
- `cdhome` - Navigate to home directory

### Git Shortcuts

- `gs` - `git status`
- `ga .` - `git add .`
- `gc -m "message"` - `git commit -m "message"`
- `gp` - `git push`
- `gl` - `git pull`

### Additional Network and System Commands

- `wget url` - download file (maps to `Invoke-WebRequest`)
- `curl url` - download file (maps to `Invoke-WebRequest`)
- `find . -name "*.txt"` - find files (maps to `Get-ChildItem -Recurse`)
- `which command` - locate command (maps to `Get-Command`)
- `df` - show disk space (maps to `Get-PSDrive`)
- `du` - show directory size (maps to `Get-ChildItem | Measure-Object`)

### Help System

- `helpunix ls` - detailed help for `ls`
- `helpunix cat` - detailed help for `cat`
- `helpunix rm` - safety tips and best practices for `rm`

Before command execution, the profile prints hints including:

- command style (Unix-like habit vs. PowerShell habit)
- actual alias/cmdlet being executed
- recommended PowerShell usage with common parameter examples

Example for `ls`:

```text
Unix-Like command 'ls' was called (Unix-style habit)
Actual execution: gci (PowerShell alias) -> Get-ChildItem
Recommended PowerShell usage: gci, Get-ChildItem, gci -fo, Get-ChildItem -Force
```

## Special Argument Handling

### Smart Parameter Conversion

- `ls -la` / `ls -al` / `ls -lah` / `ls -hal` -> `Get-ChildItem -Force`
- `ls -a` -> `Get-ChildItem -Force` (show hidden files)
- `ls -l` -> ignored (`PowerShell` already displays long-style output by default)
- `cp -r` -> `Copy-Item -Recurse` (recursive copy)
- `cp -f` -> `Copy-Item -Force` (force copy)
- `cp -rf` -> `Copy-Item -Recurse -Force` (recursive force copy)
- `rm -r` -> `Remove-Item -Recurse` (recursive remove)
- `rm -f` -> `Remove-Item -Force` (force remove)
- `rm -rf` -> `Remove-Item -Recurse -Force` (recursive force remove)
- `mkdir -p` -> `New-Item -ItemType Directory -Force` (create parent directories)
- `mkdir {dir1,dir2}` -> creates multiple directories from brace expansion

### Blocked Argument Patterns

For Unix-style argument combinations that can be misleading in PowerShell, execution is blocked with alternatives:

- `ps aux` -> `Get-Process | Select-Object ProcessName, Id, CPU, WS`
- `grep -E` -> `Select-String -Pattern "regex"`

### Safety Protection

Built-in checks detect and warn about dangerous operations:

- `rm -rf` / `rm -fr` -> dangerous pattern detected, logs warning
- `rm -r -f` -> recursive forced deletion detected, logs warning
- `kill -9` -> force-kill signal detected, logs warning

When a dangerous operation is detected, the system:

1. Shows a warning message
2. Logs the operation for audit purposes
3. **Continues execution automatically** (non-blocking for automation)
4. Provides PowerShell best-practice guidance

> **Note**: Unlike traditional Unix shells, dangerous commands do not block execution in interactive mode, making this profile ideal for AI agents and automated scripts while still providing safety notifications.

### Dangerous Command List

Get-Content,Set-Content,Add-Content,Remove-Item,Clear-Item,Move-Item,Copy-Item,Rename-Item,New-Item,Invoke-Item,Start-Process,Stop-Process,Restart-Process,Get-Process,Stop-Service,Restart-Service,Set-Service,Invoke-Command,Enter-PSSession,New-PSSession,Remove-PSSession,Read-Host,Out-Host,Out-Printer,Format-Table,Format-List,Format-Wide,Format-Custom

This design keeps Unix habits while guiding users to native PowerShell best practices, and provides a stable execution environment for AI agents.