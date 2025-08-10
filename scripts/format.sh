#!/bin/bash -eu

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTPATH="$(dirname "$SCRIPT_DIR")"

# util.shを読み込む
. "$DOTPATH"/.config/zsh/lib/util.sh

# フォーマット対象のディレクトリ
TARGET_DIRS=(
  "${DOTPATH}/scripts"
  "${DOTPATH}/.config/zsh"
)

# shfmtがインストールされているか確認
if ! command -v shfmt > /dev/null 2>&1; then
  e_error "shfmt is not installed. Please install it first:"
  e_log "Install" "  brew install shfmt"
  exit 1
fi

# フォーマットオプション
# -i 2: インデントを2スペースに設定
# -ci: case文のインデントを有効化
# -sr: リダイレクトの前後にスペースを追加
# -bn: バイナリ演算子の改行を許可
# -w: ファイルを上書き
SHFMT_OPTIONS="-i 2 -ci -sr -bn"

e_header "Format" "Formatting shell scripts with shfmt"

# 各ディレクトリのシェルスクリプトをフォーマット
for dir in "${TARGET_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    e_log "Format" "Formatting scripts in: $dir"

    # .shファイルと実行可能なシェルスクリプトを検索
    find "$dir" -type f \( -name "*.sh" -o -name "*.zsh" -o -perm +111 \) | while read -r file; do
      # シバンをチェックしてシェルスクリプトか確認
      if head -1 "$file" | grep -qE '^#!/(usr/)?bin/(ba)?sh' || head -1 "$file" | grep -qE '^#!/(usr/)?bin/zsh'; then
        e_log "Format" "  Formatting: $(basename "$file")"
        if [ "${1:-}" = "--check" ]; then
          # チェックモード（変更が必要かどうかを確認）
          if ! shfmt $SHFMT_OPTIONS -d "$file" > /dev/null 2>&1; then
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

e_done "Format" "Format completed!"

# --checkオプションが指定された場合のメッセージ
if [ "${1:-}" = "--check" ]; then
  e_done "Format" "All files are properly formatted!"
fi
