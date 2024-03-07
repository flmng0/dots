#!/usr/bin/env zsh

CURRENT_DIR=${0:A:h}
CONFIG_PATH="/etc/nixos/configuration.nix"

echo ":: Linking NixOS configuration"

sudo rm "$CONFIG_PATH"
sudo ln -s "$CURRENT_DIR/configuration.nix" "$CONFIG_PATH"

echo ":: Rebuilding NixOS"

sudo nixos-rebuild switch > "$PWD/install.log"

