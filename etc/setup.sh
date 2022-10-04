#!/bin/bash -xeu

DOTPATH=~/.dotfiles

setup() {
  for i in "$DOTPATH"/etc/*.sh; do
    /bin/bash $i
  done
}

setup
