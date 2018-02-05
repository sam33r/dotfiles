#!/bin/bash

sleep 1

# This enables gtk settings from gnome, required for gtk themes.
gnome-settings-daemon &
gnome-keyring-daemon &
# Speed up the keyboard repeat rate.
xset r rate 200 51
# Run compton composition manager.
compton -f &
# Start the network management applet.
nm-applet &
# Start pulse volume control system tray applet.
# pasystray &
# Start feh for wallpaper.
feh --randomize --bg-fill ~/Wallpapers/* &
unclutter &
copyq &
google-chrome &
gnome-terminal -e "tmux new -A -s 'persistent'" &
emacsclient -c --alternate-editor "" &
redshift &
start-pulseaudio-x11 &

if [[ -x "./autostart.local.sh" ]]; then
  ./autostart.local.sh
fi

while true; do
   xsetroot -name "$( date )"
   sleep 10
done &
