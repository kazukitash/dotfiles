if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install

setup_diff_so_fancy(){
  e_newline && e_header "Setting diff so fancy..."
  git config --global pager.diff "diff-so-fancy | less --tabs=1,5 -RFX"
  git config --global pager.show "diff-so-fancy | less --tabs=1,5 -RFX"
  e_done "Set up"
}

setup_diff_so_fancy
