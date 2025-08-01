# zshenvはインンタラクティブシェルでもSSHでつないだシェルでも常に実行される

# OS/Arch.のチェック
isArch() {
  local os=$(uname -s)
  local arch=$(uname -m)
  if [[ "$os" == "Darwin" && "$arch" == "arm64" && "$1" == "AppleSilicon" ]]; then
    return 0 # true
  elif [[ "$os" == "Darwin" && "$arch" == "x86_64" && "$1" == "IntelMac" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && "$arch" == "aarch64" && "$1" == "ArmLinux" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && "$arch" == "x86_64" && "$1" == "IntelLinux" ]]; then
    return 0 # true
  elif [[ "$os" == "Linux" && $(uname -r) =~ microsoft && "$1" == "WSL" ]]; then
    return 0 # true
  elif [[ "$os" == "Darwin" && "$1" == "macOS" ]]; then
    return 0 # true
  elif [[ "$os" == "$1" ]]; then
    return 0 # true
  else
    return 1 # false
  fi
}

has() {
  type "$1" >/dev/null 2>&1
  return $?
}

# 言語・ロケーションの設定
export LANG=ja_JP.UTF-8
if isArch Linux; then
  export LESSCHARSET=utf-8
  export LANGUAGE=ja_JP.UTF-8
  # export LC_ALL=ja_JP.UTF-8
fi

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=5000000
SAVEHIST=5000000

# 拡張設定
setopt auto_cd              # cdなしで移動
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt brace_ccl            # 範囲指定できるようにする。例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt no_global_rcs        # macOSの/etc/zprofileに余計なことが書いてあるので読まない
setopt hist_ignore_all_dups # 重複した履歴を残さない
setopt share_history        # ターミナル間での履歴共有

# PATHの設定
if isArch macOS; then
  if [ -x /usr/libexec/path_helper ]; then
    eval $(/usr/libexec/path_helper -s)
  fi
elif isArch ArmLinux; then
  export PATH=$HOME/.anyenv/bin:$PATH
elif isArch IntelLinux; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
fi

# 個人用のPATH
export PATH=~/.local/bin:$PATH

# homebrewの設定
if isArch AppleSilicon; then
  # macOS
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  # linux
  eval "$(/home/.linuxbrew/bin/brew shellenv)"
fi

# Rubyの設定
export GEMRC="$HOME/.config/gem/config"

# anyenvの設定
export ANYENV_ROOT=~/.anyenv
export PATH=$ANYENV_ROOT/bin:$ANYENV_ROOT/envs/pyenv/shims:$PATH
if has anyenv; then
  eval "$(anyenv init -)"
fi

# openjdkの設定
if isArch macOS; then
  export CPPFLAGS="-I/usr/local/opt/openjdk/include"
  export PATH=/usr/local/opt/openjdk/bin:$PATH
fi

# GCPの設定
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"
export ADMINSDK_PROD="$HOME/.config/firebase/adminsdk_prod.json"
export ADMINSDK_DEV="$HOME/.config/firebase/adminsdk_dev.json"
# Google Cloud SDK
gcspath="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
if [ -f gcspath ]; then
  source "${gcspath}/path.zsh.inc"
  source "${gcspath}/completion.zsh.inc"
fi

# ryeの設定
export PATH="$HOME/.rye/shims:$PATH"
if has rye; then
  source "$HOME/.rye/env"
fi

# uvの設定
if has uv; then
  autoload -Uz compinit && compinit # (eval):4373: command not found: compdef の対策
  eval "$(uv generate-shell-completion zsh)"
fi

# kibanaの設定
if has kibana; then
  export KBN_PATH_CONF="$HOME/.config/kibana"
  # brew services start elastic/tap/kibana-full で起動できる
fi

if has zoxide; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# エイリアスの設定
alias bubu="brew update && brew outdated && brew upgrade && brew cleanup"
alias ga="git add ."
alias gs="git stash -u"
alias gsp="git stash pop"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gl="git log --pretty=oneline"
alias grhh="git reset --hard HEAD"
alias grsh="git reset --soft HEAD^"
alias gpr="git stash && git pull --rebase origin main && git stash pop"
alias l="ls -lahp"
alias ls="ls -Gp"
alias dcd="docker compose down -v"
alias pn="pnpm"
if ! (has code) && has code-insiders; then
  alias code="code-insiders"
fi
alias iris-check="pn -F iris fix && pn -F iris check"
alias wandh-check="poetry run openapi && poetry run format && poetry run lint && poetry run typecheck"
alias dev="WKLR_ES_PORT=9200 docker compose up -d nginx iris labs-wandh wklr-jobs wklr-es"
alias dev-wklr="WKLR_ES_PORT=9200 docker compose up -d nginx wklr wklr-backend-api wklr-mysql wklr-es"

# dcln (Docker CLeaN)
# 1) docker ps -q | xargs -r docker kill
#    - 実行中のコンテナをすべて停止
# 2) docker ps -aq | xargs -r docker rm
#    - 全コンテナを削除（停止中のものも含む）
# 3) docker system prune -a -f --volumes
#    - 未使用のコンテナ、ネットワーク、イメージ、ビルドキャッシュ、ボリュームを一括削除
#    - -a: 使用していないイメージも削除
#    - -f: 確認プロンプトをスキップ
#    - --volumes: 未使用のボリュームも削除
# 4) docker network prune -f
#    - 未使用のネットワークを削除
alias dcln="\
  docker ps -q | xargs -r docker kill && \
  docker ps -aq | xargs -r docker rm && \
  docker system prune -a -f --volumes && \
  docker network prune -f \
"
