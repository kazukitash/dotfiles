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
2. `pwd` と `git branch --show-current` で作業ディレクトリが worktree に切り替わったことを確認する
   - 切り替わっていない場合: `cd <worktree パス>` で移動する（パスは `EnterWorktree` の結果に含まれる）
3. `git fetch origin <ブランチ名>` でリモートブランチを取得する
4. リモートに存在する場合: `git checkout <ブランチ名>` で checkout する
5. リモートに存在しない場合: `git checkout -b <ブランチ名> origin/<ベース>` で新規ブランチを作成する

## 注意事項

- `EnterWorktree` は `worktree-<name>` という一時ブランチを作成する。目的のブランチは手順 4 or 5 で改めて checkout する
- checkout 後、`git branch --show-current` で目的のブランチになっていることを最終確認する

## 引数

- 第1引数（必須）: checkout するブランチ名（例: `feature/sv-2617`）
- `--base <branch>`: ベースブランチを指定する（デフォルト: `main`）。新規ブランチ作成時に使用される
