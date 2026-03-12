#!/bin/bash
# tmux ウィンドウタイトルを Git ルートディレクトリ名 + Linear Issue ID で更新
# 引数: $1 = 対象ディレクトリパス, $2 = tmux window ID

path="$1"
window_id="$2"

root=$(cd "$path" && git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ]; then
  title=$(basename "$root")
  branch=$(cd "$path" && git branch --show-current 2>/dev/null)
  if [ "$branch" = "main" ]; then
    title="$title:main"
  else
    # ブランチ名から Linear Issue ID を抽出（例: sv-1234, ENG-56）
    issue=$(echo "$branch" | grep -oiE '[a-zA-Z]+-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
    [ -n "$issue" ] && title="$title:$issue"
  fi
else
  title=$(basename "$path")
fi

tmux rename-window -t "$window_id" "$title"
