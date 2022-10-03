if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/lib/utility.sh

install_ruby() {
  e_newline && e_header "Installing Ruby..."
  RUBY_VERSION=$(rbenv install -L | grep -v - | grep -e "^[ ]*[0-9].*" | tail -1)
  if rbenv versions | grep -q "$RUBY_VERSION"; then
    e_header "Ruby is already installed"
  else
    rbenv install $RUBY_VERSION
    if [ $? -ne 0 ]; then
      e_error "failed to install Ruby"
      exit 1
    fi
  fi
  rbenv global $RUBY_VERSION
  e_done "Install"
}

install_gems() {
  e_newline && e_header "Installing Ruby gems..."
  rbenv exec gem install bundler
  if [ $? -ne 0 ]; then
    e_error "failed to install gem bundler"
    exit 1
  fi
  bundle install
  e_done "Install"
}

install_ruby
install_gems
