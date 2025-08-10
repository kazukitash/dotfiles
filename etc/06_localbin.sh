#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_localbin() {
  e_header "Install local binaries" "Start install local binary"
  mkdir -p ${HOME}/.local
  e_log "Install local binaries" "make directory"
  ln -sfnv ${DOTPATH}/etc/bin ${HOME}/.local
  e_log "Install local binaries" "Copy binaries"
}

install_localbin
