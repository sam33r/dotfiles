#!/bin/bash

sleep 2

# This enables gtk settings from gnome, required for gtk themes.
gnome-settings-daemon &

sleep 2

# Run compton composition manager.
compton -f &

sleep 5

# Hide from blue light at night.
redshift-gtk &

sleep 2

# Start feh for wallpaper.
feh --randomize --bg-fill ~/Wallpapers/* &

sleep 2

# Start the network management applet.
nm-applet &

sleep 2

# Start pulse volume control system tray applet.
pasystray &


