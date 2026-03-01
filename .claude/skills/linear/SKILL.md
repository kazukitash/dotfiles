---
name: linear
description: linear-issueエージェントを使用し、デフォルト条件でLinear Issueを作成（ユーザーが明示的に指示した場合は上書き可）
context: fork
agent: linear-issue
---

# Linear Issue Create Skill

デフォルト条件（assignee: kazuki takahashi / priority: High / cycle: current / project: WH 運用・不具合）で Linear Issue を作成してください。ユーザーが明示的に上書き指示した場合はその指示を優先してください。

ポイント:

- MCP で assignee / priority / cycle / project の正式名称・ID を確認してから作成
- タイトルと説明は現在のコンテキストから読み取る。難しい場合はユーザーからへ確認。条件変更の明示指示があればそれを優先
- 作成後、識別子・URL・設定フィールドを報告
