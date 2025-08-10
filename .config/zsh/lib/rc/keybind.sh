#!/bin/zsh
# キーバインドとfzf設定

# fzfで履歴を検索する関数
fzf-history-widget() {
  local selected
  # fc -l 1 で全履歴を取得し、fzf --tac で逆順に
  selected=$(
    fc -l 1 \
      | fzf --tac --height 40% --reverse --query="$LBUFFER"
  )
  if [[ -n $selected ]]; then
    BUFFER=${selected:7} # 行番号とスペースを削る
    CURSOR=${#BUFFER}    # カーソルを行末へ
  fi
  for precmd_fn in $precmd_functions; do $precmd_fn; done
  zle reset-prompt
}

# fzfでgitブランチ（ローカルとリモート）を選択する関数
fzf-git-branch-widget() {
  local selected
  # git for-each-ref でローカルとリモートのブランチを取得し、fzfで選択
  # ローカルブランチは緑色、リモートブランチは青色で表示
  selected=$(
    (
      git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads \
        | perl -pne 's{^refs/heads/}{}' \
        | awk '{print "\033[32m" $0 "\033[0m"}'

      git for-each-ref --format='%(refname)' --sort=-committerdate refs/remotes \
        | perl -pne 's{^refs/remotes/([^/]+)/(.+)}{$2 (\1)}' \
        | grep -v HEAD \
        | awk '{print "\033[36m" $0 "\033[0m"}'
    ) \
      | fzf --height 40% --reverse --ansi --query "$LBUFFER"
  )
  if [ -n "$selected" ]; then
    # リモートブランチの場合、括弧内のリモート名を取り除く
    local branch=$(echo "$selected" | sed -E 's/ \([^)]+\)$//')
    BUFFER="git checkout $branch"
    zle accept-line
  fi
  for precmd_fn in $precmd_functions; do $precmd_fn; done
  zle reset-prompt
}

# カレントディレクトリ以下のディレクトリを fzf で絞り込み、選択した先へ cd
fzf-cd-widget() {
  local selected
  # ① 隠しディレクトリは除外しつつ再帰検索
  # ② fzf でインタラクティブに絞り込み（初期クエリには今のバッファ内容を）
  # 浅い階層を先に表示する
  selected=$(
    find . -type d \( -name .git -o -name node_modules \) -prune -o -type d -print 2> /dev/null \
      | awk -F/ '{ print (NF-1) "\t" $0 }' \
      | sort -t$'\t' -k1,1n -k2,2 \
      | cut -f2 \
      | fzf --height 40% --reverse --query="$LBUFFER"
  )
  if [[ -n $selected ]]; then
    BUFFER="z $selected"
    zle accept-line
  fi
  for precmd_fn in $precmd_functions; do $precmd_fn; done
  zle reset-prompt
}

zle -N fzf-history-widget
zle -N fzf-git-branch-widget
zle -N fzf-cd-widget

# キーバインド man zshzle https://news.mynavi.jp/techplus/article/techp5581/
# showkey -a で確認できる
# キーバインド設定
bindkey -e
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey '^R' fzf-history-widget
bindkey "^G" fzf-git-branch-widget
bindkey '^T' fzf-cd-widget
