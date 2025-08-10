# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a sophisticated cross-platform dotfiles management system designed for professional developers working on macOS and Linux environments. The repository uses a **symlink-based deployment architecture** where all configuration files remain in `~/.dotfiles/` and are symlinked to their target locations, enabling live editing and version control of active configurations.

### Project Statistics

- Primary languages: Shell/Bash (automation), Lua (Neovim config)
- Lines of configuration: ~3000+ across all dotfiles
- Active since: February 2016 (9 years of evolution)
- Total commits: 480+ commits
- Architecture: Symlink deployment with backup/recovery system

## Quick Start

### Prerequisites

- **macOS**: 10.14+ (Intel or Apple Silicon)
- **Linux**: Ubuntu/Debian with APT package manager
- **Network**: Internet connection for package downloads
- **Permissions**: User account with admin privileges

### Installation

```bash
# Complete installation from remote (recommended)
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"

# Installation modes
/bin/bash -c "$(curl -L https://raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- --build      # Full dev environment
/bin/bash -c "$(curl -L https://raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- --work       # Work packages
/bin/bash -c "$(curl -L https://raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- -bw          # Combined build+work
```

### Local Development

```bash
# Clone and setup locally (development mode)
git clone https://github.com/kazukitash/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --build
```

## Essential Commands

### Core Operations

```bash
# Update dotfiles from remote
./scripts/update.sh

# Deploy dotfiles (create symlinks)
./scripts/deploy.sh

# Show all files that will be deployed
./scripts/list.sh

# Run platform-specific setup
./scripts/setup.sh
```

### Package Management

```bash
# Install all Homebrew packages
brew bundle --global

# Platform-specific packages
brew bundle --file .config/brew/macos.Brewfile
brew bundle --file .config/brew/linux.Brewfile

# Work environment packages
WORK_MODE=true ./scripts/setup.sh
```

### Development Tools

```bash
# Git aliases (configured automatically)
gpr                    # git stash && git pull --rebase origin main && git stash pop
gcm "message"          # git add -A && git commit -m "message"
gph                    # git push origin HEAD

# Development environment
dev                    # Start local development servers
dcln                   # Docker cleanup (containers, images, networks)
```

## Architecture and Key Concepts

### 1. **Symlink Deployment System**

The core innovation is **repository-as-source-of-truth** architecture:

- All dotfiles live permanently in `~/.dotfiles/`
- `deploy.sh` creates symlinks: `~/.dotfiles/.zshrc` → `~/.zshrc`
- Edit files in repository, changes apply immediately
- Version control tracks all configuration changes

**Location**: `scripts/deploy.sh`
**Usage**: Automatic during installation, manual via `./scripts/deploy.sh`

### 2. **Platform Abstraction Layer**

Unified platform detection enables cross-platform compatibility:

```bash
# From .config/zsh/lib/util.sh
arch() {
  if [[ "$os" == "Darwin" && "$arch" == "arm64" ]]; then
    echo "macOS"
  elif [[ "$os" == "Linux" ]]; then
    echo "Linux"
  fi
}
```

**Platform Support**:
- macOS: Intel/Apple Silicon unified
- Linux: x86_64/ARM/WSL compatible
- Automatic feature detection and adaptation

### 3. **Modular Configuration Architecture**

Zsh configuration follows XDG specification with intelligent loading:

```
.config/zsh/
├── .zshenv           # Loaded for ALL zsh sessions
├── .zshrc           # Loaded for INTERACTIVE sessions only  
└── lib/
    ├── env/         # Environment variables, PATH (always loaded)
    ├── rc/          # Prompts, keybinds, completion (interactive only)
    └── util.sh      # Shared utility functions
```

**Loading Strategy**: Conditional sourcing prevents performance issues

### 4. **Multi-Environment Package Management**

Hierarchical Brewfile system supports different use cases:

- `.Brewfile` - Global minimal packages
- `.config/brew/macos.Brewfile` - macOS common packages  
- `.config/brew/macos-default.Brewfile` - Personal packages
- `.config/brew/macos-work.Brewfile` - Work-specific packages
- `.config/brew/linux.Brewfile` - Linux packages

**Context switching**: `WORK_MODE=true` installs work packages

### 5. **Security-First Installation**

Multi-layer security prevents local tampering:

1. **Interactive shell check** - Prevents manual terminal execution
2. **File execution check** - Restricts to library loading only  
3. **String execution check** - Forces remote execution (curl | bash)
4. **CI environment bypass** - Allows GitHub Actions testing

**Security model**: Trust remote repository over local filesystem

## Project Structure

```
~/.dotfiles/
├── install.sh                    # Main installation entry point
├── scripts/                      # Core management automation
│   ├── deploy.sh                 # Symlink deployment engine
│   ├── list.sh                   # File discovery and filtering
│   ├── update.sh                 # Repository synchronization
│   ├── setup.sh                  # Setup orchestrator
│   └── setup/                    # Modular setup scripts
│       ├── 00_apt.sh            # Linux APT package management
│       ├── 01_brew.sh           # Homebrew package management
│       ├── 02_node.sh           # Node.js environment
│       ├── 03_zsh.sh            # Zsh shell configuration
│       ├── 04_fonts.sh          # Custom font installation
│       └── 05_terminal.sh       # Terminal.app automation
├── .config/                      # XDG-compliant configurations
│   ├── brew/                     # Platform-specific Brewfiles
│   ├── git/                      # Git configuration
│   ├── nvim/                     # Neovim configuration (Lua)
│   ├── zed/                      # Zed editor settings
│   ├── zellij/                   # Terminal multiplexer
│   └── zsh/                      # Modular Zsh configuration
├── share/                        # Static assets
│   ├── fonts/                    # Custom fonts (Rounded L M+)
│   └── Yawaraka.terminal         # Terminal theme
├── .claude/                      # Claude AI agent configurations
├── .github/workflows/            # CI/CD automation
└── [dotfiles]                    # Various configuration files
```

## Important Patterns

### File Deployment Exclusions

The `list.sh` script implements sophisticated exclusion logic:

```bash
# Files never deployed
EXCLUSIONS=(".DS_Store" ".git" ".gitignore" ".github" ".devcontainer.json" ".luarc.json" "scripts" "share" "CLAUDE.md")

# Directory-specific exclusions  
DIR_EXCLUSIONS=(".claude:settings.local.json")
```

**Usage**: Prevents development files from being deployed to home directory
**Location**: `scripts/list.sh`

### Error Handling Philosophy

All scripts use **fail-fast architecture** with structured error reporting:

```bash
#!/bin/bash -eu               # Exit on error, undefined variables
check_result $? "Component" "Action"   # Validate all operations
```

**Logging system**: Color-coded output with `e_header`, `e_log`, `e_done`, `e_error`

### Backup and Recovery

Automatic backup system prevents data loss:

- Existing files backed up as `.backup.YYYYMMDD_HHMMSS`
- Atomic symlink replacement
- Idempotent operations (safe to run multiple times)

### Adding New Configuration Files

1. **Add file to repository**: Place in appropriate location (respect XDG structure)
2. **Test exclusion**: Run `./scripts/list.sh` to verify it will be deployed
3. **Deploy**: Run `./scripts/deploy.sh` to create symlinks
4. **Validate**: Check that symlink points to repository file

### Cross-Platform Development

When adding platform-specific features:

1. **Use `arch()` function** for platform detection
2. **Separate Brewfiles** for different platforms  
3. **Conditional loading** in shell configurations
4. **Test on both platforms** via GitHub Actions

## Dependencies and External Services

### Core Dependencies

- **Homebrew**: Universal package manager (macOS/Linux)
- **Git**: Version control and credential management
- **Zsh**: Primary shell (macOS default, Linux installed)
- **curl**: Remote installation and updates

### Development Tools

- **mise**: Runtime version manager (replaces asdf)
- **fzf**: Fuzzy finder integration
- **zoxide**: Smart directory navigation
- **zellij**: Terminal multiplexer

### External Services  

- **GitHub**: Repository hosting and CI/CD
- **Homebrew repositories**: Package sources
- **GitHub Actions**: Automated testing (macOS + Linux)
- **Font CDN**: Custom font distribution

### Environment Variables

```bash
# Set automatically by installation
DOTPATH="${HOME}/.dotfiles"           # Repository root
ZDOTDIR="${HOME}/.config/zsh"         # Zsh configuration directory

# Optional configuration
WORK_MODE="true"                      # Enable work-specific packages
CI="true"                             # Detected in GitHub Actions
```

## Development Workflows

### Git Workflow

- **Branch strategy**: Direct commits to `main` (personal repository)
- **Commit convention**: `type(scope): 日本語での説明`
- **Types**: `feat`, `refactor`, `fix`, `style`
- **Mixed language**: English types, Japanese descriptions

### Local Development Loop

1. **Edit configurations** in `~/.dotfiles/`
2. **Test changes** (they apply immediately via symlinks)
3. **Commit changes**: `gcm "description"`
4. **Push to remote**: `gph`
5. **CI validation**: Automatic testing on push

### Testing Strategy

**GitHub Actions CI/CD**:
- **Matrix testing**: macOS + Linux platforms
- **Scenario testing**: Default, Build, Work+Build modes
- **Clean environment**: Homebrew uninstall/reinstall per test

**Local validation**:
- `./scripts/list.sh` - Preview deployment
- `./scripts/deploy.sh` - Test symlink creation
- Manual testing across different environments

## Hidden Context

### WORK_MODE Architecture

**Current State**: Infrastructure exists but packages not configured
- `macos-work.Brewfile` is empty (0 packages)
- `macos.Brewfile` contains 17 packages
- **Implementation**: Conditional package installation based on `WORK_MODE` environment variable

**Usage Pattern**:
```bash
WORK_MODE=true ./scripts/setup.sh     # Install work packages
./scripts/setup.sh                    # Install personal packages
```

### Security Design Philosophy

The installation script implements **defense against local tampering**:

**Threat Model**:
- Local file modification attacks
- Malicious script execution in interactive shells
- Untrusted local repository copies

**Mitigation Strategy**:
- Only allows remote string execution (curl | bash)
- Blocks file-based execution except for library loading
- Prevents interactive shell execution
- CI environment detection for testing flexibility

### Historical Evolution Patterns

**Technology Migrations** (from git history):
- `anyenv` → `mise`: Modern runtime version management
- `gitmoji` → `conventional commits`: Professional commit standards  
- `master` → `main`: Branch name modernization
- Windows support removal: Focused on Unix-like systems

**Architecture Evolution**:
- **2016**: Simple flat dotfiles structure
- **2022**: Gitmoji period with intensive restructuring  
- **2025**: Current renaissance with AI integration and cross-platform focus

### Platform-Specific Behavior

**macOS Specific**:
- **XCode CLI tools**: Automatic installation
- **Homebrew paths**: ARM64 vs Intel path handling
- **Terminal.app**: Automated profile installation
- **Font installation**: System font directory deployment

**Linux Specific**:
- **APT packages**: Non-interactive frontend prevents hanging
- **Locale/timezone**: Hardcoded for container compatibility
- **Git safe directory**: Container environment compatibility

### Performance Considerations

**Startup Optimization**:
- **Modular loading**: Only load what's needed for session type
- **Conditional tool integration**: Check tool existence before configuration
- **Lazy evaluation**: Defer expensive operations until needed

**Installation Performance**:
- **Parallel setup**: Scripts can run independently
- **Package caching**: Homebrew optimization
- **Selective installation**: Platform and mode-specific packages

### Documentation Debt

**Known Issues**:
- README.md references non-existent Makefile system
- Mixed language comments (Japanese/English)
- Empty WORK_MODE Brewfile indicates incomplete feature

## Code Style

### Shell Scripting Standards

**Strict Mode**:
- All scripts use `#!/bin/bash -eu` or `#!/bin/zsh`
- Exit on error (`-e`) and undefined variables (`-u`)

**Naming Conventions**:
- Variables: `lowercase_snake_case` 
- Functions: `lowercase_snake_case` with action verbs
- Environment: `UPPERCASE_SNAKE_CASE`
- Files: `kebab-case.extension`

**Code Organization**:
- 2-space indentation throughout
- String quoting: Double quotes for variables, single for literals
- Functions before main logic
- Error checking after each significant operation

### Configuration File Standards

**XDG Base Directory Compliance**:
- Application configs in `.config/`
- Proper `ZDOTDIR` configuration
- Clean home directory structure

**Modular Architecture**:
- Split configurations by function and loading context
- Conditional loading based on tool availability
- Platform-specific sections clearly marked

## Debugging Guide

### Common Issues

1. **Symlink conflicts**
   - **Symptoms**: File exists and isn't symlinked to repository
   - **Cause**: Manual file creation in home directory
   - **Solution**: `rm ~/conflicting_file && ./scripts/deploy.sh`
   - **Prevention**: Always edit files in `~/.dotfiles/`

2. **Path issues after installation**
   - **Symptoms**: Commands not found, tool integration broken
   - **Cause**: Shell not reloaded or PATH not updated
   - **Solution**: `source ~/.zshenv` or restart shell
   - **History**: Frequent issue, improved in recent versions

3. **Package installation failures**
   - **Symptoms**: Homebrew installation errors, missing dependencies
   - **Cause**: Platform-specific package unavailability
   - **Solution**: Check `.config/brew/platform.Brewfile` for corrections
   - **Prevention**: CI testing catches most compatibility issues

4. **Font rendering issues**
   - **Symptoms**: Missing characters, font not applied
   - **Cause**: Font cache not updated after installation
   - **Solution**: Restart terminal application, clear font cache
   - **Note**: macOS specific, handled automatically in setup script

### Debugging Tools

- **List command**: `./scripts/list.sh` shows deployment preview
- **Git status**: Shows which dotfiles have uncommitted changes
- **Platform detection**: `source .config/zsh/lib/util.sh && arch`
- **Package validation**: `brew bundle check --file .Brewfile`

### Logging

**Log files**: No persistent logging (shell script output only)
**Debugging mode**: Run scripts with `bash -x script.sh` for verbose output
**Color coding**: Green (success), Red (error), Yellow (headers), White (info)

## CI/CD Pipeline

### GitHub Actions Workflows

**Platform Matrix**:
- `macos.yml`: Tests on macOS-latest
- `linux.yml`: Tests on Ubuntu-latest

**Test Scenarios**:
- Default installation (dotfiles only)
- Build mode (`--build` flag)  
- Combined mode (`--build --work`)

**Pipeline Steps**:
1. **Environment Setup**: Clean Homebrew installation
2. **Installation Test**: Run install script with different modes
3. **Validation**: Verify successful setup and package installation
4. **Cleanup**: Uninstall and clean environment

### Quality Gates

- **Exit code validation**: All scripts must exit 0 for success
- **Error handling**: `-eu` flags catch issues early
- **Cross-platform testing**: Both macOS and Linux must pass
- **Multi-mode testing**: All installation modes validated

## Gotchas and Tips

### Critical Gotchas

- **Edit in repository**: Always edit files in `~/.dotfiles/`, never in home directory
- **WORK_MODE incomplete**: Work-specific packages not yet configured
- **Platform assumptions**: Some features may not work on non-supported platforms
- **Security restrictions**: Local execution blocked in interactive shells

### Pro Tips

- **Live editing**: Changes to dotfiles apply immediately via symlinks
- **Safe deployment**: Backup system prevents data loss during deployment
- **Platform testing**: Use GitHub Actions to validate cross-platform changes
- **Package organization**: Use platform-specific Brewfiles for clean separation

### Maintenance Tasks

**Regular Tasks**:
- **Update packages**: `brew update && brew upgrade`
- **Sync repository**: `./scripts/update.sh`
- **Clean unused packages**: `brew autoremove && brew cleanup`

**Periodic Tasks**:
- **Review exclusions**: Update `scripts/list.sh` for new files
- **Update dependencies**: Check for new tool versions
- **Documentation**: Keep CLAUDE.md updated with changes

## Resources

### Internal Documentation

- **Installation guide**: `install.sh` script comments
- **Architecture**: This CLAUDE.md file  
- **Change history**: Git commit log with conventional commits

### External References

- **XDG Base Directory**: [freedesktop.org specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- **Homebrew**: [brew.sh](https://brew.sh/) for package management
- **Zsh manual**: [zsh.org](http://zsh.sourceforge.net/Doc/)

### Maintenance Contacts

**Code ownership** (from git history):
- **Shell scripts**: Primary author (kazukitash)
- **Zsh configuration**: Primary author (kazukitash)  
- **CI/CD**: Primary author (kazukitash)
- **Documentation**: AI-assisted with human review

**Hot spots** (frequently changed):
- `.zshenv` (75 changes) - Core environment setup
- `.zshrc` (60 changes) - Interactive shell configuration
- `install.sh` (56 changes) - Installation system evolution