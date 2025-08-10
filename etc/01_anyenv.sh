#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_anyenv() {
  e_header "Install anyenv" "Start installation"

  e_log "Install anyenv" "Installing..."
  anyenv install --force-init
  check_result $? "Install anyenv" "Install"

  e_log "Install anyenv" "Initializing..."
  eval "$(anyenv init -)"
  check_result $? "Install anyenv" "Initialize"

  e_log "Install anyenv" "Installing plugins..."
  mkdir -p $(anyenv root)/plugins
  git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
  check_result $? "Install anyenv" "Install plugins"

  e_log "Install anyenv" "Updating..."
  anyenv update
  check_result $? "Install anyenv" "Update"

  e_log "Install anyenv" "Installing rbenv..."
  anyenv install -f rbenv
  check_result $? "Install anyenv" "Install rbenv"

  e_log "Install anyenv" "Installing nodenv..."
  anyenv install -f nodenv
  check_result $? "Install anyenv" "Install nodenv"

  e_log "Install anyenv" "Installing pyenv..."
  anyenv install -f pyenv
  check_result $? "Install anyenv" "Install pyenv"
}

install_anyenv
