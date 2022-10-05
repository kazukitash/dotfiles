# インンタラクティブシェルでもSSHでつないだシェルでも常に実行される
# 言語環境設定
export LANG=ja_JP.UTF-8

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

alias bubu='brew update && brew outdated && brew upgrade && brew cleanup'
alias ga='git add'
alias gcm='git commit -m'
alias gpp='git pull && git push'
alias grhh='git reset --hard HEAD'
alias history='fc -l 1'
alias l='ls -lahp'
alias ls='ls -Gp'
alias mcm='make clean; make'
alias code='code -a'

# Python
alias python2='/usr/bin/python'

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
[ "$(uname)" = "Linux" ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
[ "$(uname)" = "Linux" ] && [ "$(uname -r)" = *microsoft* ] && PATH=/mnt/c/Users/kazuki/AppData/Local/Programs/Microsoft\ VS\ Code/bin:$PATH

(type anyenv >/dev/null 2>&1) && eval "$(anyenv init -)"
