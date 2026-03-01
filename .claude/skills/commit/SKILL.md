---
name: commit
description: git-commitエージェントを使用してConventional Commitsに準拠したgitコミットを作成
context: fork
agent: git-commit
---

# Commit Skill

現在の変更をgit-commitエージェントを使用してConventional Commitsに準拠した形でコミットしてください。

ポイントは以下です。

- 現在のgitステータスと変更内容を分析
- 論理的な単位でコミットを分割
- Conventional Commitsに準拠したコミットメッセージを作成
