---
name: make-component
description: |
  Figma の URL を受け取り、BaseUI（@base-ui/react）を最大限に活用して wklr-mono の `packages/design-system` に React コンポーネントを実装する。
  Figma URL の提示・「このコンポーネントを実装」「Figma から React に起こして」「Design System に追加」といった依頼時に使用する。
---

# Make React Component from Figma into LS Design System

Figma のコンポーネントデザインを、`@base-ui/react` をベースとした **LS Design System**（`packages/design-system`）の React コンポーネントに変換する。

## 対象パッケージ

- パス: `~/repo/wklr/wklr-mono/packages/design-system`
- 詳細: パッケージ内の `CLAUDE.md` / `AGENTS.md` を参照（最新の方針はそちらが正）
- Figma file: https://www.figma.com/design/x7MnzeROxuK6lqrGXySy1o/LS_DesignSystem

## 起動条件

- ユーザーが `figma.com/design/...` URL を提示し、コンポーネント実装を依頼した場合
- 「Design System に追加」「BaseUI で作って」「Figma から React コンポーネント化」などの依頼時

## 前提

- BaseUI のインポートパスは `@base-ui/react/<name>`（例: `@base-ui/react/button`、`@base-ui/react/dialog`）
- スタイリングは **CSS Modules + Design Token（CSS Custom Properties）**
- クラス結合は `clsx` を使用
- Typography は `Typography.module.css` の class を組み合わせる
- ハードコードされた色・spacing・radius は禁止。必ず `gen/css/tokens.css` のトークン（`--color-*`、`--dimension-spacing-*`、`--dimension-rounded-*` など）を参照する

## 実行手順

### 1. Figma URL の解析

Figma URL から `fileKey` と `nodeId` を抽出する。

| URL 形式                                        | 抽出値                                  |
| ----------------------------------------------- | --------------------------------------- |
| `figma.com/design/:fileKey/:name?node-id=:id`   | `fileKey`、`nodeId`（`-` を `:` に変換）|
| `figma.com/design/:fileKey/branch/:branchKey/…` | `branchKey` を `fileKey` として使用     |

### 2. デザイン情報の取得

以下を並列で取得する。

- `mcp__claude_ai_Figma__get_design_context` — コード・スクショ・ヒント
- `mcp__claude_ai_Figma__get_variable_defs` — Design Token の対応関係
- `mcp__claude_ai_Figma__get_screenshot` — 視覚確認用
- `mcp__claude_ai_Figma__get_metadata` — レイヤー構造

### 3. 既存資産の確認

実装前に以下を必ず確認する。

- `packages/design-system/src/components/index.ts` — 公開済みコンポーネント
- `packages/design-system/src/components/<Name>/` の既存パターン（Button・Dialog・Popover を参考実装として使う）
- `packages/design-system/gen/css/tokens.css` — 利用可能なトークン
- `packages/design-system/src/css/icons.module.css` — 利用可能なアイコン
- `packages/design-system/src/components/Typography/Typography.module.css` — Typography クラス
- LS Design System Preview MCP（`mcp__claude_ai_LS_Design_System_Preview__list-all-documentation` → `get-documentation`）で既存コンポーネントの API を確認し、再利用できるものは新規実装しない

### 4. BaseUI コンポーネント選定

`@base-ui/react/<name>` から該当する primitive を選定する。

| Figma の意図           | BaseUI モジュール           |
| ---------------------- | --------------------------- |
| ボタン                 | `@base-ui/react/button`     |
| チェックボックス       | `@base-ui/react/checkbox`   |
| ラジオ                 | `@base-ui/react/radio`、`@base-ui/react/radio-group` |
| スイッチ・トグル       | `@base-ui/react/switch`     |
| ドロップダウン・選択   | `@base-ui/react/select`     |
| コンボボックス         | `@base-ui/react/combobox`、`@base-ui/react/autocomplete` |
| ダイアログ・モーダル   | `@base-ui/react/dialog`、`@base-ui/react/alert-dialog` |
| ポップオーバー         | `@base-ui/react/popover`    |
| ツールチップ           | `@base-ui/react/tooltip`    |
| メニュー               | `@base-ui/react/menu`、`@base-ui/react/context-menu` |
| タブ                   | `@base-ui/react/tabs`       |
| アコーディオン         | `@base-ui/react/accordion`、`@base-ui/react/collapsible` |
| スライダー             | `@base-ui/react/slider`     |
| 数値入力               | `@base-ui/react/number-field` |
| プログレス・メーター   | `@base-ui/react/progress`、`@base-ui/react/meter` |
| トースト               | `@base-ui/react/toast`      |
| フォーム               | `@base-ui/react/form`、`@base-ui/react/field` |
| アバター               | `@base-ui/react/avatar`     |
| スクロールエリア       | `@base-ui/react/scroll-area` |
| 区切り線               | `@base-ui/react/separator`  |
| トグルグループ         | `@base-ui/react/toggle`、`@base-ui/react/toggle-group` |

BaseUI に対応物がない（Card・Badge・Chip など）場合は、ネイティブ要素 + Design Token で実装する（既存の `BookCover`・`Skeleton` がそのパターン）。

### 5. ファイル構成

```
packages/design-system/src/components/<Name>/
├── <Name>.tsx
├── <Name>.module.css
└── <Name>.stories.tsx
```

複合コンポーネントは 1 ディレクトリに同居（例: `Button/Button.tsx` と `Button/ButtonGroup.tsx`）。

### 6. 実装パターン

既存の `Button.tsx` / `Dialog.tsx` を踏襲する。要点は以下:

#### 単純コンポーネント（Button 型）

```tsx
import { Button as ButtonBase } from '@base-ui/react/button';
import clsx from 'clsx';
import styles from './Foo.module.css';
import typography from '../Typography/Typography.module.css';

export type FooVariant = 'filled' | 'outline';
export type FooSize = 'large' | 'medium' | 'small';

export type FooProps = {
  variant?: FooVariant;
  size?: FooSize;
} & Omit<React.ComponentProps<typeof ButtonBase>, 'color'>;

export const Foo: React.FC<FooProps> = ({
  variant = 'filled',
  size = 'medium',
  className,
  children,
  ...rest
}) => {
  const baseClasses = clsx(styles.foo, styles[variant], styles[size]);
  const mergedClassName =
    typeof className === 'function'
      ? (state: { disabled: boolean }) => clsx(baseClasses, className(state))
      : clsx(baseClasses, className);
  return (
    <ButtonBase className={mergedClassName} {...rest}>
      {children}
    </ButtonBase>
  );
};
```

#### Compound コンポーネント（Dialog 型）

```tsx
import { Dialog as DialogBase } from '@base-ui/react/dialog';

const Trigger: React.FC<React.ComponentProps<typeof DialogBase.Trigger>> = ({ className, ...props }) => (
  <DialogBase.Trigger data-testid="foo-trigger" className={clsx(styles.trigger, className)} {...props} />
);
// Content / Header / Body / Footer / Close も同様

const FooRoot: React.FC<React.ComponentProps<typeof DialogBase.Root>> = (props) => <DialogBase.Root {...props} />;

export const Foo = Object.assign(FooRoot, { Trigger, Content, Header, Body, Footer, Close });
```

#### 必須事項

- **`className` は関数 prop も受ける** — BaseUI が `(state) => string` を渡すため、上記のように分岐する
- **`data-testid` を主要なサブ要素に付与** — `dialog-trigger`、`dialog-content-popup` のように `<component>-<part>` 形式
- **アイコンは `<Icon name="..." />`** を使う。`pc`/`sp` props でレスポンシブにサイズ指定可能
- **Typography が必要なら** `typography.bodySmRegular` などの class を `clsx` で併用
- **アクセシビリティは BaseUI に任せる** — ARIA・キーボード・focus 管理を独自実装しない
- **`type="button"` を Button 系のデフォルト** にしてフォーム誤送信を防ぐ
- **`...rest` で BaseUI のネイティブ props を素通し** する

### 7. CSS Modules

- ファイル名は `<Name>.module.css`
- 値は **必ずトークン** を参照する

```css
.foo {
  padding: var(--dimension-spacing-sm) var(--dimension-spacing-md);
  border-radius: var(--dimension-rounded-sm);
  background: var(--color-semantic-button-primary-default);
  color: var(--color-semantic-text-on-primary);
}

.foo[data-disabled] {
  opacity: 0.4;
  cursor: not-allowed;
}
```

- BaseUI の状態は `data-*` 属性で分岐（`[data-state=open]`、`[data-disabled]`、`[data-checked]`、`[data-pressed]` など）
- ブレークポイントは `--dimension-screen-sp / tablet / pc` を使用

### 8. index.ts への追加

`packages/design-system/src/components/index.ts` に export を追加する。形式は既存の Button セクションに揃える。

```ts
// Foo
export { Foo } from './Foo/Foo.tsx';
export type { FooVariant, FooSize, FooProps } from './Foo/Foo.tsx';
```

### 9. Storybook の作成

`<Name>.stories.tsx` を作成する。Storybook 10（`@storybook/react-vite`）に従う。

```tsx
import type { Meta, StoryObj } from '@storybook/react-vite';
import { Foo } from './Foo.tsx';

const meta = {
  title: 'Components/Foo',
  component: Foo,
} satisfies Meta<typeof Foo>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = { args: { children: '...' } };
export const Variants: Story = { render: () => (/* … */) };
export const Sizes: Story = { render: () => (/* … */) };
export const Disabled: Story = { render: () => (/* … */) };
```

Figma の Variant ごとに Story を網羅する。`addon-mcp` がこの Story から MCP 配信用 manifest を生成するため、props を分かりやすく構造化する。

### 10. 検証

実装後、`packages/design-system` 配下で以下を実行する。

```bash
pnpm run check:type    # 型チェック
pnpm run test          # Vitest（必要に応じてテスト追加）
pnpm run storybook     # localhost:6007 で見た目を確認
```

Figma のスクリーンショットと Storybook を並べ、視覚差分を確認する。

## アンチパターン

- `@base-ui-components/react` からインポートする（正しくは `@base-ui/react`）
- BaseUI primitive があるのに `<div>` で再実装する
- ARIA 属性や `role` を独自に付与する（BaseUI が既に付与している）
- `useState` でモーダル/ポップオーバーの開閉を管理し BaseUI の制御フローを無視する
- `#FFFFFF` や `16px` のような raw 値を CSS に直書きする（必ずトークン）
- `@emotion`、`styled-components`、`tailwind` を新規導入する（CSS Modules で統一）
- `any` 型で props を受ける、トップレベルで `as` キャストする
- `data-testid` を付け忘れる
- `index.ts` の export を忘れる、Story を書かない

## 出力フォーマット

実装完了時は以下を報告する。

- 作成・編集したファイル一覧（パスを `packages/design-system/...` で表記）
- 採用した BaseUI モジュールと理由
- 使用した Design Token と Figma Variable の対応
- `index.ts` の export 追加内容
- 未対応・要確認事項（Figma の挙動が BaseUI で表現しきれない場合など）
