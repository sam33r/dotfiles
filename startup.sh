#!/bin/bash

run_keybase && sleep 1 && i3-msg kill

sleep 1

gnome-terminal -e 'tmux new -A -s "persistent"' &
sleep 1
i3-msg move scratchpad

# This enables gtk settings from gnome, required for gtk themes.
gnome-settings-daemon &
gnome-keyring-daemon &

sleep 1

# Speed up the keyboard repeat rate.
xset r rate 200 50

# Run compton composition manager.
compton -f &

sleep 1

# Start the network management applet.
nm-applet &
# Start pulse volume control system tray applet.
pasystray &
# Start feh for wallpaper.
feh --randomize --bg-fill ~/Wallpapers/* &
unclutter &
emacs --daemon &
copyq &

sleep 10

# get all the prompts out of the way.
emacsclient -c -e "(sa/startup)" &
