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
- **All dotfiles are symlinked to this repository**, so when editing any configuration file (`.zshrc`, `.config/`, `.claude/`, etc.), you should edit the actual files in `~/.dotfiles/` instead of the symlinked files in the home directory
- Use `./scripts/list.sh` to see the complete list of files that are symlinked

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

## Git Commit Guidelines

### Claude Settings File

When committing changes, be aware that `.claude/settings.json` contains a `lastShownTime` field that automatically updates. To avoid committing this timestamp change:

1. Review changes carefully before committing: `git diff .claude/settings.json`
2. If only the `lastShownTime` has changed, skip committing this file
3. If other important changes exist in the file, consider using `git add -p` to selectively stage changes, excluding the `lastShownTime` line

## Configuration File Handling

When configuration file errors are reported (e.g., `~/.config/zellij/config.kdl`), always check the corresponding source file in this repository first (e.g., `.config/zellij/config.kdl`) since all dotfiles are symlinked from `~/.dotfiles/`. The actual files to edit are in this repository, not in the home directory symlinks.
