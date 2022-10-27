#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_python() {
  e_newline && e_header "[Python] Installing Python..."
  e_header "[Python] Loading anyenv..."
  eval "$(anyenv init -)"
  PYTHON_VERSION=$(pyenv install -l | grep -v - | grep -e "^[ ]*[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1)
  if pyenv versions | grep -q $(echo $PYTHON_VERSION); then
    e_header "[Python] Python is already installed"
  else
    pyenv install $PYTHON_VERSION
    if [ $? -ne 0 ]; then
      e_error "Install Python"
      exit 1
    fi
  fi
  pyenv global $PYTHON_VERSION
  e_done "Install"
}

install_package() {
  e_newline && e_header "[Python] Installing Python packages..."
  e_done "Install"
}

install_python
install_package
