#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

install_node() {
  e_header "Install Node.js" "Start installation Node.js via mise"

  # miseの存在チェック
  e_log "Install Node.js" "Checking mise existance..."
  if ! has mise; then
    e_error "Install Node.js" "mise is not installed. Please install mise first via Homebrew."
    exit 1
  fi

  # Node.jsの最新LTSバージョンをグローバルにインストール
  e_log "Install Node.js" "Installing Node.js LTS globally..."
  mise use --global node@lts
  check_result $? "Install Node.js" "Install Node.js LTS"

  # インストールされたバージョンを確認
  e_log "Install Node.js" "Checking installed Node.js version..."
  mise exec -- node --version
  check_result $? "Install Node.js" "Check Node.js version"
}

install_node
