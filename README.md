# dotfiles

[![macos](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml) [![linux](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml)

## 事前

WSLの場合はmakeと日本語パックを事前に入れておく

```bash
apt update
apt upgrade
apt install build-essential
apt install language-pack-ja
```

## インストールの仕方

スクリプトを Github から curl でダウンロードして実行する。

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"
```

## アップデートの仕方

Makefile の install コマンドを実行する。

```bash
make install
```

## Makefile

使い方は以下のコマンドで確認する。

```bash
make help
```
