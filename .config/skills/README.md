# skills（統合スキルフォルダ）

このディレクトリは Claude Code・Codex・Zed の 3 つのエージェントが共有する**唯一の編集ソース**。各ツールのスキルディレクトリはここへの symlink で、スキルの追加・編集はこの 1 箇所だけで全ツールに反映される。

## 配置と構成

```
.dotfiles/
├── .config/skills/<name>/SKILL.md   ← 実体（唯一の編集ソース）
├── .claude/skills/<name>  → symlink → ../../.config/skills/<name>   （Claude が読む）
├── .codex/skills/<name>     実体コピー（deploy.sh が .config/skills から生成）（Codex が読む）
└── .agents/skills         → symlink → ../.config/skills              （Zed が読む）
```

- 編集は `.config/skills/<name>/SKILL.md` の 1 箇所だけ。反映は `scripts/deploy.sh`。
- `.claude/skills` は**スキル単位**で symlink する（Claude は `~/.claude/skills` を読み、symlink を辿る）。Claude の dotfiles 管理外スキルを温存するため whole-dir にはしない。
- `.codex/skills` には**実体コピー**を置く。Codex CLI は**対話セッションでスキルの symlink（個別ディレクトリも、`~/.agents/skills` のようなルートも）を辿らない**バグがあるため（[openai/codex#9365](https://github.com/openai/codex/issues/9365)・[#11314](https://github.com/openai/codex/issues/11314) ほか）、`deploy.sh` が CODEX_HOME（`~/.codex/skills`）へ `cp` で実体生成する。生成物は `.gitignore` で除外し、`.system/`（Codex 組み込み）のみ追跡する。
- `.agents/skills` は Agent Skills オープン標準のグローバル配置先（`~/.agents/skills`）で **Zed が読む**。Zed は symlink を辿るためディレクトリごと symlink で問題ない。
- `scripts/list.sh` は `.agents` を `DIR_INCLUSIONS` で丸ごと配備し、`.claude` 配下の symlink は `find -L` で追跡して配備する。

## スキルの書式（3 ツール共通の最小公約数）

3 ツールで共通して動くよう、各 `SKILL.md` は次の制約に従う。

- frontmatter は `name` と `description` のみ（Zed の任意項目 `disable-model-invocation` は可）。
- `agent:` / `context:` は使わない。Claude Code 固有のサブエージェント委譲機構で、Codex・Zed は非対応。処理はすべて `SKILL.md` 本文に**自己完結**で書く。
- 補助ファイルは `references/`・`scripts/`・`assets/` に置く（ネストしたスキルフォルダは不可）。
- `description` は Zed では 1024 バイト以内。スキル名・説明の合計カタログサイズは Zed で 50KB 上限。

## スキルの追加・編集

1. `.config/skills/<name>/SKILL.md` を新規作成・編集する。
2. 新規スキルは Claude へ symlink を張る（Zed は `.agents/skills` のディレクトリ symlink 経由で自動的に拾うため追加作業不要）。

   ```bash
   ln -sfn "../../.config/skills/<name>" ".claude/skills/<name>"
   ```

3. `./scripts/deploy.sh` で配備する（Codex への実体コピー生成もここで行われる）。Claude・Zed は symlink 経由で即時反映されるが、**Codex は実体コピーのため、新規・既存問わず編集後は必ず `deploy.sh` を実行**し、Codex を再起動する。

## 収録スキル

| スキル | 用途 | 依存 MCP |
| --- | --- | --- |
| `commit` | Conventional Commits 準拠のコミット作成 | — |
| `draft` | ドラフト PR 作成 | — |
| `pull-request` | 変更を分割してコミット・PR スタック作成 | — |
| `review` | PR の包括レビュー | GitHub・Linear・Notion |
| `linear` | デフォルト条件で Linear Issue 作成 | Linear |
| `figma` | Figma MCP で design context 取得・コード化 | Figma |
| `figma-implement-design` | Figma ノードを 1:1 でコード実装 | Figma |
| `make-component` | Figma から wklr-mono design-system へ React 実装 | Figma |
| `drawio` | draw.io 図の生成 | — |
| `eagle` | Eagle 資産管理 | — |
| `unity-mcp-orchestrator` | Unity Editor を MCP 経由で操作 | Unity MCP |
| `wtc` | phantom worktree 作成 | — |
| `wtd` | phantom worktree 削除 | — |

## 外部 sync 管理のスキル

`unity-mcp-skill` は MCP for Unity の skill-sync が自動生成・管理する（`.unity-mcp-skill-sync` マーカーが目印）。本リポジトリに vendoring 済みのため、sync が再実行されると canonical が上書きされるか symlink が実体フォルダに戻る可能性がある。**統合運用を維持する方針**とし、sync 後は `git diff` で差分を検知して repo に取り込む。`eagle-skill` も外部ツール由来の可能性があり、同様に扱う。
