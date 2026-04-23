#!/bin/bash -eu

if [ -z "${DOTPATH:-}" ]; then
  echo '$DOTPATH not set' >&2
  exit 1
fi

. "$DOTPATH"/.config/zsh/lib/util.sh

setup_terraform_plugin_cache() {
  e_header "Terraform" "Setup plugin cache dir"

  local cache_dir="$HOME/.terraform.d/plugin-cache"

  if [ -d "$cache_dir" ]; then
    e_done "Terraform" "Plugin cache already exists: $cache_dir"
    return 0
  fi

  e_log "Terraform" "Creating $cache_dir"
  mkdir -p "$cache_dir"
  check_result $? "Terraform" "Create plugin cache dir"
}

setup_terraform_plugin_cache
