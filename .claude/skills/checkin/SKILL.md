---
name: checkin
description: |
  Unity Version Control (Plastic SCM) で変更をチェックインする。Conventional Commits に準拠したメッセージを生成する。
  変更を論理単位に分割し、それぞれ個別の changeset としてチェックインする。
  チェックイン・UVC コミット・Plastic SCM への変更登録時に使用する。
---

# Checkin Skill

Unity Version Control (Plastic SCM) の `cm` CLI を使用して変更をチェックインする。

## 手順

1. `cm status --changelist` で変更ファイル一覧を取得する
2. 変更がない場合は「変更なし」と報告して終了する
3. ゴーストファイルを除外する（後述）
4. Private ファイルのうちトラッキング対象を `cm add` する
5. 変更内容を分析し、論理単位にグループ分けする
6. グループごとに Conventional Commits 準拠のメッセージを生成する
7. グループごとにチェックインを実行する
8. 完了後、作成した全 changeset の一覧を報告する

## ゴーストファイル除外

`cm status` が Changed (CH) と報告しても実際には差分がないファイル（ゴーストファイル）が存在する。チェックイン前に必ず除外する。

### 検出方法

`cm cat` でベースリビジョンの内容を取得し、ローカルファイルとチェックサムを比較する:

```bash
# changeset 番号は cm status の先頭行から取得する (例: cs:118)
base_md5=$(cm cat "serverpath:/<workspace-relative-path>#cs:<N>" 2>/dev/null | md5 -q)
local_md5=$(md5 -q "<path>")
if [ "$base_md5" = "$local_md5" ]; then
  echo "GHOST"  # 差分なし
fi
```

全ての CH ファイルに対してこのチェックを実行し、GHOST ファイルを特定する。

### GHOST ファイルの扱い

**GHOST ファイルはチェックイン対象から除外するだけにする。`cm undochange` は絶対に使わない。**

`cm undochange` は Plastic SCM の内部状態に基づいてファイルを巻き戻すため、チェックサムが一致していてもメタデータレベルで差異がある場合に意図しない巻き戻しが発生する。

## 禁止コマンド

| コマンド | 理由 |
|---------|------|
| `cm diff <path>` | GUI の差分ツールが開く。差分検出には `cm cat` + チェックサムを使う |
| `cm undochange` | 実際に差分がある変更まで巻き戻すリスクがある。絶対に使わない |

## 論理単位の分割ルール

変更ファイルを以下の観点でグループに分ける:

- **責務の境界**: 機能コード・テスト・ドキュメント・設定は別の changeset にする
- **意図の違い**: リファクタリングと新機能追加は混ぜない
- **依存関係**: 同じ機能変更に伴うコードとテストの更新は同じ changeset にしてよい
- **最小原則**: 1つの changeset は1つの目的を持つ。迷ったら分ける

### 分割の判断例

| 変更内容 | 分割 |
|---------|------|
| 機能コード + そのテスト | 同じ changeset |
| 機能コード + 無関係なドキュメント | 別の changeset |
| 2つの独立した機能追加 | 別の changeset |
| `.inputactions` + それを使う C# コード | 同じ changeset |
| Docs のリネーム + コードのリファクタリング | 別の changeset |

## Conventional Commits ルール

メッセージ形式: `<type>: <description>`

| type | 用途 |
|------|------|
| feat | 新機能追加 |
| fix | バグ修正 |
| update | 既存機能の改善・更新 |
| refactor | リファクタリング（機能変更なし） |
| docs | ドキュメントのみの変更 |
| style | コードスタイル変更（動作に影響なし） |
| test | テストの追加・修正 |
| chore | ビルドプロセス・補助ツール・設定の変更 |

- description は日本語で書く
- 簡潔に変更の目的を記述する（「何を」ではなく「なぜ」）

## チェックインコマンド

### 基本: パス指定

```bash
cm checkin <path1> <path2> ... --dependencies -c "<type>: <description>"
```

### 全変更が単一の論理単位の場合

```bash
cm checkin --all --dependencies -c "<type>: <description>"
```

### パス指定が "not changed" エラーで失敗した場合

Plastic SCM はパス指定チェックイン時に "not changed" を誤報することがある。その場合は changelist を使う:

```bash
# 1. グループ用の changelist を作成
cm changelist add "group_name"

# 2. ファイルを changelist に移動
cm changelist move "group_name" <path1> <path2> ...

# 3. changelist 単位でチェックイン
cm checkin --changelist="group_name" --dependencies -c "<type>: <description>"
```

changelist も失敗する場合は `--all` にフォールバックする。その場合はグループのメッセージを結合する。

## 注意事項

- `cm` CLI を使用する（`plastic` ではない）
- `--dependencies` フラグを常に付与する（ディレクトリ移動やリネームの依存解決に必要）
- チェックイン順序は依存関係を考慮する（基盤となる変更を先にチェックインする）
- チェックイン後、作成した全 changeset 番号を一覧で報告する
- **全ての変更をチェックインする**: タスクと無関係に見えるファイル（設定ファイル、IDE 設定、アセット変更など）もスキップせず必ずチェックインする。分割の判断として別の changeset にするのは構わないが、チェックインせずに残すことはしない
- **GHOST ファイルは例外**: チェックサム比較で差分なしと確認されたファイルはチェックイン対象外。放置してよい
