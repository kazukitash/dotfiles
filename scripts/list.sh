#!/bin/bash -eu

# このリポジトリのdotfilesを一覧表示

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTPATH="$(dirname "$SCRIPT_DIR")"

# dotfilesの候補を取得（.で始まるファイル・ディレクトリ）
cd "$DOTPATH"
CANDIDATES=($(find . -maxdepth 1 -name ".*" -not -name "." | sort))

# 除外するファイル・ディレクトリ
EXCLUSIONS=(".DS_Store" ".git" ".gitignore" ".github" ".devcontainer.json" ".Brewfile" "scripts")

# 除外リストに含まれていないかチェックする関数
is_excluded() {
  local item="$1"
  for exclusion in "${EXCLUSIONS[@]}"; do
    if [[ "$item" == "./$exclusion" ]]; then
      return 0
    fi
  done
  return 1
}

# dotfilesをリストアップ
for candidate in "${CANDIDATES[@]}"; do
  if ! is_excluded "$candidate"; then
    # ./プレフィックスを削除
    candidate_clean="${candidate#./}"

    # .configフォルダの場合は中のファイルを全てリストアップ
    if [[ "$candidate_clean" == ".config" ]]; then
      if [[ -d "$candidate_clean" ]]; then
        find "$candidate_clean" -type f | sort
      fi
    else
      /bin/ls -dF "$candidate_clean"
    fi
  fi
done
