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
  RUBY_VERSION=$(rbenv install -l | grep -v - | grep -e "^[ ]*[0-9]\+.[0-9]\+.[0-9]\+$" | tail -1)
  if rbenv versions | grep -q $(echo $RUBY_VERSION); then
    e_header "[Ruby] Ruby ver.$RUBY_VERSION is already installed"
  else
    e_header "[Ruby] Installing Ruby ver.$RUBY_VERSION..."
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
  case "$(uname)" in
  Darwin)
    e_done "OS detected. Start installation for macOS"
    bundle install --gemfile=${DOTPATH}/etc/macos/Gemfile
    ;;
  Linux)
    e_done "OS detected. Start installation for Linux"
    bundle install --gemfile=${DOTPATH}/etc/linux/Gemfile
    ;;
  *)
    e_error "Unknown OS. Abort the process"
    ;;
  esac
  gem cleanup
  e_done "Install"
}

install_ruby
install_gems
