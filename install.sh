#!/usr/bin/env nix-shell
#! nix-shell -i zsh --pure
#! nix-shell -p zsh

INSTALLERS=$(find . -mindepth 2 -type f -name install.sh -perm /+x)

echo ":: Installing application configurations"

for installer in $INSTALLERS;
do
  echo ":: Running installer script: $installer"
  $installer
done

echo ":: Done!"

echo ":: Installer output can be found in '$PWD/install.log'"

