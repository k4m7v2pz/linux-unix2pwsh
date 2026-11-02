# Unix to PowerShell Command Mappings

This document lists all the Unix/Linux commands that are mapped to PowerShell equivalents in this profile.

## File Operations

| Unix Command | PowerShell Equivalent | Alias | Description |
|-------------|----------------------|-------|-------------|
| `ls` | `Get-ChildItem` | `gci` | List directory contents |
| `cat` | `Get-Content` | `gc` | Display file contents |
| `rm` | `Remove-Item` | `ri` | Remove files/directories |
| `mv` | `Move-Item` | `mi` | Move/rename files |
| `cp` | `Copy-Item` | `ci` | Copy files |
| `touch` | `New-Item` | `ni` | Create empty file |
| `mkdir` | `New-Item -ItemType Directory` | | Create directory |
| `rmdir` | `Remove-Item` | `ri` | Remove directory |

## System Information

| Unix Command | PowerShell Equivalent | Alias | Description |
|-------------|----------------------|-------|-------------|
| `pwd` | `Get-Location` | `gl` | Print working directory |
| `cd` | `Set-Location` | `sl` | Change directory |
| `ps` | `Get-Process` | `gps` | View processes |
| `kill` | `Stop-Process` | `spps` | Terminate processes |
| `df` | `Get-PSDrive` | `gdr` | Disk space usage |
| `du` | `Get-ChildItem \| Measure-Object` | | Directory size |

## Text Processing

| Unix Command | PowerShell Equivalent | Alias | Description |
|-------------|----------------------|-------|-------------|
| `head` | `Get-Content -TotalCount` | `gc -Head` | First lines of file |
| `tail` | `Get-Content -Tail` | `gc -Tail` | Last lines of file |
| `grep` | `Select-String` | `sls` | Search text patterns |

## Network

| Unix Command | PowerShell Equivalent | Alias | Description |
|-------------|----------------------|-------|-------------|
| `wget` | `Invoke-WebRequest` | `iwr` | Download files |
| `curl` | `Invoke-WebRequest` | `iwr` | HTTP requests |

## Utilities

| Unix Command | PowerShell Equivalent | Alias | Description |
|-------------|----------------------|-------|-------------|
| `which` | `Get-Command` | | Find command location |
| `find` | `Get-ChildItem -Recurse` | | Find files |
| `clear` | `Clear-Host` | `cls` | Clear screen |

## Development Tools

| Command | Description |
|---------|-------------|
| `node` | JavaScript runtime (with hints) |
| `npm` | Node package manager (with hints) |
| `uv` | Python project manager |
| `python` | Python interpreter (recommends uv) |
| `pip` | Python package installer (recommends uv) |

## Parameter Conversions

### rm command
- `-r` → `-Recurse`
- `-f` → `-Force`
- `-rf` → `-Recurse -Force`

### ls command
- `-l` → (ignored, default behavior)
- `-a` → `-Force`
- `-la` → `-Force`

## Safety Features

Dangerous operations (rm -rf, kill -9, etc.) will show warnings but won't block execution in non-interactive environments, making it suitable for automation and AI agents.