# ~/.zshrc

# -----------------------------------------------------------------------------
# History settings
# -----------------------------------------------------------------------------

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# -----------------------------------------------------------------------------
# Shell behaviour
# -----------------------------------------------------------------------------

setopt AUTOCD
setopt NOBEEP
setopt NUMERIC_GLOB_SORT	# Sort numbers by value, not string-based

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------

autoload -Uz compinit	# Load completion system

compinit -d "$XDG_CACHE_HOME/zsh/zcompdump" # Initialize with cached metadata

zstyle ':completion:*' menu select	# Enable interactive menu selection
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'	# Make case-insensitive

# -----------------------------------------------------------------------------
# cd path
#-----------------------------------------------------------------------------

cdpath=(~ ~/.bin ~/Dev)

# -----------------------------------------------------------------------------
# Import aliases
# -----------------------------------------------------------------------------

if [ -f $ZDOTDIR/aliases.zsh ]; then source $ZDOTDIR/aliases.zsh; fi
if [ -f $ZDOTDIR/aliases.local.zsh ]; then source $ZDOTDIR/aliases.local.zsh; fi

# -----------------------------------------------------------------------------
# Fuzzy finder (fzf)
# -----------------------------------------------------------------------------

# Arch
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# -----------------------------------------------------------------------------
# Initialise smart directory navigation (zoxide) and replace shell built-in cd
# -----------------------------------------------------------------------------

eval "$(zoxide init zsh --cmd cd)"

# -----------------------------------------------------------------------------
# SSH-agent / KDE integration
# -----------------------------------------------------------------------------

export SSH_ASKPASS=/usr/bin/ksshaskpass

# -----------------------------------------------------------------------------
# Modular config files
# -----------------------------------------------------------------------------

source "$ZDOTDIR/fzf.zsh"	# fzf configuration
source "$ZDOTDIR/bindings.zsh"	# Custom keybindings
source "$ZDOTDIR/plugins.zsh"	# Plugins and plugin manager
source "$ZDOTDIR/prompt.zsh"	# Prompt/theme
#source "$ZDOTDIR/ssh_agent.zsh"	# Launch ssh-agent
