#!/bin/bash -eu

arch() {
  # OSとアーキテクチャを判定して返す
  local os=$(uname -s)
  local arch=$(uname -m)
  if [[ "$os" == "Darwin" && "$arch" == "arm64" ]]; then
    echo "macOS"
  elif [[ "$os" == "Linux" ]]; then
    echo "Linux"
  else
    echo "Unknown"
  fi
}

unsupported() {
  # サポートされていないOSの場合終了する
  e_error "Dotfiles" "Unsupported OS detected: $(arch). Abort the process"
  exit 1
}

# macOSとLinuxのみ実行
support_check() {
  case "$(arch)" in
    macOS | Linux)
      e_log "Dotfiles" "Start installation for $(arch)"
      ;;
    *)
      unsupported
      ;;
  esac
}

# コマンドの存在チェック
has() {
  type "$1" > /dev/null 2>&1
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
