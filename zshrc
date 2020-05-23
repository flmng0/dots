ZSH_CONFIG="$HOME/.zsh"

source $ZSH_CONFIG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH_CONFIG/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTO_SUGGEST_STRATEGY=(history completion)

fpath+=("$ZSH_CONFIG/pure")

autoload -U promptinit; promptinit

zstyle :prompt:pure:path color 014
prompt pure

alias py=python3

export PATH=$HOME/bin:$PATH
export RUSTC_WRAPPER=sccache

