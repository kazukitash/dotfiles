#!/bin/sh -xeu

if [ -n "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

setup() {
  for i in "$DOTPATH"/setup/*.sh; do
    bash $i
  done
}

setup
