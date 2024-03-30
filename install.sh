#!/usr/bin/env nix-shell
#! nix-shell -i zsh -p zsh stow

CURRENT_DIR=${0:A:h}

nixos() {
  NIXOS_CONFIG_PATH="/etc/nixos/configuration.nix"
  NIXOS_LINK=$(readlink "$NIXOS_CONFIG_PATH")

  echo "$CURRENT_DIR"

  if [ $? -eq 0 ]; 
  then
    echo ":: NixOS configuration already linked, skipping..."
    return
  fi

  echo ":: Linking NixOS configuration"
  
  sudo mv "$CONFIG_PATH" "/tmp/nixos-configuration.old.nix"
  sudo ln -s "$CURRENT_DIR/nixos/configuration.nix" "$CONFIG_PATH"

  echo ":: Rebuilding NixOS"

  sudo nixos-rebuild switch > "$PWD/install.log"

  echo ":: Rebuilt NixOS, find installation log at $PWD/install.log"
  echo ":: Old NixOS configuration can be found at /tmp/nixos-configuration.old.nix"
}

nixos

echo ":: Installing application configurations"

stow home


