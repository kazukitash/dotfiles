#!/bin/bash
# エージェント通知用に tmux ペインへ BEL を送信
if [ -n "$TMUX_PANE" ]; then
  pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}')
  [ -n "$pane_tty" ] && printf '\a' > "$pane_tty" && exit 0
fi
printf '\a'
