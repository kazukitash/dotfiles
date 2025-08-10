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

# セキュリティチェック統合関数
# リモートからの直接実行のみを許可し、ローカル改変による予期しない動作を防ぐ
#
# 1. check_interactive_shell: インタラクティブシェルでの実行を防ぐ
#    - 目的: 対話式環境では予期しない入力待機や環境変数の影響を受ける可能性があるため
#    - 影響: 削除すると、ターミナルで直接実行した際にプロンプト待機で停止するリスク
#
# 2. check_execution_by_file: ファイル経由実行（bash install.sh）を検出し、ライブラリ読み込みのみに制限
#    - 目的: ローカルファイルが改変されている可能性を排除するため
#    - 影響: 削除すると、改変されたローカルファイルでも本格実行してしまう
#
# 3. check_execution_by_string: 文字列経由実行（bash -c "$(curl...)"またはパイプ）のみを許可
#    - 目的: リモートから直接取得した信頼できるコードのみでの実行を保証するため
#    - 影響: 削除すると、ローカル改変ファイルでも実行可能になり、意図しない動作のリスク
check_secure_execution() {
  # GitHub Actions環境の検出（CI環境では直接実行を許可）
  if [ -n "${GITHUB_ACTIONS:-}" ] || [ -n "${CI:-}" ]; then
    e_done "Check execution" "CI environment detected - continuing"
    return 0
  fi

  # 1. インタラクティブシェルチェック
  if echo "$-" | grep -q "i"; then
    e_error "Check execution" "Can not continue with interactive shell. Abort the process"
    exit 1
  fi

  # 2. ファイル実行チェック（ライブラリとして読み込まれた場合はここで終了）
  if [ "$0" = "${BASH_SOURCE:-}" ] || [ "${DOTPATH}/install.sh" = "${BASH_SOURCE:-}" ]; then
    e_done "Check execution" "Libraries are load"
    exit 0
  fi

  # 3. 文字列/パイプ実行チェック
  if !([ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]); then
    e_error "Check execution" "Can not continue with the execution type. Abort the process"
    exit 1
  fi
}

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

# オプション解析
BUILD_MODE=false
WORK_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--build)
      BUILD_MODE=true
      shift
      ;;
    -w|--work)
      WORK_MODE=true
      shift
      ;;
    -bw|-wb)
      BUILD_MODE=true
      WORK_MODE=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTION]..."
      echo ""
      echo "Options:"
      echo "  -b, --build    Install & build tools"
      echo "  -w, --work     Setup work environment"
      echo "  -h, --help     Show this help message"
      echo ""
      echo "Default behavior (no options): Deploy dotfiles only"
      echo "Options can be combined: -b -w, -bw, -wb, or --build --work"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help for usage information"
      exit 1
      ;;
  esac
done

# main
check_secure_execution
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

if $BUILD_MODE; then
  e_header "Build Environment" "Setup development environment"
  
  # setup.shを実行（etc/内のスクリプトを順次実行）
  e_log "Build Environment" "Running setup script..."
  export DOTPATH="$DOTPATH"
  /bin/bash "$DOTPATH/scripts/setup.sh"
  check_result $? "Build Environment" "Setup"
fi
