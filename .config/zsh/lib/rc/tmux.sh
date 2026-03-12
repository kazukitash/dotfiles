# tmux が存在し、tmux セッション外で、ターミナルアプリまたは SSH からの起動時に自動アタッチ
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]] && [[ -n "$TERM_PROGRAM" || -n "$SSH_CONNECTION" ]]; then
  # 既存セッションがあればアタッチ、なければ新規作成
  tmux attach-session 2>/dev/null || tmux new-session
fi

# tmux ウィンドウタイトルに Git ルートディレクトリ名と Linear Issue ID を表示
if [[ -n "$TMUX" ]]; then
  _tmux_update_window_title() {
    "$HOME/.config/tmux/update-window-title.sh" "$PWD" "$(tmux display-message -p '#{window_id}')"
  }
  add-zsh-hook precmd _tmux_update_window_title
fi
