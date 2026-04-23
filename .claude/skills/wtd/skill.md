---
name: wtd
description: |
  phantom で現在の worktree を削除して元のリポジトリに戻る。
  worktree の削除・worktree セッションの終了・作業完了後のクリーンアップ時に使用する。
---

# Worktree Delete Skill

現在の cwd が phantom 管理下の worktree であれば、primary worktree に戻ってから phantom delete で削除する。

`phantom delete --current` は削除直後に cwd が消えて Bash tool の次呼び出しが失敗するため使わず、primary 側から外部削除する方針を取る。

## 実行手順

1. 現在の worktree 情報を記録する
   ```bash
   WORKTREE_PATH=$(pwd)
   NAME=$(basename "$WORKTREE_PATH")
   ```
2. primary worktree のパスを取得する
   ```bash
   PRIMARY=$(git worktree list --porcelain | awk '/^worktree /{print $2; exit}')
   ```
3. `$WORKTREE_PATH` が `$PRIMARY` と一致するなら「primary worktree は削除対象外」として終了する
4. primary に移動して削除する
   ```bash
   cd "$PRIMARY" && phantom delete "$NAME"
   ```
5. 未コミットの変更やコミットがあって削除が拒否された場合: ユーザーに確認してから `--force` で再実行する
   ```bash
   cd "$PRIMARY" && phantom delete "$NAME" --force
   ```
6. 削除完了後、以降の Bash コマンドでは `$PRIMARY` のパスを絶対パスで使うよう明示する（現在の Claude セッションの cwd は既に存在しないため）

## 注意事項

- 削除後の Bash は `cd <primary-path> && ...` のように絶対パスを前置する
- `phantom.config.json` に `preDelete.commands` がある場合（wklr-mono の `docker compose down` 等）は phantom 側で自動実行される
