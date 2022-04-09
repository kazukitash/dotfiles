# dotfiles

## インストールの仕方

スクリプトをGithubからcurlでダウンロードして実行する。

```
$ sh -c "$(curl -L raw.githubusercontent.com/kazukitash/dotfiles/master/install)"
```

## アップデートの仕方

Makefileのinstallコマンドを実行する。

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

- Code
  - anyenv
  - github-desktop
  - google-chrome
  - unity-hub
- Image & Video
  - ffmpeg
  - imagemagick
  - adobe-creative-cloud
- Git
  - gh
  - diff-so-fancy
- zsh syntax highlighting
  - zsh-syntax-highlighting
- IME
  - visual-studio-code
  - Xcode
- Work
  - Keynote
  - Pages
  - Numbers
  - Spark
- Writer
  - Ulysses
- SNS
  - LINE
  - Slack
- Utility
  - unrar
  - BetterSnapTool
  - appcleaner

### Ruby

rbenvのみインストール。

### Node

nodenv上の最新のNodeをインストールします。

（参考）実行されるインストールコマンド

```
nodenv install -l | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1
```

以下のmoduleをインストールする。

- typescript
- gatsby-cli

### Python

pyenv上の最新のPythonをインストールします。

（参考）実行されるインストールコマンド

```
pyenv install -l | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1
```

pythonのpackageはインストールしない。

### Git

以下の設定をする。

- ユーザーID（ユーザーネーム、メールアドレス）を設定する
- ファイル名の大文字と小文字を区別する
- 改行コードの自動変換を無効にする
- デフォルトブランチ名を main にする
- pull 時の挙動を rebase にする
- pager を diff so fancy にする
- ui をカラフルにする
- 日本語ファイルをエンコードしない
- password の keychain 利用
- fast-forward な場合のみ merge をし、それ以外の場合は merge はされずエラーとなる
- 現在のブランチをリモートに同じ名前で push する

## Makefile

使い方は以下のコマンドで確認する。

```
make help
```
