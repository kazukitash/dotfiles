# インンタラクティブシェルでもSSHでつないだシェルでも常に実行される
# 言語・ロケーションの設定
export LANG=ja_JP.UTF-8
if [ "$(uname)" = "Linux" ]; then
  export LESSCHARSET=utf-8
  export LANGUAGE=ja_JP.UTF-8
  export LC_ALL=ja_JP.UTF-8
fi

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=5000000
SAVEHIST=5000000

# 拡張設定
setopt auto_cd          # cdなしで移動
setopt globdots         # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt brace_ccl        # 範囲指定できるようにする。例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt no_global_rcs    # macOSの/etc/zprofileに余計なことが書いてあるので読まない
setopt hist_ignore_dups # 重複した履歴を残さない

# エイリアスの設定
alias bubu='brew update && brew outdated && brew upgrade && brew cleanup'
alias ga='git add'
alias gcm='git commit -m'
alias grhh='git reset --hard HEAD'
alias grsh='git reset --soft HEAD^'
alias l='ls -lahp'
alias ls='ls -Gp'
alias pyinit='python -m venv .env && . ./.env/bin/activate && pip install --upgrade pip && pip install -r requirements.txt'
alias activate='. ./.env/bin/activate'
if [ "$(uname)" = "Linux" ] && [[ $(uname -r) = *microsoft* ]]; then
  alias open='/mnt/c/Windows/explorer.exe'
fi

# Pythonの設定
alias python2='/usr/bin/python'

# PATHの設定
if [ -x /usr/libexec/path_helper ]; then
  eval $(/usr/libexec/path_helper -s)
fi
export PATH=~/.bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH
export PATH=~/.anyenv/envs/pyenv/shims:$PATH
if [ "$(uname)" = "Linux" ]; then
  export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
  if [[ $(uname -r) = *microsoft* ]]; then
    PATH=/mnt/c/Users/kazuki/AppData/Local/Programs/Microsoft\ VS\ Code/bin:$PATH
    LD_LIBRARY_PATH=/usr/local/cuda-11/lib64:$LD_LIBRARY_PATH
    PATH=/usr/local/cuda/bin:$PATH
    export TF_CPP_MIN_LOG_LEVEL=3
  fi
fi

# homebrewの設定
if [ "$(uname)" = "Darwin" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# anyenvの設定
if type anyenv >/dev/null 2>&1; then
  eval "$(anyenv init -)"
fi

# openjdkの設定
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
export PATH=/usr/local/opt/openjdk/bin:$PATH
