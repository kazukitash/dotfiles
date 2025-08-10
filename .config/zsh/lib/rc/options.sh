#!/bin/zsh
# zshの拡張設定（インタラクティブシェル用）

# オプション設定
unsetopt PROMPT_SP
setopt auto_cd              # cdなしで移動
setopt correct              # 間違いを指摘
setopt globdots             # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt auto_menu            # 補完キー連打で順に補完候補を自動で補完
setopt mark_dirs            # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt brace_ccl            # 範囲指定できるようにする。例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt nolistbeep           # zshは鳴かない
setopt auto_pushd           # 移動dirを一覧表示
setopt list_packed          # 補完候補を詰めて表示
setopt no_global_rcs        # macOSの/etc/zprofileに余計なことが書いてあるので読まない
setopt menu_complete        # 補完の絞り込み
setopt share_history        # 履歴のプロセス間共有
setopt print_eight_bit      # 日本語ファイル名を表示可能にする
setopt complete_in_word     # 語の途中でもカーソル位置で補完
setopt auto_param_slash     # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt noautoremoveslash    # パス末尾の / を勝手に取らないようにする
setopt always_last_prompt   # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt hist_ignore_all_dups # 重複した履歴を残さない

# lscolors設定
export LSCOLORS=Gxfxcxdxbxegedabagacad # lscolor generator: http://geoff.greer.fm/lscolors/

# エディタ設定
export EDITOR="zed"
