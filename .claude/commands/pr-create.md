---
name: pr-create
description: git-commit-helperエージェントを使用してConventional Commitsに準拠したgitコミットを作成しながら、git-pr-createrエージェントを使用してドラフトPRを作成する
---

# PR Create Skill

現在の変更からPRを作成してください。コミットはConventional Commitsに準拠した形で行い、PRはドラフトPRとして作成してください。

特に指定がなければ現在のブランチでドラフト PR を作成してください。指定がある場合はブランチを適切に切り分けてドラフト PR を作成してください。

コミット時のポイントは以下です。

- 現在のgitステータスと変更内容を分析
- 論理的な単位でコミットを分割
- Conventional Commitsに準拠したコミットメッセージを作成

PR作成時のポイントは以下です。

- 変更内容の分析と要約
- 適切なタイトルと説明の生成
- ドラフト PR の作成
