# dotfiles

[![macos](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml) [![linux](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml)

## インストールの仕方

スクリプトを Github から curl でダウンロードして実行する。

```bash
/bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"
```

## アップデートの仕方

Makefile の install コマンドを実行する。

```bash
./scirpts/update.sh
./scripts/deploy.sh
```

## Makefile

使い方は以下のコマンドで確認する。

```bash
make help
```
