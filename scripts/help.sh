#!/bin/bash -eu

# ヘルプメッセージを表示

echo "make list           #=> このリポジトリのdotfilesを一覧表示"
echo "make setup          #=> インストールスクリプトの実行"
echo "make deploy         #=> ホームディレクトリにdotfilesのリンクを生成する"
echo "make update         #=> このリポジトリの変更をFetchする"
echo "make install        #=> make update, deploy, setupを実行する"
echo "make clean          #=> dotfilesを削除する"
