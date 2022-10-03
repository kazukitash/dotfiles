#!/bin/bash -xeu

if [ -n "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

setup() {
  for i in "$DOTPATH"/etc/*.sh; do
    /bin/bash $i
  done
}

setup
