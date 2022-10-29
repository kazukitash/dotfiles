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
  PYTHON_VERSION=3.10.8
  if pyenv versions | grep -q $(echo $PYTHON_VERSION); then
    e_header "[Python] Python ver.$PYTHON_VERSION is already installed"
  else
    e_header "[Python] Installing Python ver.$PYTHON_VERSION..."
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
  pip install --upgrade pip

  case "$(uname)" in
  Darwin)
    e_done "OS detected. Start installation for macOS"
    pip install -r ${DOTPATH}/etc/macos/requirements.lock.txt
    ;;
  Linux)
    e_done "OS detected. Start installation for Linux"
    pip install -r ${DOTPATH}/etc/linux/requirements.lock.txt
    ;;
  *)
    e_error "Unknown OS. Abort the process"
    ;;
  esac
  pip cache purge
  e_done "Install"
}

install_python
install_package
