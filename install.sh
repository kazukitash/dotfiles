#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=~/.dotfiles
fi
GITHUB_URL=https://github.com/kazukitash/dotfiles.git

has() {
  type "$1" >/dev/null 2>&1
  return $?
}

e_header() {
  printf "\n\033[37;1mDOTFILES: [%s] %s\033[m\n" "$1" "$2"
}

e_log() {
  printf "\033[37mDOTFILES: [%s] %s\033[m\n" "$1" "$2"
}

e_done() {
  printf "\033[32mDOTFILES: [%s] ✔\033[m  \033[37m%s\033[m - \033[32mOK\033[m\n" "$1" "$2"
}

e_error() {
  printf "\033[31mDOTFILES: [%s] ✖\033[m  \033[37m%s\033[m - \033[31mFailed\033[m\n" "$1" "$2" 1>&2
}

check_result() {
  if [ $1 -eq 0 ]; then
    e_done "$2" "$3 completed"
  else
    e_error "$2" "$3 failed"
    exit 1
  fi
}

install_xcodecli_if_macos() {
  if [ "$(uname)" = "Darwin" ]; then
    e_header "XCode CLI tools" "Install"

    e_log "XCode CLI tools" "Checking existance..."
    xcode-select -p &>/dev/null
    if [ $? -ne 0 ]; then
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

install_homebrew() {
  e_header "Homebrew" "Install"

  e_log "Homebrew" "Checking existance..."
  if has "brew"; then
    e_done "Homebrew" "Already installed"
  else
    e_log "Homebrew" "Installing..."
    HOMEBREW_INSTALL_FROM_API=1 NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    check_result $? "Homebrew" "Install"
    if [ "$(uname)" = "Linux" ]; then
      export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
    fi
  fi
}

install_git() {
  e_header "Git" "Install"

  if has "git"; then
    e_done "Git" "Already installed"
  else
    e_log "Git" "Installing..."
    brew install git
    check_result $? "Git" "Install"
  fi
}

# macOSとLinuxのみ実行
check_os() {
  case "$(uname)" in
  "Darwin")
    e_log "Dotfiles" "Start installation for macOS"
    ;;
  "Linux")
    e_log "Dotfiles" "Start installation for Linux"
    ;;
  *)
    e_error "Dotfiles" "Unknown OS. Abort the process"
    exit 1
    ;;
  esac
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
  make update
  check_result $? "Dotfiles" "Update"

  e_log "Dotfiles" "Deploying..."
  make deploy
  check_result $? "Dotfiles" "Deploy"
}

install_formulas() {
  e_header "Homebrew" "Install formulas"

  brew bundle --global
  check_result $? "Homebrew" "Install formulas"
}

setup_zsh_completion() {
  case "$(uname)" in
  "Darwin")
    chmod 755 /usr/local/share/zsh/site-functions
    chmod 755 /usr/local/share/zsh
    ;;
  "Linux")
    chmod 755 /home/linuxbrew/.linuxbrew/share
    ;;
  esac
}

setup_git() {
  e_header "Git" "Setup"

  if [ -n "${REMOTE_CONTAINERS:-}" ]; then
    e_log "Git" "Setting safe directory..."
    git config --global --add safe.directory '*'
  fi

  if [ "$(uname)" = "Darwin" ]; then
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
download_dotfiles
deploy_dotfiles
install_formulas
setup_zsh_completion
setup_git
