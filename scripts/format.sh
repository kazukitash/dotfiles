#!/bin/bash -eu

# shellcheck source=./help.sh
source "$(dirname "$0")/help.sh"

# shfmtがインストールされているか確認
if ! command -v shfmt >/dev/null 2>&1; then
  e_error "shfmt is not installed. Please install it first:"
  e_log "  brew install shfmt"
  exit 1
fi

# フォーマット対象のディレクトリ
DOTPATH="${HOME}/.dotfiles"
TARGET_DIRS=(
  "${DOTPATH}/scripts"
  "${DOTPATH}/.config/zsh"
)

# フォーマットオプション
# -i 2: インデントを2スペースに設定
# -ci: case文のインデントを有効化
# -sr: リダイレクトの前後にスペースを追加
# -bn: バイナリ演算子の改行を許可
# -w: ファイルを上書き
SHFMT_OPTIONS="-i 2 -ci -sr -bn"

e_header "Formatting shell scripts with shfmt"

# 各ディレクトリのシェルスクリプトをフォーマット
for dir in "${TARGET_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    e_log "Formatting scripts in: $dir"
    
    # .shファイルと実行可能なシェルスクリプトを検索
    find "$dir" -type f \( -name "*.sh" -o -name "*.zsh" -o -perm +111 \) | while read -r file; do
      # シバンをチェックしてシェルスクリプトか確認
      if head -1 "$file" | grep -qE '^#!/(usr/)?bin/(ba)?sh' || head -1 "$file" | grep -qE '^#!/(usr/)?bin/zsh'; then
        e_log "  Formatting: $(basename "$file")"
        if [ "$1" = "--check" ] 2>/dev/null || false; then
          # チェックモード（変更が必要かどうかを確認）
          if ! shfmt $SHFMT_OPTIONS -d "$file" >/dev/null 2>&1; then
            e_error "  Format required: $file"
            exit 1
          fi
        else
          # フォーマット実行
          shfmt $SHFMT_OPTIONS -w "$file"
        fi
      fi
    done
  fi
done

e_done "Format completed!"

# --checkオプションが指定された場合のメッセージ
if [ "${1:-}" = "--check" ]; then
  e_done "All files are properly formatted!"
fi