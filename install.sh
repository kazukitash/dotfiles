#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  DOTPATH=~/.dotfiles
fi

GITHUB_URL=https://github.com/kazukitash/dotfiles.git
UTILPATH=.config/zsh/lib/util.sh
UTIL_URL=https://raw.githubusercontent.com/kazukitash/dotfiles/main/"$UTILPATH"

DOTFILES_LOGO='
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
'

# util.sh をダウンロードして読み込む
if [ -f "$DOTPATH/$UTILPATH" ]; then
  # ローカルに既にある場合は直接読み込む
  source "$DOTPATH/$UTILPATH"
else
  # リモートからダウンロードして eval で実行
  eval "$(curl -fsSL "$UTIL_URL")"
fi

# XCode CLI toolsのインストール
install_xcodecli_if_macos() {
  case "$(arch)" in
    macOS)
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
      ;;
  esac
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
    case "$(arch)" in
      macOS)
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
      Linux)
        export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
        ;;
    esac
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

install_neovim() {
  e_header "NeoVim" "Install"

  if has nvim; then
    e_done "NeoVim" "Already installed"
  else
    e_log "NeoVim" "Installing..."
    brew install neovim
    check_result $? "NeoVim" "Install"
  fi
}

download_dotfiles() {
  e_header "Dotfiles" "Download"

  e_log "Dotfiles" "Downloading..."
  if !([ -e ~/.dotfiles ]); then
    git clone "$GITHUB_URL" "$DOTPATH"
  fi
  check_result $? "Dotfiles" "Download"
}

deploy_dotfiles() {
  e_header "Dotfiles" "Deploy"

  e_log "Dotfiles" "Changing directory..."
  cd "$DOTPATH"; pwd

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
  case "$(arch)" in
    macOS)
      chmod -R go-w /opt/homebrew/share/zsh
      ;;
    Linux)
      chmod -R go-w /home/linuxbrew/.linuxbrew/share/zsh
      ;;
  esac
}

setup_git() {
  e_header "Git" "Setup"

  if [ -n "${REMOTE_CONTAINERS:-}" ]; then
    e_log "Git" "Setting safe directory..."
    git config --global --add safe.directory '*'
  fi

  case "$(arch)" in
    macOS)
      e_log "Git" "Setting credential helper..."
      git config --global credential.helper osxkeychain
      ;;
  esac
}

# main
support_check
echo "$DOTFILES_LOGO"
install_xcodecli_if_macos
install_homebrew
install_git
install_neovim
download_dotfiles
deploy_dotfiles
install_formulas
setup_zsh_completion
setup_git
