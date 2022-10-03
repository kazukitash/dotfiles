has() {
  type "$1" >/dev/null 2>&1
  return $?
}

e_newline() {
  printf "\n"
}

e_header() {
  printf "\033[37;1m%s\033[m\n" "$*"
}

e_done() {
  printf "\033[32m✔\033[m  \033[37m%s\033[m - \033[32mOK\033[m\n" "$*"
}

e_error() {
  printf "\033[31m✖\033[m  \033[37m%s\033[m - \033[31mFailed\033[m\n" "$*" 1>&2
}
