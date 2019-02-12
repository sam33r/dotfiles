#!/bin/bash

cd $HOME
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
pasystray &
# Start feh for wallpaper.
feh --randomize --bg-fill ~/Wallpapers/* &
unclutter &
copyq &
redshift-gtk &
xbindkeys -f ~/.xbindkeysrc

start-pulseaudio-x11 &

if [[ -e "$HOME/.Xmodmap" ]]; then
  xmodmap "$HOME/.Xmodmap"
fi

if [[ -x "$HOME/.dwm/autostart.local.sh" ]]; then
  $HOME/.dwm/autostart.local.sh
fi

# Status bar
while true; do
  sh $HOME/.dwm/xsetroot.sh
  sleep 30
done &
