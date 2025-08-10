#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

install_mise() {
  e_header "Install mise" "Start installation mise"

  # miseの存在チェック
  e_log "Install mise" "Checking existance..."
  if has mise; then
    e_done "Install mise" "Already installed"
  else
    e_log "Install mise" "Installing..."
    case "$(arch)" in
      macOS)
        # macOSではHomebrewでインストール
        brew install mise
        check_result $? "Install mise" "Install"
        ;;
      Linux)
        # Linuxでは公式インストーラーを使用
        curl https://mise.run | sh
        check_result $? "Install mise" "Install"
        # PATHに追加（一時的）
        export PATH="$HOME/.local/bin:$PATH"
        ;;
      *)
        e_error "Install mise" "Unsupported OS: $(arch)"
        exit 1
        ;;
    esac
  fi

  # Node.jsの最新LTSバージョンをグローバルにインストール
  e_log "Install mise" "Installing Node.js LTS globally..."
  mise use --global node@lts
  check_result $? "Install mise" "Install Node.js LTS"

  # インストールされたバージョンを確認
  e_log "Install mise" "Checking installed Node.js version..."
  mise exec -- node --version
  check_result $? "Install mise" "Check Node.js version"
}

install_mise