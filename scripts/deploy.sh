#!/bin/bash -eu

# このリポジトリのdotfilesをHOMEディレクトリにシンボリックリンクで配置

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTPATH="$(dirname "$SCRIPT_DIR")"

# list.shのパスを取得
LIST_SCRIPT="$SCRIPT_DIR/list.sh"

# list.shが存在するかチェック
if [[ ! -f "$LIST_SCRIPT" ]]; then
  echo "Error: list.sh not found at $LIST_SCRIPT"
  exit 1
fi

# 現在のディレクトリを保存
CURRENT_DIR="$(pwd)"

# dotfilesのディレクトリに移動
cd "$DOTPATH"

echo "Deploying dotfiles from $DOTPATH to $HOME"
echo "----------------------------------------"

# list.shの出力を取得してシンボリックリンクを作成
"$LIST_SCRIPT" | while IFS= read -r item; do
  # 末尾の/を削除（ディレクトリの場合）
  item_clean="${item%/}"

  # ソースファイル/ディレクトリのフルパス
  source_path="$DOTPATH/$item_clean"

  # リンク先のパス
  target_path="$HOME/$item_clean"

  # ソースが存在するかチェック
  if [[ ! -e "$source_path" ]]; then
    echo "Warning: Source $source_path does not exist, skipping..."
    continue
  fi

  # リンク先の親ディレクトリを作成（必要に応じて）
  target_dir="$(dirname "$target_path")"
  if [[ ! -d "$target_dir" ]]; then
    echo "Creating directory: $target_dir"
    mkdir -p "$target_dir"
  fi

  # 既存のファイル/ディレクトリ/リンクをバックアップ
  if [[ -e "$target_path" ]] || [[ -L "$target_path" ]]; then
    if [[ -L "$target_path" ]]; then
      # 既存のシンボリックリンクの場合
      existing_link="$(readlink "$target_path")"
      if [[ "$existing_link" == "$source_path" ]]; then
        echo "Already linked: $target_path -> $source_path"
        continue
      else
        echo "Removing existing link: $target_path -> $existing_link"
        rm "$target_path"
      fi
    else
      # 既存のファイル/ディレクトリの場合
      backup_path="${target_path}.backup.$(date +%Y%m%d_%H%M%S)"
      echo "Backing up existing $target_path to $backup_path"
      mv "$target_path" "$backup_path"
    fi
  fi

  # シンボリックリンクを作成
  echo "Creating link: $target_path -> $source_path"
  ln -sf "$source_path" "$target_path"
done

# 元のディレクトリに戻る
cd "$CURRENT_DIR"

echo "----------------------------------------"
echo "Deployment completed!"
