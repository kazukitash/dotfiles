#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_ruby() {
  e_header "Install Ruby" "Start installation Ruby"

  e_log "Install Ruby" "Checking installed Ruby..."
  if rbenv versions | grep -q $(echo $RUBY_VERSION); then
    e_done "Install Ruby" "ver.$RUBY_VERSION is already installed"
  else
    e_log "Install Ruby" "ver.$RUBY_VERSION is NOT installed"
    e_log "Install Ruby" "Installing ver.$RUBY_VERSION..."
    rbenv install $RUBY_VERSION
    check_result $? "Install Ruby" "Install"
  fi

  e_log "Install Ruby" "Changing global ruby version..."
  rbenv global $RUBY_VERSION
  check_result $? "Install Ruby" "Change global ruby version"
}

install_gems() {
  e_header "Install gems" "Start installation Ruby gems"

  e_log "Install gems" "Installing bundler..."
  gem install bundler
  check_result $? "Install gems" "Install bundler"

  if isArch macOS; then
    e_done "Install gems" "Installing for macOS..."
    bundle install --gemfile=${DOTPATH}/etc/macos/Gemfile
    check_result $? "Install gems" "Install"
  elif isArch Linux; then
    e_done "Install gems" "Installing for Linux..."
    bundle install --gemfile=${DOTPATH}/etc/linux/Gemfile
    check_result $? "Install gems" "Install"
  else
    e_log "Install gems" "Unknown OS"
    e_error "Install gems" "Install"
    e_log "Install gems" "Skip the process"
  fi

  e_log "Install gems" "Cleaning gems"
  gem cleanup
  check_result $? "Install gems" "Cleanup gems"
}

install_ruby
install_gems
