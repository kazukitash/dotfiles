#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

install_apt() {
  case "$(arch)" in
    Linux)
    e_header "Prepare" "Install dependencies for Linux"

    e_log "Prepare" "Need root privilege"
    sudo printf "\e[32;4mPrepare\e[0m \e[32mRoot privilege - ✔  OK\e[0m\n"
    if [ $? -ne 0 ]; then
      e_error "Prepare" "Wrong password"
      e_error "Prepare" "Abort the process"
      exit 1
    fi

    # apt-getでUIを使うインストールを避ける
    export DEBIAN_FRONTEND=noninteractive

    # Localeの設定
    e_log "Prepare" "Updating apt..."
    export LC_ALL=C
    sudo apt-get update
    check_result $? "Prepare" "Update apt"

    # タイムゾーンの設定
    e_log "Prepare" "Installing tzdata..."
    sudo apt-get install -y tzdata
    check_result $? "Prepare" "Install tzdata"
    export TZ=Asia/Tokyo

    # 基本パッケージをインストール
    e_log "Prepare" "Installing base packages..."
    sudo apt-get install -y build-essential procps curl file wget git
    check_result $? "Prepare" "Install base packages"

    # ruby-build用のパッケージをインストール
    e_log "Prepare" "Installing ruby packages..."
    sudo apt-get install -y autoconf bison patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev
    check_result $? "Prepare" "Install ruby packages"

    # python用のパッケージをインストール
    e_log "Prepare" "Installing python packages..."
    sudo apt-get install -y libbz2-dev libreadline-dev liblzma-dev libncursesw5-dev libsqlite3-dev uuid-dev tk-dev
    check_result $? "Prepare" "Install python packages"

    # aptのcacheを消す
    e_log "Prepare" "Cleaning apt..."
    sudo apt-get clean -y && sudo rm -rf /var/lib/apt/lists/*
    check_result $? "Prepare" "Cleanup apt"
    ;;
  esac
}

install_apt
