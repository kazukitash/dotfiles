# tmux が存在し、tmux セッション外で、ターミナルアプリまたは SSH からの起動時に自動アタッチ
if command -v tmux &>/dev/null && [[ -z "$TMUX" ]] && [[ -n "$TERM_PROGRAM" || -n "$SSH_CONNECTION" ]]; then
  # 既存セッションがあればアタッチ、なければ新規作成
  tmux attach-session 2>/dev/null || tmux new-session
fi

# tmux ウィンドウタイトルに Git ルートディレクトリ名とブランチ名を表示
if [[ -n "$TMUX" ]]; then
  _tmux_update_window_title() {
    local git_root branch title issue_id
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n "$git_root" ]]; then
      title="${git_root:t}"
      branch=$(git branch --show-current 2>/dev/null)
      # ブランチ名から Linear Issue ID を抽出（例: sv-1234, ENG-56）
      if [[ "$branch" =~ ([a-zA-Z]+-[0-9]+) ]]; then
        issue_id="${match[1]:u}"
        title="${title}:${issue_id}"
      fi
    else
      title="${PWD:t}"
    fi
    tmux rename-window "$title"
  }
  add-zsh-hook precmd _tmux_update_window_title
fi
