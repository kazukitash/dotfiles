#!/bin/bash -xeu

GITHUB_URL=https://github.com/kazukitash/dotfiles.git
TARBALL_URL=https://github.com/kazukitash/dotfiles/archive/main.tar.gz

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
[ "$(uname)" = "Linux" ] && export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
