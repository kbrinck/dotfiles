# ~/.config/zsh/.zshenv
#
# -----------------------------------------------------------------------------
# XDG base directories
# -----------------------------------------------------------------------------

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# -----------------------------------------------------------------------------
# Default editor
# -----------------------------------------------------------------------------

export EDITOR="nvim"
export VISUAL="nvim"

# -----------------------------------------------------------------------------
# Pager
# -----------------------------------------------------------------------------

if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
fi

# -----------------------------------------------------------------------------
# Personal binaries/scripts
# -----------------------------------------------------------------------------

export PATH="$HOME/.bin:$PATH"

# -----------------------------------------------------------------------------
# Possibly needed to get ssh-agent working
# -----------------------------------------------------------------------------
#
export SSH_AUTH_SOCK=${SSH_AUTH_SOCK:-/run/user/$(id -u)/ssh-agent.socket}
