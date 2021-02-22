#!/bin/zsh

# Configurations need to have their parent directories
# created before they can be symlinked.
link_config() {
    src="$1"
    dst="$2"

    mkdir -p `dirname "$dst"`
    ln -s $src $dst
}

link_config "$PWD/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
link_config "$PWD/zshrc" "$HOME/.zshrc"

link_config "$PWD/nvim" "$HOME/.config/nvim"
