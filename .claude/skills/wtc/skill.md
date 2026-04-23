---
name: wtc
description: |
  phantom で worktree を作成し指定ブランチを checkout する。ブランチ名を引数として受け取る。
  worktree の作成・ブランチの隔離作業・新しい feature ブランチでの作業開始時に使用する。
---

# Worktree Create Skill

引数のブランチ名で phantom 管理の worktree を作成する。

- **既存ブランチ**（リモート or ローカルに存在）→ `phantom attach <branch>`
- **新規ブランチ** → `phantom create <branch> --base <base>`（デフォルト base は `main`）

`phantom.config.json` を持つリポジトリ（wklr-mono / wklr-terraform 等）では `postCreate` の hook（copyFiles、setup-worktree-env.sh、./init など）が自動で走る。

## 実行手順

1. `git fetch origin <branch>` でリモートの最新を取り込む（失敗しても続行）
2. 以下いずれかでブランチの存在を判定する
   - `git rev-parse --verify refs/heads/<branch>` でローカル存在確認
   - `git ls-remote --exit-code --heads origin <branch>` でリモート存在確認
3. 存在する場合: `phantom attach <branch>`
4. 存在しない場合: `phantom create <branch> --base <base>`
5. `phantom where <branch>` で worktree の絶対パスを取得する
6. 取得したパスと、作成されたブランチ名をユーザーに報告する

## 注意事項

- Claude の Bash tool は呼び出しごとに cwd がリセットされる。worktree 内で後続作業する場合は各 Bash コマンドで `cd <worktree-path> && ...` を前置するか、ユーザーに別セッションを開くよう案内する
- ブランチ名に `/` が含まれる場合（例 `feature/sv-2617`）は phantom の worktree name にそのまま渡って問題ない。内部的に `/` を含むサブディレクトリが生成される
- `phantom.config.json` が無いリポジトリでは phantom のデフォルト挙動（`.git/phantom/worktrees/` 配下）で作成される

## 引数

- 第 1 引数（必須）: checkout するブランチ名（例: `feature/sv-2617`）
- `--base <branch>`: ベースブランチを指定する（デフォルト: `main`）。新規ブランチ作成時のみ使用される
