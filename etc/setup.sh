#!/bin/bash -xeu

DOTPATH=~/.dotfiles

setup() {
  for i in $(ls "$DOTPATH"/etc | grep .sh$ | grep -v setup); do
    /bin/bash $i
  done
}

setup
