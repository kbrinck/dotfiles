# Aliases common to all machines - may be Arch-specific

# -----------------------------------------------------------------------------
# Reload ZSH configuration files
# -----------------------------------------------------------------------------

#alias S='source $XDG_CONFIG_HOME/zsh/.zshrc'
alias S='exec zsh'

# -----------------------------------------------------------------------------
# Remapping of existing system commands with "better" versions.
# -----------------------------------------------------------------------------

if [ -e /usr/bin/eza ]
then
	alias ls='eza --icons'
	alias ll='eza -lh --icons --git'
	alias la='eza -lah --icons --git'
	alias tree='eza --tree --icons'

	# Reuse ls completions for eza (avoids defining a separate completion function)
	compdef eza=ls

	alias ols='/usr/bin/ls'

	if [ -e /usr/bin/tree ]; then alias otree='/usr/bin/tree'; fi
fi

if [ -e /usr/bin/bat ]
then
	alias ocat=/usr/bin/cat
	alias cat="bat"
fi

# if [ -e /usr/bin/rg ]
# then
# 	alias ogrep=/usr/bin/grep
# 	alias grep="rg --color=auto"
# fi

# if [ -e /usr/bin/fd ]
# then
# 	alias ofind=/usr/bin/find
# 	alias find="fd"
# fi

# if [ -e /usr/bin/difft ]
# then
# 	alias odiff=/usr/bin/diff
# 	alias diff="difft"
# fi

# -----------------------------------------------------------------------------
# Aliases for fast editing of various config files
# -----------------------------------------------------------------------------

alias nrc='nvim $XDG_CONFIG_HOME/nvim/lua/config/options.lua'
alias zrc='nvim $XDG_CONFIG_HOME/zsh/.zshrc'
alias zrca='nvim $XDG_CONFIG_HOME/zsh/aliases.zsh'

# -----------------------------------------------------------------------------
# Aliases for common comannds / options
# -----------------------------------------------------------------------------

alias ..='cd ..'                  # Type ".." to go up one directory
alias ...='cd ../..'              # Type "..." to go up two directories
alias c="clear"
alias df="df -h"
alias nv="nvim"
alias nvd='nvim -c "lua require(\"dapui\").open()"'
alias nvq="nvim-qt"

# -----------------------------------------------------------------------------
# GIT-related aliases
# -----------------------------------------------------------------------------

alias gta="git add"
alias gts="git status"
alias gtc="git commit -m"
alias gtp="git push; git push github"
alias gd="git diff"
alias gdt="git difftool"
alias gb="git branch"
alias gcb="git checkout"

# -----------------------------------------------------------------------------
# Python-related aliases
# -----------------------------------------------------------------------------

alias python='python3'            # Type "python" to run Python 3
alias pip='pip3'                  # Type "pip" to use pip3
alias ruffc='uv run ruff check --output-format=full'
