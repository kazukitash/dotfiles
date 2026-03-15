# Worktree ワークフロー

- Plan mode 終了後、コードを変更する前に必ず `EnterWorktree` で worktree に入ること
- worktree 内で実装・テスト・コミットを完了させること
- 作業完了後は `ExitWorktree`（action: "keep"）で抜け、ユーザーに結果を報告すること
