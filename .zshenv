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
setopt auto_cd          # cdなしで移動
setopt globdots         # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt brace_ccl        # 範囲指定できるようにする。例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt no_global_rcs    # macOSの/etc/zprofileに余計なことが書いてあるので読まない
setopt hist_ignore_dups # 重複した履歴を残さない

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

if isArch WSL; then
  PATH=/mnt/c/Users/kazuki/AppData/Local/Programs/Microsoft\ VS\ Code/bin:$PATH
  LD_LIBRARY_PATH=/usr/local/cuda-11/lib64:/usr/lib/wsl/lib:$LD_LIBRARY_PATH
  PATH=/usr/local/cuda/bin:$PATH
  export TF_CPP_MIN_LOG_LEVEL=3
fi

# 個人用のPATH
export PATH=~/.local/bin:$PATH
# AnyenvのPATH
export PATH=~/.anyenv/envs/pyenv/shims:$PATH

# homebrewの設定
if isArch AppleSilicon; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# anyenvの設定
if isArch macOS || isArch IntelLinux; then
  if type anyenv >/dev/null 2>&1; then
    eval "$(anyenv init -)"
  fi
fi

# openjdkの設定
if isArch macOS; then
  export CPPFLAGS="-I/usr/local/opt/openjdk/include"
  export PATH=/usr/local/opt/openjdk/bin:$PATH
fi

# エイリアスの設定
alias bubu="brew update && brew outdated && brew upgrade && brew cleanup"
alias ga="git add"
alias gcm="git commit -m"
alias grhh="git reset --hard HEAD"
alias grsh="git reset --soft HEAD^"
alias l="ls -lahp"
alias ls="ls -Gp"
alias pyinit="python -m venv .env && . ./.env/bin/activate && pip install --upgrade pip && pip install -r requirements.txt"
alias activate=". ./.venv/bin/activate"
if ! (has code) && has code-insiders; then
  alias code="code-insiders"
fi
if isArch WSL; then
  alias open=/mnt/c/Windows/explorer.exe
fi
