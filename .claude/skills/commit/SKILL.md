---
name: commit
description: |
  現在の変更を Conventional Commits に準拠した形式でコミットする。論理的な単位でコミットを分割する。
  コミット作成・変更の整理・コミットメッセージの生成時に使用する。
context: fork
agent: git-commit
---

# Commit Skill

現在の変更をgit-commitエージェントを使用してConventional Commitsに準拠した形でコミットしてください。

ポイントは以下です。

- 現在のgitステータスと変更内容を分析
- 論理的な単位でコミットを分割
- Conventional Commitsに準拠したコミットメッセージを作成
