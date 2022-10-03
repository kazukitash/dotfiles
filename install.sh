#!/bin/bash -xeu

DOTPATH=~/.dotfiles
GITHUB_URL=https://github.com/kazukitash/dotfiles.git
TARBALL_URL=https://github.com/kazukitash/dotfiles/archive/master.tar.gz

. "$DOTPATH"/lib/utility.sh

dotfiles_download() {
  e_newline && e_header "Downloading dotfiles..."
  if has "git"; then
    git clone --recursive "$GITHUB_URL" "$DOTPATH"
  elif has "curl" || has "wget"; then
    if has "curl"; then
      curl -L "$TARBALL_URL"
    elif has "wget"; then
      wget -O - "$TARBALL_URL"
    fi | tar xvz
    if [ ! -d dotfiles-master ]; then
      e_error "dotfiles-master: not found"
      exit 1
    fi
    mv -f dotfiles-master "$DOTPATH"
  else
    e_error "curl or wget required"
    exit 1
  fi
  e_done "Download"
}

dotfiles_deploy() {
  e_newline && e_header "Deploying dotfiles..."
  cd "$DOTPATH"
  make deploy
  e_done "Deploy"
}

dotfiles_setup() {
  e_newline && e_header "Setting dotfiles..."
  cd "$DOTPATH"
  make setup
  e_done "Set up"
}

dotfiles_logo='
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
'

# main
# shell の option を確認してインタラクティブである場合は終了する
if echo "$-" | grep -q "i"; then
  e_newline && e_error "Can not continue with interactive shell. Abort the process"
  exit 1
else
  # 実行ソースを確認して、ファイルから実行している場合（bash a.sh）は終了する
  if [ "$0" = "${BASH_SOURCE:-}" ]; then
    e_newline && e_error "Can not continue with BASH_SOURCE. Abort the process"
    exit 1
  else
    # bash -c "$(cat a.sh)" もしくは cat a.sh | bash の場合実行する
    # BASH_EXECUTION_STRING で -c オプションで渡された文字列を出力する。nullなら:-で空文字列に置換し-nで空文字列判定する
    # パイプで渡されていたら/dev/stdinがFIFOになりパイプとして判定される
    if [ -n "${BASH_EXECUTION_STRING:-}" ] || [ -p /dev/stdin ]; then
      case "$(uname)" in
      "Darwin" | "Linux")
        e_newline && e_header "Start installation for macOS/Linux..."
        ;;
      *)
        e_newline && e_error "Unknown OS. Abort the process"
        exit 1
        ;;
      esac
      echo "$dotfiles_logo"
      dotfiles_download
      dotfiles_deploy
      dotfiles_setup
      e_done "All processing"
      e_newline && e_header "Now continue with rebooting your shell."
    fi
  fi
fi