#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=~/.dotfiles
fi
GITHUB_URL=https://github.com/kazukitash/dotfiles.git

# OS/Arch.のチェック
isArch() {
  local os=$(uname -s)
  local arch=$(uname -m)
  if [[ "$os" == "Darwin" && "$arch" == "arm64" && "$1" == "AppleSilicon" ]]; then
    return 0 # true
  elif [[ "$os" == "Darwin" && "$arch" == "x86_64" && "$1" == "IntelMac" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && "$arch" == "aarch64" && "$1" == "ArmLinux" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && "$arch" == "x86_64" && "$1" == "IntelLinux" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && $(uname -r) =~ microsoft && "$1" == "WSL" ]]; then
    return 0 # true
  elif [[ "$os" == "Darwin" && "$1" == "macOS" ]]; then
    return 0 # true
  elif [[ "$os" == "$1" ]]; then
    return 0 # true
  else
    return 1 # false
  fi
}

# コマンドの存在チェック
has() {
  type "$1" >/dev/null 2>&1
  return $?
}

# ヘッダー出力
e_header() {
  printf "\n\e[33;4m%s\e[0m \e[33;1m%s\e[0m\n" "$1" "$2"
}

# ログ出力
e_log() {
  printf "\e[37;4m%s\e[0m \e[37m%s\e[0m\n" "$1" "$2"
}

# 成功の出力
e_done() {
  printf "\e[32;4m%s\e[0m \e[32m%s - ✔  OK\e[0m\n" "$1" "$2"
}

# エラーの出力
e_error() {
  printf "\e[31;4m%s\e[0m \e[31m%s - ✖  Failed\e[0m\n" "$1" "$2" 1>&2
}

# 結果のチェック
check_result() {
  if [ $1 -eq 0 ]; then
    e_done "$2" "$3 completed"
  else
    e_error "$2" "$3 failed"
    exit 1
  fi
}

# XCode CLI toolsのインストール
install_xcodecli_if_macos() {
  if isArch macOS; then
    e_header "XCode CLI tools" "Install"

    # XCode CLI toolsの存在チェック
    e_log "XCode CLI tools" "Checking existance..."
    xcode-select -p &>/dev/null
    if [ $? -ne 0 ]; then
      # XCode CLI toolsがインストールされていない場合、インストールを実行
      e_log "XCode CLI tools" "Installing..."
      touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
      PROD=$(softwareupdate -l |
        grep "\*.*Command Line" |
        tail -n 1 | sed 's/^[^C]* //')
      echo "Prod: ${PROD}"
      softwareupdate -i "$PROD" --verbose
      check_result $? "XCode CLI tools" "Install"
    else
      e_done "XCode CLI tools" "Already installed"
    fi
  fi
}

# Homebrewのインストール
install_homebrew() {
  e_header "Homebrew" "Install"

  e_log "Homebrew" "Checking existance..."
  if has brew; then
    e_done "Homebrew" "Already installed"
  else
    e_log "Homebrew" "Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_result $? "Homebrew" "Install"
    if isArch Linux; then
      export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    elif isArch AppleSilicon; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}

install_git() {
  e_header "Git" "Install"

  if has git; then
    e_done "Git" "Already installed"
  else
    e_log "Git" "Installing..."
    brew install git
    check_result $? "Git" "Install"
  fi
}

install_vim() {
  e_header "Vim" "Install"

  if has vim; then
    e_done "Vim" "Already installed"
  else
    e_log "Vim" "Installing..."
    brew install vim
    check_result $? "Vim" "Install"
  fi
}

# macOSとLinuxのみ実行
check_os() {
  if isArch macOS; then
    e_log "Dotfiles" "Start installation for macOS"
  elif isArch Linux; then
    e_log "Dotfiles" "Start installation for Linux"
  else
    e_error "Dotfiles" "Unknown OS. Abort the process"
    exit 1
  fi
}

dotfiles_logo='
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
'

download_dotfiles() {
  e_header "Dotfiles" "Download"

  e_log "Dotfiles" "Downloading..."
  if !([ -e ~/.dotfiles ]); then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"
  fi
  check_result $? "Dotfiles" "Download"
}

deploy_dotfiles() {
  e_header "Dotfiles" "Deploy"

  e_log "Dotfiles" "Changing directory..."
  cd "$DOTPATH"

  e_log "Dotfiles" "Updating..."
  ./scripts/update.sh
  check_result $? "Dotfiles" "Update"

  e_log "Dotfiles" "Deploying..."
  ./scripts/deploy.sh
  check_result $? "Dotfiles" "Deploy"
}

install_formulas() {
  e_header "Homebrew" "Install formulas"
  brew bundle --global
  check_result $? "Homebrew" "Install formulas"
}

setup_zsh_completion() {
  if isArch macOS; then
    chmod -R go-w /opt/homebrew/share
  else
    chmod 755 /home/linuxbrew/.linuxbrew/share
  fi
}

setup_git() {
  e_header "Git" "Setup"

  if [ -n "${REMOTE_CONTAINERS:-}" ]; then
    e_log "Git" "Setting safe directory..."
    git config --global --add safe.directory '*'
  fi

  if isArch macOS; then
    e_log "Git" "Setting credential helper..."
    git config --global credential.helper osxkeychain
  fi
}

# main
check_os
echo "$dotfiles_logo"
install_xcodecli_if_macos
install_homebrew
install_git
install_vim
download_dotfiles
deploy_dotfiles
install_formulas
setup_zsh_completion
setup_git
