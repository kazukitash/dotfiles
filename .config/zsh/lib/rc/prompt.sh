#!/bin/zsh
# プロンプト設定

# プロンプト設定のための関数と変数
autoload -Uz vcs_info add-zsh-hook

zstyle ':vcs_info:*' enable git                 # gitのみ有効
zstyle ':vcs_info:git:*' check-for-changes true # commitしていない変更をチェックする
zstyle ':vcs_info:git:*' formats "%b%c%u"       # 変更とリポジトリ情報を表示
zstyle ':vcs_info:git:*' actionformats "%b|%a " # コンフリクト情報を表示
zstyle ':vcs_info:git:*' stagedstr " ✨"         # コミットしていない
zstyle ':vcs_info:git:*' unstagedstr " 🫧"       # addしていない

git_info_push() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    if git rev-parse HEAD > /dev/null 2>&1; then
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

# 色の設定とプロンプトの設定
c_normal="%{%F{white}%}"
c_git="%{%F{magenta}%}"
c_path="%{%F{yellow}%}"
c_host="%{%F{blue}%}"
c_prompt="%{%F{green}%}"
c_runtime="%{%F{cyan}%}"
c_time="%{%F{green}%}"

[[ ${UID} -eq 0 ]] && c_prompt="%{%F{red}%}"

PROMPT="$c_time%D{%H:%M:%S} $c_host%n@%m $c_path%~ $c_runtime%2(v|%2v|)$c_git%1(v|%1v|)
$c_prompt❯$c_normal "                                                             # 通常入力
PROMPT2="$c_prompt%_ >$c_normal "                                                 # 複数行入力（for, while）
SPROMPT="zsh: correct '$c_prompt%R$c_normal' to '$c_prompt%r$c_normal ' [nyae]? " # 入力ミス時

# タイトルバーの設定
[[ "${TERM}" == xterm* ]] && precmd() {
  echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
}

add-zsh-hook precmd set_vcs_info
add-zsh-hook precmd set_ver_info
