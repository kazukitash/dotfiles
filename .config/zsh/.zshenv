# zshenvは全てのzshセッションで読み込まれる設定ファイル
# - インタラクティブシェル / 非インタラクティブシェル
# - ログインシェル / 非ログインシェル
# - スクリプト実行時

# util.shを読み込む
[ -r "$ZDOTDIR/lib/util.sh" ] && source "$ZDOTDIR/lib/util.sh"

# env内のすべての設定ファイルを読み込む
for file in $ZDOTDIR/lib/env/*.sh; do
  [ -r "$file" ] && source "$file"
done
