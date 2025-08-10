#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

setup() {
  for i in $(ls "$DOTPATH"/scripts/setup | grep .sh$); do
    /bin/bash ${DOTPATH}/scripts/setup/$i
  done
}

setup
