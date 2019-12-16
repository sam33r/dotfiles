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
run_keybase &
xbindkeys -f ~/.xbindkeysrc
~/dotfiles/utils/chrome-to-copyq ~/.config/google-chrome/Default/History &
~/dotfiles/utils/chrome-to-copyq ~/.config/google-chrome-beta/Default/History &

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

(sleep 60 && ~/grasp/server/grasp_server.py --path "~/notes/browser-inbox.org")

# Open the screen unlock dialogs
(sleep 60 && ~/dotfiles/utils/screen-unlock) &
