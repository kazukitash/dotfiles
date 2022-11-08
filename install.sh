#!/bin/bash -xeu

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
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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

# shell の option を確認してインタラクティブである場合は終了する
check_interactive_shell() {
  if echo "$-" | grep -q "i"; then
    e_error "Check execution" "Can not continue with interactive shell. Abort the process"
    exit 1
  fi
}

# 実行ソースを確認して、ファイルから実行している場合（bash a.sh）はライブラリのみ読み込んで続ける。
check_execution_by_file() {
  if [ "$0" = "${BASH_SOURCE:-}" ] || [ "${DOTPATH}/install.sh" = "${BASH_SOURCE:-}" ]; then
    e_done "Check execution" "Libraries are load"
    return 1
  else
    return 0
  fi
}

# bash -c "$(cat a.sh)" もしくは cat a.sh | bash の場合実行する
# BASH_EXECUTION_STRING で -c オプションで渡された文字列を出力する。nullなら:-で空文字列に置換し-nで空文字列判定する
# パイプで渡されていたら/dev/stdinがFIFOになりパイプとして判定される
check_execution_by_string() {
  if !([ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]); then
    e_error "Check exection" "Can not continue with the execution type. Abort the process"
    exit 1
  fi
}

# macOSとLinuxのみ実行
check_os() {
  case "$(uname)" in
  "Darwin")
    e_log "Start installation for macOS"
    ;;
  "Linux")
    e_log "Start installation for Linux"
    ;;
  *)
    e_error "Unknown OS. Abort the process"
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

  e_log "Dotfiles" "Preparing for download..."
  install_xcodecli_if_macos
  install_homebrew
  install_git

  e_log "Dotfiles" "Downloading..."
  git clone --recursive "$GITHUB_URL" "$DOTPATH"
  check_result $? "Dotfiles" "Download"
}

deploy_dotfiles() {
  e_header "Dotfiles" "Deploy"

  e_log "Dotfiles" "Changing directory..."
  cd "$DOTPATH"

  e_log "Dotfiles" "Deploying..."
  make deploy
  check_result $? "Dotfiles" "Deploy"
}

install_formulas() {
  e_header "Homebrew" "Install formulas"

  brew bundle --global
  check_result $? "Homebrew" "Install formulas"
}

# main
check_interactive_shell
if check_execution_by_file; then
  check_execution_by_string
  check_os
  echo "$dotfiles_logo"
  download_dotfiles
  deploy_dotfiles
  install_formulas
fi
