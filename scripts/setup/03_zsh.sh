#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

setup_zsh() {
  case "$(arch)" in
    Linux)
    e_header "Setup zsh" "Start setup"
    ZSH_PATH=$(which zsh)

    e_log "Setup zsh" "Need root privilege"
    sudo printf "\e[32;4mSetup zsh\e[0m \e[32mRoot privilege - ✔  OK\e[0m\n"
    if [ $? -ne 0 ]; then
      e_error "Setup zsh" "Wrong password"
      e_error "Setup zsh" "Abort the process"
      exit 1
    fi

    e_log "Setup zsh" "Adding shells..."
    sudo sh -c "echo $ZSH_PATH >>/etc/shells"
    check_result $? "Setup zsh" "Add shells"

    e_log "Setup zsh" "Changing default shell..."
    chsh -s $ZSH_PATH      # user
    sudo chsh -s $ZSH_PATH # root
    check_result $? "Setup zsh" "Change default shell"
    ;;
  esac
}

setup_zsh
