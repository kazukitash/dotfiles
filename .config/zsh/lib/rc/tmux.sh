# tmux が存在し、tmux セッション外で、ターミナルアプリまたは SSH からの起動時に自動アタッチ
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]] && [[ -n "$TERM_PROGRAM" || -n "$SSH_CONNECTION" ]]; then
  # 既存セッションがあればアタッチ、なければ新規作成
  tmux attach-session 2>/dev/null || tmux new-session
fi
