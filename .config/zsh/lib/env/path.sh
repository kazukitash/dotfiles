#!/bin/zsh
# PATH関連の設定

# has関数が未定義の場合はutil.shを読み込む
if ! command -v has > /dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# PATHの設定
# macOSの/etc/zprofileにpath_helperのevalがありPATHを上書きしてしまうのでzprofileの読み込みを無効化
setopt no_global_rcs
case "$(arch)" in
  macOS)
    if [ -x /usr/libexec/path_helper ]; then
      eval $(/usr/libexec/path_helper -s)
    fi
    ;;
esac

# homebrewの設定
case "$(arch)" in
  macOS)
    eval "$(/opt/homebrew/bin/brew shellenv)"
    ;;
  Linux)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    ;;
esac

# miseの設定
if has mise; then
  eval "$(mise activate zsh)"
  export MISE_DISABLE_TOOLS="node python"
fi

# openjdkの設定
case "$(arch)" in
  macOS)
    path=(/opt/homebrew/opt/openjdk/bin $path)
    ;;
esac

# GCPの設定
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"
export ADMINSDK_PROD="$HOME/.config/firebase/adminsdk_prod.json"
export ADMINSDK_DEV="$HOME/.config/firebase/adminsdk_dev.json"
# Google Cloud SDK
gcspath="/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
if [ -f gcspath ]; then
  source "${gcspath}/path.zsh.inc"
  source "${gcspath}/completion.zsh.inc"
fi

# uvの設定
if has uv; then
  autoload -Uz compinit && compinit # (eval):4373: command not found: compdef の対策
  eval "$(uv generate-shell-completion zsh)"
fi

# kibanaの設定
if has kibana; then
  export KBN_PATH_CONF="$HOME/.config/kibana"
  # brew services start elastic/tap/kibana-full で起動できる
fi

# zoxideの設定
if has zoxide; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# pnpm の設定
if has pnpm; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
  path=($PNPM_HOME $path)
fi

if has dotnet; then
  export PATH="$PATH:$HOMEBREW_PREFIX/opt/dotnet/bin:$HOME/.dotnet/tools"
  export DOTNET_ROOT="$HOMEBREW_PREFIX/opt/dotnet/libexec"
fi

# 個人用のPATH
path=(~/.local/bin $path)

export PATH
