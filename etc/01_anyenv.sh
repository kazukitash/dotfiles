#!/bin/sh -xeu

if [ -n "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

setup_anyenv(){
  e_newline && e_header "Setting anyenv..."
  export PATH=$HOME/.anyenv/bin:$PATH
  anyenv init
  anyenv install --init
  mkdir -p $(anyenv root)/plugins
  git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
  anyenv update
  anyenv install rbenv
  anyenv install nodenv
  anyenv install pyenv
  e_done "Set up"
}

setup_anyenv
