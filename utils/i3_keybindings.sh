#!/bin/bash
# Utility script to list i3 keybindings in rofi. Select a
# keybinding to edit it in emacs.

I3CONFIG="$HOME/dotfiles/i3config"
linum=$(ag "^bind" $I3CONFIG | rofi -dmenu -p "Edit Binding: "| cut -d":" -f1)
echo $linum

if [ -z "$linum" ]
then
  echo "Nothing selected."
else
  emacsclient -c +$linum $I3CONFIG
fi
