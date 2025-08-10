#!/bin/zsh
# 開発ツールの設定

# has関数が未定義の場合はutil.shを読み込む
if ! command -v has > /dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# もしnpmがインストールされていればnpmの補完を有効にする
if has npm; then
  source <(npm completion)
fi
