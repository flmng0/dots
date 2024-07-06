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

plugins=(
	git 
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration
#
export EDITOR='nvim'

alias hx=helix

if [[ -s "$HOME/.cargo/env" ]]; then
	. "$HOME/.cargo/env"
else
	echo "Cargo not installed!"
fi


# Use mise for development tools
which mise &> /dev/null

if [[ $? -eq 0 ]]; then
	eval "$(mise activate zsh)"
else
	echo "Mise not installed! Goto https://mise.jdx.dev"
end

# Used for the prompt
which starship &> /dev/null

if [[ $? -eq 0 ]]; then
	eval "$(starship init zsh)"
else
	echo "Starship not installed! Goto https://starship.rs"
end

# opam configuration
[[ ! -r $HOME/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

