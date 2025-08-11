# dotfiles

[![macos](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml) [![linux](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml)

## インストール

### 基本インストール

dotfilesのみをインストール:

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"
```

### オプション付きインストール

開発環境を含む完全インストール:

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- --build
# または短縮形
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- -b
```

業務環境用のパッケージを含むインストール:

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- --work
# または短縮形
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- -w
```

開発環境と業務環境の両方:

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- --build --work
# または短縮形
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)" -- -bw
```

## アップデート

リポジトリを最新化してdotfilesを再配置:

```bash
./scripts/update.sh
./scripts/deploy.sh
```

## 管理コマンド

### 基本コマンド

```bash
# dotfilesをホームディレクトリにシンボリックリンクとして配置
./scripts/deploy.sh

# 配置される予定のファイル一覧を表示
./scripts/list.sh

# リポジトリを最新化
./scripts/update.sh

# プラットフォーム固有のセットアップを実行
./scripts/setup.sh
```

### ローカル開発

リポジトリをクローンして開発:

```bash
git clone https://github.com/kazukitash/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh --build
```

## インストールオプション

| オプション | 短縮形 | 説明 |
|-----------|--------|------|
| `--build` | `-b` | 開発環境用パッケージをインストール |
| `--work` | `-w` | 業務環境用パッケージをインストール |
| `--help` | `-h` | ヘルプを表示 |

## 構成

- **シンボリックリンク方式**: すべての設定ファイルは `~/.dotfiles/` に保持され、ホームディレクトリにシンボリックリンクとして配置
- **XDG準拠**: `.config/` ディレクトリ構造を採用
- **クロスプラットフォーム**: macOSとLinuxの両方をサポート
- **モジュラー設計**: Brewfile、Zsh設定などが環境別に分離
