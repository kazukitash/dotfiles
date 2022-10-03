#!/bin/sh -xeu

if [ -n "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

install_xcodecli() {
  e_newline && e_header "Installing XCode CLI..."
  xcode-select --install
  e_done "Install"
}

install_homebrew() {
  e_newline && e_header "Installing HomeBrew..."
  if has "brew"; then
    e_header "Homebrew is already installed"
  else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [ $? -ne 0 ]; then
      e_error "failed to install HomeBrew"
      exit 1
    fi
  fi
  e_done "Install"
}

install_formulas() {
  e_newline && e_header "Installing HomeBrew formulas..."
  brew tap Homebrew/bundle
  if [ $? -ne 0 ]; then
    e_error "failed to tap Homebrew/bundle"
    exit 1
  fi
  brew bundle --file "$DOTPATH"/setup/Brewfile
  e_done "Install"
}

install_xcodecli
install_homebrew
install_formulas
