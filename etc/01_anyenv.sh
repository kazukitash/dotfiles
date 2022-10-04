#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

setup_anyenv() {
  e_newline && e_header "[Anyenv] Setting anyenv..."
  e_header "[Anyenv] Initializing..."
  anyenv init
  anyenv install --force-init
  e_header "[Anyenv] Installing plugins..."
  mkdir -p $(anyenv root)/plugins
  git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
  e_header "[Anyenv] Updating..."
  anyenv update
  e_header "[Anyenv] Installing rbenv..."
  anyenv install rbenv
  e_header "[Anyenv] Installing nodenv..."
  anyenv install nodenv
  e_header "[Anyenv] Installing pyenv..."
  anyenv install pyenv
  e_done "Set up"
}

setup_anyenv
