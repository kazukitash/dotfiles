#!/bin/zsh
# 言語・ロケール設定

# has関数が未定義の場合はutil.shを読み込む
if ! command -v has >/dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# 基本の言語設定
export LANG=ja_JP.UTF-8

# Linux環境での追加設定
case "$(arch)" in
  Linux)
    export LESSCHARSET=utf-8
    export LANGUAGE=ja_JP.UTF-8
    ;;
esac
