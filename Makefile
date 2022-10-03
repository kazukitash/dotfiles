DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitignore
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

all: install

help:
	@echo "make list           #=> このリポジトリのdotfilesを一覧表示"
	@echo "make setup          #=> インストールスクリプトの実行"
	@echo "make deploy         #=> ホームディレクトリにdotfilesのリンクを生成する"
	@echo "make update         #=> このリポジトリの変更をFetchする"
	@echo "make install        #=> make update, deploy, setupを実行する"
	@echo "make clean          #=> dotfilesを削除する"

list:
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

setup:
	@DOTPATH=$(DOTPATH) && /bin/bash $(DOTPATH)/etc/setup.sh

update:
	git pull origin master

deploy:
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

clean:
	@$(foreach val, $(DOTFILES), rm -rf $(HOME)/$(val);)

install: update setup deploy
	@exec $$SHELL
