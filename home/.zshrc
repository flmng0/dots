# Oh My ZSH Setup
#
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

CASE_SENSITIVE="true"

# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Attempt to auto-update OMZ every N days
zstyle ':omz:update' frequency 13

# Lazy load nvm
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' lazy-cmd nvim

plugins=(
	git 
	nvm 
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# User configuration
#
export EDITOR='nvim'

alias hx=helix

[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# Used for the prompt
eval "$(starship init zsh)"

# opam configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
