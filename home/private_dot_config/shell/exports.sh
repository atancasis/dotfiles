# shellcheck shell=sh
# Sourced by ~/.config/zsh/.zshrc.

# https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# GPG uses this terminal for passphrase prompts. $TTY is set by zsh.
export GPG_TTY="$TTY"

# Language
export LANG="en_US.UTF-8"

# zsh-evalcache
export ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME/zsh-evalcache"
