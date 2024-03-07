#!/usr/bin/env zsh

CURRENT_DIR=${0:A:h}

for config in zshrc p10k.zsh;
do
  rm "$HOME/.$config"
  ln -s "$CURRENT_DIR/$config" "$HOME/.$config"
done

