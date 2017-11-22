#!/bin/bash

# This enables gtk settings from gnome, required for gtk themes.
gnome-settings-daemon &
gnome-keyring-daemon &

sleep 1

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

sleep 1

run_keybase
copyq &
emacs --daemon &
