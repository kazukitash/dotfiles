if [ -z "$DOTPATH" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/install

# ユーザーID（ユーザーネーム、メールアドレス）を設定する
setup_user_id() {
  e_newline && e_header "Setting user id..."
  git config --global user.name 'kazukitash'
  git config --global user.email 'kazukitash@gmail.com'
  e_done "Set up"
}

# ファイル名の大文字と小文字を区別する
setup_not_ignore_case() {
  e_newline && e_header "Setting not ignore case..."
  git config --global core.ignorecase false
  e_done "Set up"
}

# 改行コードの自動変換を無効にする
setup_auto_crlf() {
  e_newline && e_header "Setting manual crlf..."
  git config --global core.autocrlf false
  e_done "Set up"
}

# デフォルトブランチ名を main にする
setup_default_branch() {
  e_newline && e_header "Setting default branch..."
  git config --global init.defaultBranch main
  e_done "Set up"
}

# pull 時の挙動を rebase にする
setup_pull_rebase() {
  e_newline && e_header "Setting color ui..."
  git config --global pull.rebase true
  e_done "Set up"
}

# pager を diff so fancy にする
setup_diff_so_fancy() {
  e_newline && e_header "Setting diff so fancy..."
  git config --global pager.diff "diff-so-fancy | less --tabs=1,5 -RFX"
  git config --global pager.show "diff-so-fancy | less --tabs=1,5 -RFX"
  e_done "Set up"
}

# ui をカラフルにする
setup_color_ui() {
  e_newline && e_header "Setting color ui..."
  git config --global color.ui true
  e_done "Set up"
}

# 日本語ファイルをエンコードしない
setup_jp_encode() {
  e_newline && e_header "Setting japanese encode..."
  git config --global core.quotepath false
  e_done "Set up"
}

# password の keychain 利用
setup_keychain() {
  e_newline && e_header "Setting keychain..."
  git config --global credential.helper osxkeychain
  e_done "Set up"
}

# pull時 fast-forward な場合のみ merge をし、それ以外の場合は merge はされずエラーとなる
setup_pull_fastforward() {
  e_newline && e_header "Setting pull fast forward..."
  git config --global pull.ff only
  e_done "Set up"
}

# mergeはfastforwardしない
setup_merge_no_fastforward() {
  e_newline && e_header "Setting merge no fast forward..."
  git config --global --add merge.ff false
  e_done "Set up"
}

# 現在のブランチをリモートに同じ名前で push する
setup_remote_branch() {
  e_newline && e_header "Setting remote branch..."
  git config --global push.default current
  e_done "Set up"
}

setup_ignore() {
  e_newline && e_header "Setting ignore files..."
  git config --global core.excludesfile ~/.gitignore_global
  e_done "Set up"
} 

e_newline && e_header "Configure git config"
setup_user_id
setup_not_ignore_case
setup_auto_crlf
setup_default_branch
setup_pull_rebase
setup_diff_so_fancy
setup_color_ui
setup_jp_encode
setup_keychain
setup_pull_fastforward
setup_remote_branch
setup_ignore

