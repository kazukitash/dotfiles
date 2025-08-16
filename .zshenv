export ZDOTDIR="$HOME/.config/zsh"

# Zed editorが環境変数を保持した状態でSHELLを起動するため.zshenvの実態をZDOTDIRに配置
[ -r "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
