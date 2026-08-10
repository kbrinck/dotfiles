# -----------------------------------------------------------------------------
# Prompt setup (starship)
# -----------------------------------------------------------------------------
#
# Prevent Python virtualenv from polluting the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=1
export STARSHIP_CONFIG=$ZDOTDIR/starship.toml

FUNCNEST=100

eval "$(starship init zsh)"
