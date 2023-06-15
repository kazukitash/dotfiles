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
  printf "\n\e[33;4m%s\e[0m \e[33;1m%s\e[0m\n" "$1" "$2"
}

e_log() {
  printf "\e[37;4m%s\e[0m \e[37m%s\e[0m\n" "$1" "$2"
}

e_done() {
  printf "\e[32;4m%s\e[0m \e[32m%s - ✔  OK\e[0m\n" "$1" "$2"
}

e_error() {
  printf "\e[31;4m%s\e[0m \e[31m%s - ✖  Failed\e[0m\n" "$1" "$2" 1>&2
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
    if [ "$(uname)" = "Linux" && "$(arch)" = "aarch64" ]; then
      e_log "Homebrew" "Linux arm architecture is not supported. use apt-get instead"
      sudo apt-get update
      check_result $? "apt-get" "Update"
      sudo apt-get install -y build-essential curl file git make vim
      check_result $? "apt-get" "Install essential packages"
    else
      e_log "Homebrew" "Installing..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      check_result $? "Homebrew" "Install"
      if [ "$(uname)" = "Linux" ]; then
        export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
      else
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    fi
  fi
}

install_make() {
  e_header "Make" "Install"

  if has "make"; then
    e_done "Make" "Already installed"
  else
    e_log "Make" "Installing..."
    brew install make
    check_result $? "Make" "Install"
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

install_vim() {
  e_header "Vim" "Install"

  if has "vim"; then
    e_done "Vim" "Already installed"
  else
    e_log "Vim" "Installing..."
    if [ "$(uname)" = "Linux" ] && [ "$(arch)" = "aarch64" ]; then
      sudo apt-get install -y vim
    else
      brew install vim
    fi
    check_result $? "Vim" "Install"
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

  if ! ([ "$(uname)" = "Linux" ] && [ "$(arch)" = "aarch64" ]); then
    brew bundle --global
    check_result $? "Homebrew" "Install formulas"
  fi
}

setup_zsh_completion() {
  case "$(uname)" in
  "Darwin")
    chmod 755 /usr/local/share/zsh/site-functions
    chmod 755 /usr/local/share/zsh
    ;;
  "Linux")
    if ! [ "$(arch)" = "aarch64" ]; then
      chmod 755 /home/linuxbrew/.linuxbrew/share
    fi
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
install_make
install_git
install_vim
download_dotfiles
deploy_dotfiles
install_formulas
setup_zsh_completion
setup_git
