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

git_info_push() {
  if git remote >/dev/null 2>&1; then
    local head="$(git rev-parse HEAD)"
    for remote in $(git rev-parse --remotes); do
      if [ "$head" = "$remote" ]; then return 0; fi
    done
    echo "~"
  fi
}

git_info_stash() {
  [ "$(git stash list /dev/null 2>&1)" != "" ] && echo "#"
}

zstyle ':vcs_info:*' enable git                 # gitのみ有効
zstyle ':vcs_info:git:*' check-for-changes true # commitしていない変更をチェックする
zstyle ':vcs_info:git:*' formats "%b%c%u"       # 変更とリポジトリ情報を表示
zstyle ':vcs_info:git:*' actionformats "%b|%a " # コンフリクト情報を表示
zstyle ':vcs_info:git:*' stagedstr "*"          # コミットしていない
zstyle ':vcs_info:git:*' unstagedstr "+"        # addしていない
set_vcs_info() {
  psvar=()
  LANG=ja_JP.UTF-8 vcs_info
  [ -n "$vcs_info_msg_0_" ] && psvar[1]=" $vcs_info_msg_0_$(git_info_push)$(git_info_stash)"
}

add-zsh-hook precmd set_vcs_info

# 色の設定とプロンプトの設定
git_color="magenta"
prompt_color="green"
path_color="yellow"
host_color="blue"

[[ ${UID} -eq 0 ]] && prompt_color="red"

PROMPT="%{%F{${host_color}}%}%n@%m%{%F{white}%}%{%F{${path_color}}%}:%~%1(v|%F{${git_color}}%1v|)
%{%F{${prompt_color}}%}%#%{%F{white}%} "                                                                             # 通常入力
PROMPT2="%{%F{${prompt_color}}%}%_ >%{%F{white}%} "                                                                  # 複数行入力（for, while）
SPROMPT="zsh: correct '%{%F{${prompt_color}}%}%R%{%F{white}%}' to '%{%F{${prompt_color}}%}%r%{%F{white}%}' [nyae]? " # 入力ミス時

# タイトルバーの設定
[[ "${TERM}" == xterm* ]] && precmd() { echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"; }

# 履歴から補完
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# キーバインド man zshzle https://news.mynavi.jp/techplus/article/techp5581/
# showkey -a で確認できる
# キーバインド設定
bindkey -e
bindkey "^[[Z" reverse-menu-complete # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^R" history-incremental-pattern-search-backward # ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
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

export EDITOR="code"
