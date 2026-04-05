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
3. 変更内容を分析し、論理単位にグループ分けする
4. グループごとに Conventional Commits 準拠のメッセージを生成する
5. グループごとにパスを指定してチェックインを実行する
6. 完了後、作成した全 changeset の一覧を報告する

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

パスを指定して論理単位ごとにチェックインする:

```bash
cm checkin <path1> <path2> ... --dependencies -c "<type>: <description>"
```

全変更が単一の論理単位の場合のみ `--all` を使用する:

```bash
cm checkin --all --dependencies -c "<type>: <description>"
```

## 注意事項

- `cm` CLI を使用する（`plastic` ではない）
- `--dependencies` フラグを常に付与する（ディレクトリ移動やリネームの依存解決に必要）
- チェックイン順序は依存関係を考慮する（基盤となる変更を先にチェックインする）
- チェックイン後、作成した全 changeset 番号を一覧で報告する
