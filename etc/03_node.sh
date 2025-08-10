#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_node() {
  e_header "Install Node" "Start installation Node"

  e_log "Install Node" "Checking installed Node..."
  if nodenv versions | grep -q $(echo $NODE_VERSION); then
    e_done "Install Node" "ver.$NODE_VERSION is already installed"
  else
    e_log "Install Node" "ver.$NODE_VERSION is NOT installed"
    e_log "Install Node" "Installing ver.$NODE_VERSION..."
    nodenv install $NODE_VERSION
    check_result $? "Install Node" "Install"
  fi

  e_log "Install Node" "Changing global Node version..."
  nodenv global $NODE_VERSION
  check_result $? "Install Node" "Change global Node version"
}

install_modules() {
  e_header "Install modules" "Start installation Node modules"

  e_log "Install modules" "Installing typescript..."
  npm install -g npm
  npm install -g typescript
  npm install -g prettier
  npm install -g prettier-plugin-md-nocjsp
  check_result $? "Install modules" "Install typescript"

  e_log "Install modules" "Cleaning modules"
  npm cache clean --force
  check_result $? "Install modules" "Cleanup modules"
}

install_node
install_modules
