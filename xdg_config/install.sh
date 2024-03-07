#!/usr/bin/env zsh

CURRENT_DIR=${0:A:h}

CONFIGS=$(find . -mindepth 1 -maxdepth 1 -type d)

for config in $CONFIGS;
do
  echo ":: Installing configuration for '$config'"

  if [[ -x "$config/install.sh" ]];
  then
    "$config/install.sh"
  else
    rm -r "$HOME/.config/$config"
    ln -s "$config" "$HOME/.config/$config"
  fi
done
