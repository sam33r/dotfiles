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
# pasystray &
# Start feh for wallpaper.
feh --randomize --bg-fill ~/Wallpapers/* &
unclutter &
copyq &
xbindkeys -f ~/.xbindkeysrc

start-pulseaudio-x11 &

if [[ -e "$HOME/.Xmodmap" ]]; then
  xmodmap "$HOME/.Xmodmap"
fi

if [[ -x "$HOME/load_mails.sh" ]]; then
  $HOME/load_mails.sh &
fi

if [[ -x "./autostart.local.sh" ]]; then
  ./autostart.local.sh
fi

# Status bar
while true; do
  battery=`acpi -b | cut -f 2- -d ":"`
  thermal=`acpi -t | cut -f 2- -d ":"`
  xsetroot -name "$battery | $thermal | $( date +'%a %F %R' )"
  sleep 60
done &
