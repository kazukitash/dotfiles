# zshrcはインタラクティブシェルで起動した時に読み込まれる設定ファイル
# - ターミナルを開いた時
# - SSH接続時（インタラクティブ）
# - スクリプトを実行する時は読み込まれない

# rc内のすべての設定ファイルを読み込む
for file in ${ZDOTDIR:-$HOME/.config/zsh}/lib/rc/*.sh; do
  [ -r "$file" ] && source "$file"
done
