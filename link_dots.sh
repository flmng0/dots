#!/bin/zsh

# Configs that have individual files need to have their
# appropriate directories created, before the configs
# can be linked.
#
# So this routine to create configuration directories and
# link the respective files.
link_config_file() {
    src="$1"
    dst="$2"

    mkdir -p `dirname "$dst"`
    ln -s $src $dst
}

link_config "$PWD/alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"
link_config "$PWD/zshrc" "$HOME/.zshrc"

# Directories can be linked directly as they are simple.
ln -s "$PWD/nvim" "$HOME/.config/nvim"
