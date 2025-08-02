# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a personal dotfiles repository that manages configuration files for macOS and Linux environments. The repository uses symlinks to deploy dotfiles from `~/.dotfiles` to the home directory.

## Key Commands

### Installation
```bash
# Initial installation from remote
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"
```

### Update and Deploy
```bash
# Update from remote repository
./scripts/update.sh

# Deploy dotfiles to home directory
./scripts/deploy.sh
```

### List Managed Dotfiles
```bash
# Show all dotfiles that will be deployed
./scripts/list.sh
```

### Install Homebrew Packages
```bash
# Install all packages defined in .Brewfile
brew bundle --global
```

## Architecture and Structure

### Deployment System
- The `scripts/deploy.sh` script creates symlinks from this repository to the home directory
- The `scripts/list.sh` defines which files get deployed (excludes `.git`, `.DS_Store`, etc.)
- Files in `.config/` are deployed recursively maintaining their directory structure
- Existing files are backed up with timestamp before creating symlinks

### CI/CD
- GitHub Actions workflows test the installation on macOS and Linux
- The `install.sh` script handles complete setup including:
  - XCode CLI tools (macOS only)
  - Homebrew installation
  - Git and Vim installation
  - Dotfiles deployment
  - Homebrew formula installation from `.Brewfile`

### Platform Support
- Supports macOS (Intel and Apple Silicon)
- Supports Linux (x86_64, ARM, and WSL)
- Platform detection is handled by the `isArch()` function in `install.sh`