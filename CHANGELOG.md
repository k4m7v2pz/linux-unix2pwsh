# Changelog

## [Unreleased]

### Fixed
- **cp command hanging issue**: Fixed the problem where `cp -r` would hang waiting for Path[0] input
  - Added proper Unix parameter conversion for cp command (`-r` → `-Recurse`, `-f` → `-Force`)
  - Updated cp function to use parameter conversion logic similar to rm command
  - Fixed Test-DangerousCommand function to handle empty argument arrays
  - Improved argument parsing to properly separate path arguments from parameters

### Changed
- Enhanced parameter conversion system to support cp command flags
- Improved error handling in safety checking functions

## [1.0.0] - Initial Release
- Basic Unix command mappings (ls, cd, pwd, cat, etc.)
- Safety warnings for dangerous operations
- Development environment integration
- Git shortcuts and navigation helpers