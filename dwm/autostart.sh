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
google-chrome-beta "https://www.gmail.com" &
google-chrome-beta "https://chat.google.com" &

st -e tmux new -A -s persistent &
emacsclient -c --alternate-editor "" &
redshift &
start-pulseaudio-x11 &

if [[ -x "$HOME/load_mails.sh" ]]; then
  $HOME/load_mails.sh &
fi

if [[ -x "./autostart.local.sh" ]]; then
  ./autostart.local.sh
fi

while true; do
   xsetroot -name "$( date +'%a %F %R' )"
   sleep 60
done &
