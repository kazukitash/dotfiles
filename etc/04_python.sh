if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

install_python() {
  e_newline && e_header "Installing Python..."
  PYTHON_VERSION=$(pyenv install -l | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1)
  if pyenv versions | grep -q "$PYTHON_VERSION"; then
    e_header "Python is already installed"
  else
    pyenv install $PYTHON_VERSION
    if [ $? -ne 0 ]; then
      e_error "failed to install Python"
      exit 1
    fi
  fi
  pyenv global $PYTHON_VERSION
  e_done "Install"
}

install_package() {
  e_newline && e_header "Installing Python packages..."
  e_done "Install"
}

install_python
install_package
