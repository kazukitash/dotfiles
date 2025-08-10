#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_python() {
  e_header "Install Python" "Start installation Python"

  e_log "Install Python" "Checking installed Python..."
  if pyenv versions | grep -q $(echo $PYTHON_VERSION); then
    e_done "Install Python" "ver.$PYTHON_VERSION is already installed"
  else
    e_log "Install Python" "ver.$PYTHON_VERSION is NOT installed"
    e_log "Install Python" "Installing ver.$PYTHON_VERSION..."
    pyenv install $PYTHON_VERSION
    check_result $? "Install Python" "Install"
  fi

  e_log "Install Python" "Changing global Python version..."
  pyenv global $PYTHON_VERSION
  check_result $? "Install Python" "Change global Python version"
}

install_python
