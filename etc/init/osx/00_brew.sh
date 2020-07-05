if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/etc/install

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
  brew install coreutils
  brew install curl
  brew install ffmpeg
  brew install git
  brew install diff-so-fancy
  # brew install ghostscript
  # brew install gnuplot --with-x11
  # brew install hub
  brew install imagemagick
  # brew install nodebrew
  brew install openssl
  # brew install pandoc
  # brew install povray
  brew install rbenv
  brew install ruby-build
  brew install sqlite
  # brew install terminal-notifier
  # brew install tmux
  brew install tree
  brew install unrar
  brew install wget
  brew install zsh
  brew install fzf

  # brew cask install appcleaner
  # brew cask install basictex
  # brew cask install diskwave
  # brew cask install dropbox
  # brew cask install google-chrome
  # brew cask install github-desktop
  # brew cask install qlmarkdown
  # brew cask install texshop
  # brew cask install sublime-text
  # brew cask install vlc
  # brew cask install xquartz

  brew install mas

  mas install 539883307  # LINE (4.9.0)
  mas install 417375580  # BetterSnapTool (1.7)
  mas install 409183694  # Keynote (7.0)
  # mas install 557168941 # Tweetbot
  mas install 1176895641 # Spark
  # mas install 411431426  # GIFQuickMaker (1.5.1)
  # mas install 407963104  # Pixelmator (3.5.1)
  mas install 1289583905  # Pixelmator Pro (1.5.5)
  # mas install 434290957  # Motion (5.2.3)
  # mas install 992076693  # MindNode (2.3.5)
  mas install 409203825  # Numbers (4.0)
  mas install 497799835  # Xcode (8.0)
  mas install 412448059  # ForkLift (2.6.6)
  mas install 409201541  # Pages (6.0)
  # mas install 928871589  # Noizio (1.5)
  # mas install 420212497  # Byword (2.7)
  # mas install 919269455  # StuffIt Expander 16 (16.0.5)
  # mas install 406580224  # Blotter (2.2.3)
  mas install 1225570693 # Ulysses (18.6)
  # mas install 824183456 # Affinity Photo (1.8.2)

  e_done "Install"
}

install_homebrew
install_formulas
