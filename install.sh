#!/bin/sh

# Apply this checkout with chezmoi. Without chezmoi on the PATH, use a
# throwaway copy; Homebrew installs the real one during the apply.

set -eu

if ! chezmoi=$(command -v chezmoi); then
  bindir=$(mktemp -d)
  trap 'rm -rf -- "$bindir"' EXIT
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bindir"
  chezmoi="$bindir/chezmoi"
fi

script_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
"$chezmoi" init --apply --source="$script_dir" "$@"
