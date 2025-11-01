#!/bin/bash -eu
# GitHubのPATをmacOSのキーチェーンから取得してMCPサーバーを起動する

KEYCHAIN_SERVICE="${KEYCHAIN_SERVICE:-zed-github-pat}"
KEYCHAIN_ACCOUNT="${KEYCHAIN_ACCOUNT:-$USER}"

if ! command -v security > /dev/null 2>&1; then
  echo "securityコマンドが見つかりません" >&2
  exit 1
fi

if ! TOKEN="$(security find-generic-password -s "$KEYCHAIN_SERVICE" -a "$KEYCHAIN_ACCOUNT" -w 2> /dev/null)"; then
  echo "キーチェーンに service=${KEYCHAIN_SERVICE} account=${KEYCHAIN_ACCOUNT} の項目がありません" >&2
  exit 1
fi

BINARY_ROOT="$HOME/Library/Application Support/Zed/extensions/work/mcp-server-github"

if [[ ! -d "$BINARY_ROOT" ]]; then
  echo "GitHub MCPサーバーのバイナリが ${BINARY_ROOT} に見つかりません" >&2
  exit 1
fi

CANDIDATES=()
while IFS= read -r candidate; do
  CANDIDATES+=("$candidate")
done < <(find "$BINARY_ROOT" -type f -name github-mcp-server -print | sort)

if ((${#CANDIDATES[@]} == 0)); then
  echo "GitHub MCPサーバーの実行ファイルが見つかりません" >&2
  exit 1
fi

LAST_INDEX=$((${#CANDIDATES[@]} - 1))
BINARY_PATH="${CANDIDATES[$LAST_INDEX]}"

export GITHUB_PERSONAL_ACCESS_TOKEN="$TOKEN"

exec "$BINARY_PATH" stdio "$@"
