#!/bin/bash

# Point "Exec=" line in /usr/share/xsessions/xmonad.desktop
# to this file.
volti &                   # Volume control
redshift-gtk &            # redshift

# compton composition manager.
# Another option is 
# xcompmgr -cfF -t-9 -l-11 -r0 -o.95 -D7 &
# Compton config is at ~/.config/compton.conf
compton --backend glx &

# Set random wallpaper
feh --bg-scale ~/Wallpapers/`ls ~/Wallpapers | shuf -n 1`

# tray app
trayer --align right --widthtype request --height 18 --transparent true \
  --alpha 1 --tint 0x000000 --edge top --expand true --distance 490 \
  --distancefrom right &

# Key mappings.
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Escape = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Escape"
xmodmap -e "add Lock = Caps_Lock"

exec xmonad
