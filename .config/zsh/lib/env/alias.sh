#!/bin/zsh
# エイリアスの設定

# has関数が未定義の場合はutil.shを読み込む
if ! command -v has > /dev/null 2>&1; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/lib/util.sh"
fi

# Git関連のエイリアス
alias ga="git add ."
alias gs="git stash -u"
alias gsp="git stash pop"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gl="git log --pretty=oneline"
alias grhh="git reset --hard HEAD"
alias grsh="git reset --soft HEAD^"
alias gpr="git stash && git pull --rebase origin main && git stash pop"

# 基本コマンドのエイリアス
alias l="ls -lahp"
alias ls="ls -Gp"

# Homebrew関連
alias bubu="brew update && brew outdated && brew upgrade && brew cleanup"

# Python関連
alias python="python3"
alias pip="pip3"

# Docker関連
alias dcd="docker compose down -v"

# dcln (Docker CLeaN)
# 1) docker ps -q | xargs -r docker kill
#    - 実行中のコンテナをすべて停止
# 2) docker ps -aq | xargs -r docker rm
#    - 全コンテナを削除（停止中のものも含む）
# 3) docker system prune -a -f --volumes
#    - 未使用のコンテナ、ネットワーク、イメージ、ビルドキャッシュ、ボリュームを一括削除
#    - -a: 使用していないイメージも削除
#    - -f: 確認プロンプトをスキップ
#    - --volumes: 未使用のボリュームも削除
# 4) docker network prune -f
#    - 未使用のネットワークを削除
alias dcln="\
  docker ps -q | xargs -r docker kill && \
  docker ps -aq | xargs -r docker rm && \
  docker system prune -a -f --volumes && \
  docker network prune -f \
"

# 開発ツール関連
alias pn="pnpm"
alias zed="zed -a"
alias vim="nvim"
alias c="claude"

# プロジェクト固有のエイリアス
alias iris-check="pn -F iris fix && pn -F iris check"
alias wandh-check="poetry run openapi && poetry run format && poetry run lint && poetry run typecheck"
alias dev="WKLR_ES_PORT=9200 docker compose up -d nginx iris labs-wandh wklr-jobs wklr-es"
alias dev-wklr="WKLR_ES_PORT=9200 docker compose up -d nginx wklr wklr-backend-api wklr-mysql wklr-es"
