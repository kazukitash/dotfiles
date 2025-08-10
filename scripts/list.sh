#!/bin/bash -eu

# このリポジトリのdotfilesを一覧表示

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTPATH="$(dirname "$SCRIPT_DIR")"

# dotfilesの候補を取得（.で始まるファイル・ディレクトリ）
cd "$DOTPATH"
CANDIDATES=($(find . -maxdepth 1 -name ".*" -not -name "." | sort))

# 除外するファイル・ディレクトリ
EXCLUSIONS=(".DS_Store" ".git" ".gitignore" ".github" ".devcontainer.json" "scripts" "share" "CLAUDE.md")

# 特定のディレクトリ内で除外するファイルパターン
# 形式: "ディレクトリ:除外パターン"
DIR_EXCLUSIONS=(
  ".claude:settings.local.json"
)

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

# 特定のディレクトリ内での除外パターンを取得する関数
get_dir_exclusions() {
  local dir="$1"
  local patterns=()

  for exclusion in "${DIR_EXCLUSIONS[@]}"; do
    local exc_dir="${exclusion%%:*}"
    local exc_pattern="${exclusion#*:}"

    if [[ "$dir" == "$exc_dir" ]]; then
      patterns+=("$exc_pattern")
    fi
  done

  if [[ ${#patterns[@]} -gt 0 ]]; then
    echo "${patterns[@]}"
  fi
}

# dotfilesをリストアップ
for candidate in "${CANDIDATES[@]}"; do
  if ! is_excluded "$candidate"; then
    # ./プレフィックスを削除
    candidate_clean="${candidate#./}"

    # ディレクトリの場合は中のファイルをリストアップ
    if [[ -d "$candidate_clean" ]]; then
      # このディレクトリの除外パターンを取得
      dir_exclusions=($(get_dir_exclusions "$candidate_clean"))

      if [[ ${#dir_exclusions[@]} -gt 0 ]]; then
        # 除外パターンがある場合
        grep_patterns=""
        for pattern in "${dir_exclusions[@]}"; do
          grep_patterns+=" -e $pattern"
        done
        find "$candidate_clean" -type f | grep -v $grep_patterns | sort
      else
        # 除外パターンがない場合
        find "$candidate_clean" -type f | sort
      fi
    else
      /bin/ls -dF "$candidate_clean"
    fi
  fi
done
