#!/usr/bin/env bash

# Get config file path from $NIXOS_CONFIG environment variable.
CONFIG_PATH="/etc/nixos/configuration.nix"
[ -n "$NIXOS_CONFIG" ] && CONFIG_PATH=$NIXOS_CONFIG

# Follow it incase it's a symlink.
CONFIG_PATH=$(readlink -f "$CONFIG_PATH")

# Get the owner, and use sudoedit if the owner is root.
CONFIG_OWNER=$(ls -l $CONFIG_PATH | awk '{print $3}')

if [ "$CONFIG_OWNER" = "root" ]; then
  EDIT_CMD="sudoedit"
else
  EDIT_CMD="$EDITOR"
fi

# Get the systemPackages line number (N) and convert it to an argument
# that looks like "+N".
#
# At least Nano, NeoVim, and Helix support this.
LINE_ARG=$(grep -n "systemPackages" "$CONFIG_PATH" | awk '{print $1}' | sed -e 's/://' -e 's/^/+/')


# Get the check sum before and after modification, to check whether a
# change was actually made or not.
SUM_BEFORE="$(md5sum $CONFIG_PATH)"

$EDIT_CMD "$CONFIG_PATH" "$LINE_ARG"

SUM_AFTER="$(md5sum $CONFIG_PATH)"

if [ "$SUM_BEFORE" = "$SUM_AFTER" ]; then
  echo "No modification detected, exiting..."
  exit 0
fi


read -p "Configuration modification detected. Do you want to switch now? [Yn] " yn
case $yn in
  [Nn]* ) exit;;
esac

sudo nixos-rebuild switch

