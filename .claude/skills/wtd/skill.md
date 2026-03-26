---
name: wtd
description: |
  現在の worktree を削除して元のリポジトリに戻る。
  worktree の削除・worktree セッションの終了・作業完了後のクリーンアップ時に使用する。
---

# Worktree Delete Skill

現在の worktree を削除して元のリポジトリに戻る。

## 実行手順

1. `ExitWorktree` ツールを `action: "remove"` で実行する
2. 未コミットの変更やコミットがあると警告が出るので、ユーザーに確認してから `discard_changes: true` で再実行する
