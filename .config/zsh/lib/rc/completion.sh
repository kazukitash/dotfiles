#!/bin/zsh
# 補完とシンタックスハイライトの設定

# has関数が未定義の場合はutil.shを読み込む
if ! command -v has > /dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# 色の設定
autoload -Uz colors && colors

# brewの有無をチェック
if has brew; then
  # zsh-completionsの設定
  if brew list zsh-completions > /dev/null 2>&1; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit && compinit
    # 基本の補完動作
    zstyle ':completion:*' menu no                                                                 # fzf-tab使用のため標準メニューは無効化
    zstyle ':completion:*:cd:*' ignore-parents parent pwd                                          # cd時親フォルダで自フォルダを補完候補に出さないようにする
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # 補完で小文字でも大文字にマッチさせる
    zstyle ':completion:*' list-colors 'di=1;36' 'ln=35' 'so=32' 'pi=33' 'ex=31' 'bd=34;46' 'cd=34;43' 'su=0;41' 'sg=0;46' 'tw=0;42' 'ow=0;43'
    zstyle ':completion:*' completer _complete _match _approximate _expand _path_files _value _default _assign  # 曖昧マッチを許容
    zstyle ':completion:*:approximate:*' max-errors 2                                              # 曖昧マッチの許容誤字数
    zstyle ':completion:*:assign:*:*:*' tag-order 'parameters-words files'

    # 見た目の強化（グループ化・説明表示）
    zstyle ':completion:*' group-name ''                                                           # タイプ別にグループ化
    zstyle ':completion:*' verbose yes                                                             # オプション説明を詳しく表示
    zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'                              # 各グループにラベル
    zstyle ':completion:*:messages' format '%F{magenta}-- %d --%f'
    zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

    # エイリアスに補完を引き継ぐ
    compdef ph=phantom
    compdef pn=pnpm

    # terraform (HashiCorp製ツールはbash style補完のためbashcompinitが必要)
    if has terraform; then
      autoload -U +X bashcompinit && bashcompinit
      complete -o nospace -C "$(command -v terraform)" terraform tf
    fi
  else
    echo -e "\033[31mZSHRC: [zsh-completions] ✖  Not installed - Failed\033[m" >&2
  fi

  # fzf-tabの設定 (compinit後・zsh-syntax-highlighting前にsourceする必要がある)
  if brew list fzf-tab > /dev/null 2>&1; then
    source $(brew --prefix)/share/fzf-tab/fzf-tab.zsh
    # fzf-tab用の追加zstyle
    zstyle ':fzf-tab:*' use-fzf-default-opts yes                                                   # FZF_DEFAULT_OPTSを尊重
    zstyle ':fzf-tab:*' switch-group '<' '>'                                                       # <>キーでグループ切替
    zstyle ':completion:*:git-checkout:*' sort false                                               # gitブランチの並び順を保持
  else
    echo -e "\033[31mZSHRC: [fzf-tab] ✖  Not installed - Failed\033[m" >&2
  fi

  # zsh-syntax-highlightingの設定
  if brew list zsh-syntax-highlighting > /dev/null 2>&1; then
    export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  else
    echo -e "\033[31mZSHRC: [zsh-syntax-highlighting] ✖  Not installed - Failed\033[m" >&2
  fi
fi
