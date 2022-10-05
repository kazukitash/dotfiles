# dotfiles

[![macos](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/macos.yml) [![linux](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml/badge.svg?branch=main)](https://github.com/kazukitash/dotfiles/actions/workflows/linux.yml)

## インストールの仕方

Linux の場合は make と gcc と ruby のビルドに必要なパッケージを入れておく

```
sudo -s
apt-get update -y
apt install -y build-essential libssl-dev zlib1g-dev
```

スクリプトを Github から curl でダウンロードして実行する。

```
$ /bin/bash -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/main/install.sh)"
```

## アップデートの仕方

Makefile の install コマンドを実行する。

```
$ make install
```

## インストール内容

### HomeBrew

以下の設定をする。

1. Xcode CLI のインストール
2. HomeBrew のインストール
3. Formula のインストール

インストールする Formula は以下の通り。

**macOS**

- Programing
  - brew "anyenv"
  - cask "github"
- Browser
  - cask "google-chrome"
- Image & Video
  - brew "ffmpeg"
  - brew "imagemagick"
- Git
  - brew "gh"
  - brew "diff-so-fancy"
- zsh syntax highlighting
- brew "zsh-syntax-highlighting"
- IME
  - cask "visual-studio-code"
- Cleaner
  - cask "appcleaner"

**Linux**

- Programing
  - brew "anyenv"
- Image & Video
  - brew "ffmpeg"
  - brew "imagemagick"
- Git
  - brew "gh"
  - brew "diff-so-fancy"
- zsh syntax highlighting
  - brew "zsh-syntax-highlighting"

### Ruby

rbenv 上の最新の Ruby をインストールする。

（参考）最新バージョンの取得方法

```
rbenv install -L | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1
```

以下の Gem をインストールする。

なし

### Node

nodenv 上の最新の Node をインストールする。

以下の module をインストールする。

- typescript

### Python

pyenv 上の最新の Python をインストールする。

以下の package をインストールする。

なし

### Git

以下の設定をする。

- ユーザー ID（ユーザーネーム、メールアドレス）を設定する
- ファイル名の大文字と小文字を区別する
- 改行コードの自動変換を無効にする
- デフォルトブランチ名を main にする
- pull 時の挙動を rebase にする
- pager を diff so fancy にする
- ui をカラフルにする
- 日本語ファイルをエンコードしない
- password の keychain 利用
- fast-forward な場合のみ merge をし、それ以外の場合は merge はされずエラーとなる
- merge は fast-forward しない
- 現在のブランチをリモートに同じ名前で push する

## Makefile

使い方は以下のコマンドで確認する。

```
make help
```
