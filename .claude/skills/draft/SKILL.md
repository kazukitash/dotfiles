---
name: draft
description: |
  現在のブランチからドラフト PR を作成する。変更内容を分析しタイトルと本文を自動生成する。
  ドラフト PR の作成・PR の下書き時に使用する。
context: fork
agent: git-draft
---

# Draft PR Create Skill

現在のブランチをgit-draftエージェントを使用してドラフト PR として作成してください

ポイントは以下です。

- 変更内容の分析と要約
- 適切なタイトルと説明の生成
- ドラフト PR の作成
