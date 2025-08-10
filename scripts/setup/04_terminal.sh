#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

setup_terminal() {
  e_header "Setup Terminal.app" "Start configuring Terminal.app"

  # macOS以外またはCI環境ではスキップ
  if [ "$(arch)" != "macOS" ] || [ "${CI:-false}" = "true" ]; then
    e_done "Setup Terminal.app" "Skipped (not macOS or CI environment)"
    return 0
  fi

  # Terminal.appが存在するか確認
  if [ ! -d "/Applications/Utilities/Terminal.app" ]; then
    e_error "Setup Terminal.app" "Terminal.app not found"
    return 1
  fi

  # プロファイルファイルの存在確認
  local profile_file="$DOTPATH/share/Yawaraka.terminal"
  if [ ! -f "$profile_file" ]; then
    e_error "Setup Terminal.app" "Profile file not found: $profile_file"
    return 1
  fi

  e_log "Setup Terminal.app" "Importing Yawaraka profile..."
  
  # プロファイルをインポート
  open "$profile_file"
  check_result $? "Setup Terminal.app" "Import profile"

  # デフォルトプロファイルとして設定
  e_log "Setup Terminal.app" "Setting Yawaraka as default profile..."
  defaults write com.apple.Terminal "Default Window Settings" -string "Yawaraka"
  check_result $? "Setup Terminal.app" "Set default profile"
  
  defaults write com.apple.Terminal "Startup Window Settings" -string "Yawaraka"
  check_result $? "Setup Terminal.app" "Set startup profile"

  e_done "Setup Terminal.app" "Terminal.app configured successfully"
  e_log "Setup Terminal.app" "Please restart Terminal.app to apply changes"
}

setup_terminal