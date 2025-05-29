# zshrcはインタラクティブシェルで起動した時に何度でも実行される

# 色の設定
autoload -Uz colors && colors

# brewの有無をチェック
if command -v brew >/dev/null 2>&1; then
  # zsh-completionsの設定
  if brew list zsh-completions >/dev/null 2>&1; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit && compinit
    zstyle ':completion:*' menu select                                                             # 補完候補を選択できるようにする
    zstyle ':completion:*:cd:*' ignore-parents parent pwd                                          # cd時親フォルダで自フォルダを補完候補に出さないようにする
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # 補完で小文字でも大文字にマッチさせる
    zstyle ':completion:*' list-colors 'di=1;36' 'ln=35' 'so=32' 'pi=33' 'ex=31' 'bd=34;46' 'cd=34;43' 'su=0;41' 'sg=0;46' 'tw=0;42' 'ow=0;43'
  else
    echo -e "\033[31mZSHRC: [zsh-completions] ✖  Not installed - Failed\033[m" >&2
  fi

  # zsh-syntax-highlightingの設定
  if brew list zsh-syntax-highlighting >/dev/null 2>&1; then
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  else
    echo -e "\033[31mZSHRC: [zsh-syntax-highlighting] ✖  Not installed - Failed\033[m" >&2
  fi
fi

# プロンプト設定のための関数と変数
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git                 # gitのみ有効
zstyle ':vcs_info:git:*' check-for-changes true # commitしていない変更をチェックする
zstyle ':vcs_info:git:*' formats "%b%c%u"       # 変更とリポジトリ情報を表示
zstyle ':vcs_info:git:*' actionformats "%b|%a " # コンフリクト情報を表示
zstyle ':vcs_info:git:*' stagedstr " ✨"         # コミットしていない
zstyle ':vcs_info:git:*' unstagedstr " 🫧"       # addしていない

git_info_push() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    if git rev-parse HEAD >/dev/null 2>&1; then
      local head="$(git rev-parse HEAD)"
      for remote in $(git rev-parse --remotes); do
        if [ "$head" = "$remote" ]; then return 0; fi
      done
      echo "📡"
    fi
  fi
}

git_info_stash() {
  [ "$(git stash list /dev/null 2>&1)" != "" ] && echo "🔖"
}

set_vcs_info() {
  psvar=()
  LANG=ja_JP.UTF-8 vcs_info
  [ -n "$vcs_info_msg_0_" ] && psvar[1]="$vcs_info_msg_0_ $(git_info_push)$(git_info_stash)"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
set_ver_info() {
  local ver_str=""
  local current_dir="$PWD"

  # Check for Ruby version
  while [ "$current_dir" != "/" ]; do
    if [ -f "$current_dir/.ruby-version" ]; then
      ver_str+="💎 $(ruby -v | awk '{print $2}') "
      break
    fi
    current_dir=$(dirname "$current_dir")
  done

  # Reset the directory to check Python
  current_dir="$PWD"

  # Check for Python version
  while [ "$current_dir" != "/" ]; do
    if [ -f "$current_dir/requirements.txt" ] || [ -f "$current_dir/Pipfile" ] || [ -f "$current_dir/pyproject.toml" ]; then
      if [[ -v VIRTUAL_ENV ]]; then
        local env="$(basename "$VIRTUAL_ENV")"
        ver_str+="🐍 $(python --version 2>&1 | awk '{print $2}') ($env) "
      else
        ver_str+="🐍 $(python --version 2>&1 | awk '{print $2}') "
      fi
      break
    fi
    current_dir=$(dirname "$current_dir")
  done

  # Reset the directory to check Node.js
  current_dir="$PWD"

  # Check for Node.js version
  while [ "$current_dir" != "/" ]; do
    if [ -f "$current_dir/package.json" ]; then
      ver_str+="📟 $(node -v | sed 's/v//') "
      break
    fi
    current_dir=$(dirname "$current_dir")
  done

  psvar[2]="$ver_str"
}

# 時間に応じて時計の絵文字を返す関数 - シンプルに直接マッピング
get_clock_emoji() {
  local hour=$(date +%-I) # 12時間制 (1-12)
  local minute=$(date +%-M)

  # 時計の絵文字をマッピング
  case $hour in
  1) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕜" || echo "🕐" ;;
  2) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕝" || echo "🕑" ;;
  3) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕞" || echo "🕒" ;;
  4) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕟" || echo "🕓" ;;
  5) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕠" || echo "🕔" ;;
  6) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕡" || echo "🕕" ;;
  7) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕢" || echo "🕖" ;;
  8) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕣" || echo "🕗" ;;
  9) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕤" || echo "🕘" ;;
  10) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕥" || echo "🕙" ;;
  11) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕦" || echo "🕚" ;;
  12) [[ $minute -ge 15 && $minute -lt 45 ]] && echo "🕧" || echo "🕛" ;;
  esac
}

# RPROMPTを動的に設定する関数
set_rprompt() {
  RPROMPT="$c_time%D{%y.%m.%d %H:%M:%S} $(get_clock_emoji)"
}

# 色の設定とプロンプトの設定
c_normal="%{%F{white}%}"
c_git="%{%F{magenta}%}"
c_path="%{%F{yellow}%}"
c_host="%{%F{blue}%}"
c_prompt="%{%F{green}%}"
c_runtime="%{%F{cyan}%}"
c_time="%{%F{white}%}"

[[ ${UID} -eq 0 ]] && c_prompt="%{%F{red}%}"

PROMPT="$c_host%n@%m $c_path%~ $c_runtime%2(v|%2v|)$c_git%1(v|%1v|)
$c_prompt❯$c_normal "                                                             # 通常入力
PROMPT2="$c_prompt%_ >$c_normal "                                                 # 複数行入力（for, while）
SPROMPT="zsh: correct '$c_prompt%R$c_normal' to '$c_prompt%r$c_normal ' [nyae]? " # 入力ミス時

# タイトルバーの設定
[[ "${TERM}" == xterm* ]] && precmd() {
  echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}

add-zsh-hook precmd set_vcs_info
add-zsh-hook precmd set_ver_info
add-zsh-hook precmd set_rprompt

# fzfで履歴を検索する関数
fzf-history-widget() {
  local selected
  # fc -l 1 で全履歴を取得し、fzf --tac で逆順に
  selected=$(
    fc -l 1 |
      fzf --tac --height 40% --reverse --query="$LBUFFER"
  )
  if [[ -n $selected ]]; then
    BUFFER=${selected##*[[:space:]]} # 行番号（*付きを含む）とスペースを削る
    CURSOR=${#BUFFER}                # カーソルを行末へ
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
      git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads |
        perl -pne 's{^refs/heads/}{}' |
        awk '{print "\033[32m" $0 "\033[0m"}'

      git for-each-ref --format='%(refname)' --sort=-committerdate refs/remotes |
        perl -pne 's{^refs/remotes/([^/]+)/(.+)}{$2 (\1)}' |
        grep -v HEAD |
        awk '{print "\033[36m" $0 "\033[0m"}'
    ) |
      fzf --height 40% --reverse --ansi --query "$LBUFFER"
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
    find . -type d \( -name .git -o -name node_modules \) -prune -o -type d -print 2>/dev/null |
      awk -F/ '{ print (NF-1) "\t" $0 }' |
      sort -t$'\t' -k1,1n -k2,2 |
      cut -f2 |
      fzf --height 40% --reverse --query="$LBUFFER"
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
zle -N zi

# キーバインド man zshzle https://news.mynavi.jp/techplus/article/techp5581/
# showkey -a で確認できる
# キーバインド設定
bindkey -e
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey '^R' fzf-history-widget
bindkey "^G" fzf-git-branch-widget
bindkey '^T' fzf-cd-widget
bindkey '^Z' zi
if isArch WSL; then
  bindkey "^[[H" beginning-of-line # Home key
  bindkey "^[[F" end-of-line       # End key
  bindkey -s "^[[3~" "\u0004"      # Delete key
  bindkey "^[[1;2F^X" kill-line    # Ctrl K key
fi

# lscolors設定
export LSCOLORS=Gxfxcxdxbxegedabagacad # lscolor generator: http://geoff.greer.fm/lscolors/

# オプション設定
unsetopt PROMPT_SP
setopt correct            # 間違いを指摘
setopt auto_menu          # 補完キー連打で順に補完候補を自動で補完
setopt mark_dirs          # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt nolistbeep         # zshは鳴かない
setopt auto_pushd         # 移動dirを一覧表示
setopt list_packed        # 補完候補を詰めて表示
setopt menu_complete      # 補完の絞り込み
setopt share_history      # 履歴のプロセス間共有
setopt print_eight_bit    # 日本語ファイル名を表示可能にする
setopt complete_in_word   # 語の途中でもカーソル位置で補完
setopt auto_param_slash   # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt noautoremoveslash  # パス末尾の / を勝手に取らないようにする
setopt always_last_prompt # カーソル位置は保持したままファイル名一覧を順次その場で表示

# もしnpmがインストールされていればnpmの補完を有効にする
if command -v npm >/dev/null 2>&1; then
  source <(npm completion)
fi

export EDITOR="code"

# pnpm
export PNPM_HOME="/Users/kazukitash/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
