---
name: wtc
description: |
  Worktree を作成し指定ブランチを checkout する。ブランチ名を引数として受け取る。
  worktree の作成・ブランチの隔離作業・新しい feature ブランチでの作業開始時に使用する。
---

# Worktree Create Skill

引数で渡されたブランチ名を使って worktree を作成し、そのブランチを checkout する。

## 実行手順

1. `EnterWorktree` ツールで worktree を作成する（name はブランチ名からプレフィックスを除いた短い名前にする）
2. `git fetch origin <ブランチ名>` でリモートブランチを取得する
3. リモートに存在する場合: `git checkout <ブランチ名>` で checkout する
4. リモートに存在しない場合: `git checkout -b <ブランチ名> origin/main` で main ベースの新規ブランチを作成する

## 引数

- 第1引数（必須）: checkout するブランチ名（例: `feature/sv-2617`）
- `--base <branch>`: ベースブランチを指定する（デフォルト: `main`）。新規ブランチ作成時に使用される
