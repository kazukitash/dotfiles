#!/bin/zsh
# Python仮想環境の自動活性化

# util.shを読み込む（ログ関数のため）
if ! command -v has > /dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# 近い親ディレクトリから順に .venv/bin/activate を探す
_autovenv_find_root() {
  local d="$PWD"
  while [[ "$d" != "/" ]]; do
    if [[ -f "$d/.venv/bin/activate" ]]; then
      echo "$d"
      return 0
    fi
    d="${d:h}" # 親へ
  done
  return 1
}

_autovenv_chpwd() {
  # いま有効な venv があって、かつ専用フラグが立っているなら記録
  local current="$VIRTUAL_ENV"
  local desired_root
  desired_root="$(_autovenv_find_root)"

  if [[ -n "$desired_root" ]]; then
    local desired_venv="$desired_root/.venv"

    # すでに別の venv が有効なら切り替えのために解除
    if [[ -n "$current" && "$current" != "$desired_venv" ]]; then
      # deactivate が定義されているときのみ実行
      whence -w deactivate > /dev/null 2>&1 && deactivate
      unset AUTO_VENV_HOME
    fi

    # 目的の venv が未アクティブならアクティブ化
    if [[ "$VIRTUAL_ENV" != "$desired_venv" ]]; then
      source "$desired_venv/bin/activate"
      export AUTO_VENV_HOME="$desired_root"
      e_done "auto-venv" "Activated: $(basename "$desired_root")/.venv"
    fi
  else
    # 該当 venv が見つからないディレクトリに出たら解除
    if [[ -n "$VIRTUAL_ENV" && -n "$AUTO_VENV_HOME" ]]; then
      if whence -w deactivate > /dev/null 2>&1; then
        deactivate
        e_log "auto-venv" "Deactivated"
      fi
      unset AUTO_VENV_HOME
    fi
  fi
}

# フック登録（zsh組み込み）
if whence -w add-zsh-hook > /dev/null 2>&1; then
  add-zsh-hook chpwd _autovenv_chpwd
else
  # 古いzsh向けフォールバック
  chpwd_functions+=(_autovenv_chpwd)
fi

# シェル起動直後にも一度実行（起動ディレクトリに .venv があれば有効化）
_autovenv_chpwd
