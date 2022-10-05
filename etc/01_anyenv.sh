#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

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
  anyenv install -f rbenv
  e_header "[Anyenv] Installing nodenv..."
  anyenv install -f nodenv
  e_header "[Anyenv] Installing pyenv..."
  anyenv install -f pyenv
  e_done "Set up"
}

setup_anyenv
