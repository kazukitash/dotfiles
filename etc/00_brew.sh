#!/bin/bash -xeu

if [ -n "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

install_xcodecli() {
  e_newline && e_header "[Homebrew] Installing XCode CLI..."
  xcode-select --install
  e_done "Install"
}

install_homebrew() {
  e_newline && e_header "[Homebrew] Installing HomeBrew..."
  if has "brew"; then
    e_header "[Homebrew] Homebrew is already installed"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ $? -ne 0 ]; then
      e_error "Install HomeBrew"
      exit 1
    fi
  fi
  e_done "Install"
}

install_formulas() {
  e_newline && e_header "[Homebrew] Installing HomeBrew formulas..."
  brew tap Homebrew/bundle
  if [ $? -ne 0 ]; then
    e_error "Tap Homebrew/bundle"
    exit 1
  fi
  case "$(uname)" in
  Darwin)
    e_done "OS detected. Start installation for macOS"
    brew bundle --file "$DOTPATH"/etc/macos/Brewfile
    ;;
  Linux)
    e_done "OS detected. Start installation for Linux"
    brew bundle --file "$DOTPATH"/etc/linux/Brewfile
    ;;
  *)
    e_error "Unknown OS. Abort the install process"
    ;;
  esac
  e_done "Install"
}

install_xcodecli
install_homebrew
install_formulas
