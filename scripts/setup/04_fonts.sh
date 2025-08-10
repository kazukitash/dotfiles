#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

install_fonts() {
  e_header "Install Fonts" "Start installing custom fonts"

  # OS別の処理
  case "$(arch)" in
    macOS)
      # フォントディレクトリの設定
      local font_source_dir="$DOTPATH/share/fonts"
      local font_dest_dir="$HOME/Library/Fonts"

      # ソースディレクトリの存在確認
      if [ ! -d "$font_source_dir" ]; then
        e_error "Install Fonts" "Font source directory not found: $font_source_dir"
        return 1
      fi

      # デスティネーションディレクトリの作成（必要な場合）
      if [ ! -d "$font_dest_dir" ]; then
        e_log "Install Fonts" "Creating font directory: $font_dest_dir"
        mkdir -p "$font_dest_dir"
        check_result $? "Install Fonts" "Create font directory"
      fi

      # フォントファイルのインストール
      e_log "Install Fonts" "Installing fonts from $font_source_dir..."

      local font_count=0
      local skip_count=0

      # .ttfと.otfファイルをインストール
      for font_file in "$font_source_dir"/*.{ttf,otf} 2>/dev/null; do
        # ファイルが存在しない場合はスキップ（globがマッチしない場合）
        [ -f "$font_file" ] || continue

        local font_name=$(basename "$font_file")
        local dest_file="$font_dest_dir/$font_name"

        # 既にインストールされている場合はスキップ
        if [ -f "$dest_file" ]; then
          e_log "Install Fonts" "Skip: $font_name (already installed)"
          ((skip_count++))
        else
          e_log "Install Fonts" "Installing: $font_name"
          cp "$font_file" "$dest_file"
          if [ $? -eq 0 ]; then
            ((font_count++))
          else
            e_error "Install Fonts" "Failed to install: $font_name"
          fi
        fi
      done

      # 結果の表示
      if [ $font_count -gt 0 ]; then
        e_done "Install Fonts" "Installed $font_count new font(s)"
      fi

      if [ $skip_count -gt 0 ]; then
        e_done "Install Fonts" "Skipped $skip_count existing font(s)"
      fi

      if [ $font_count -eq 0 ] && [ $skip_count -eq 0 ]; then
        e_log "Install Fonts" "No font files found to install"
      fi

      # フォントキャッシュのリセット（必要な場合）
      if [ $font_count -gt 0 ]; then
        e_log "Install Fonts" "Resetting font cache..."
        # macOSではフォントキャッシュは自動的に更新されるが、
        # 明示的にリセットすることも可能
        if has atsutil; then
          atsutil databases -remove 2>/dev/null || true
        fi
        e_done "Install Fonts" "Font installation completed"
      fi
      ;;
  esac
}

install_fonts
