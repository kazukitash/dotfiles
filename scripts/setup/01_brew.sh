#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

install_formulas() {
  e_header "Install formulas" "Start install Homebrew formulas"

  e_log "Install formulas" "Updating..."
  brew update
  check_result $? "Install formulas" "Update"

  e_log "Install formulas" "Installing..."

  case "$(arch)" in
    macOS)
      e_log "Install formulas" "Installing for macOS..."
      # Install common macOS packages
      brew bundle --file "$DOTPATH"/.config/brew/macos.Brewfile
      check_result $? "Install formulas" "Install common packages"

      # Install work/personal packages based on WORK_MODE
      if [ "${WORK_MODE:-false}" = "true" ]; then
        e_log "Install formulas" "Installing work packages..."
        brew bundle --file "$DOTPATH"/.config/brew/macos-work.Brewfile
        check_result $? "Install formulas" "Install work packages"
      else
        e_log "Install formulas" "Installing personal packages..."
        brew bundle --file "$DOTPATH"/.config/brew/macos-default.Brewfile
        check_result $? "Install formulas" "Install personal packages"
      fi
      ;;
    Linux)
      e_log "Install formulas" "Installing for Linux..."
      brew bundle --file "$DOTPATH"/.config/brew/linux.Brewfile
      check_result $? "Install formulas" "Install"
      ;;
  esac

  e_log "Install formulas" "Cleaning up..."
  brew cleanup
  check_result $? "Install formulas" "Clean up"
}

install_formulas
