#!/bin/bash -xeu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install.sh

install_ruby() {
  e_newline && e_header "[Ruby] Installing Ruby..."
  e_header "[Ruby] Loading anyenv..."
  eval "$(anyenv init -)"
  RUBY_VERSION=$(rbenv install -L | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1)
  if rbenv versions | grep -q $(echo $RUBY_VERSION); then
    e_header "[Ruby] Ruby is already installed"
  else
    rbenv install $RUBY_VERSION
    if [ $? -ne 0 ]; then
      e_error "Install Ruby"
      exit 1
    fi
  fi
  rbenv global $RUBY_VERSION
  e_done "Install"
}

install_gems() {
  e_newline && e_header "[Ruby] Installing Ruby gems..."
  rbenv exec gem install bundler
  if [ $? -ne 0 ]; then
    e_error "Install gem bundler"
    exit 1
  fi
  bundle install --gemfile=${DOTPATH}/etc/Gemfile
  e_done "Install"
}

install_ruby
install_gems
