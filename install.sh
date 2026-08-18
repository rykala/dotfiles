#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# stow only reads .stowrc from the current directory, so run from the repo root.
cd "$DOTFILES"

# The repo itself is the package, so the package name is "." and the stow dir is
# the repo. Passing --dir="$HOME" instead makes stow skip everything, because it
# refuses to treat the target as its own stow directory.
stow --dir="$DOTFILES" --target="$HOME" --restow .
echo "stow: linked $DOTFILES into $HOME"

link_lazygit() {
  if ! command -v lazygit >/dev/null 2>&1; then
    echo "lazygit: not installed, skipping"
    return
  fi

  local src dir dest
  src="$DOTFILES/.config/lazygit/config.yml"
  dir="$(lazygit -cd)"
  dest="$dir/config.yml"

  mkdir -p "$dir"

  if [ -e "$dest" ] && [ ! -L "$dest" ] && [ -s "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "lazygit: backed up existing config to $dest.bak"
  fi

  ln -sfn "$src" "$dest"
  echo "lazygit: linked $dest"
}

link_lazygit

# Terraform ignores plugin_cache_dir (with only a warning) when the directory
# does not exist, so .terraformrc is useless without this.
create_terraform_plugin_cache() {
  local dir="$HOME/.terraform.d/plugin-cache"
  mkdir -p "$dir"
  echo "terraform: plugin cache at $dir"
}

create_terraform_plugin_cache
