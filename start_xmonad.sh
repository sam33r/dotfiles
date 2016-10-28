#!/bin/bash

# Point "Exec=" line in /usr/share/xsessions/xmonad.desktop
# to this file.
volti &                   # Volume control
redshift-gtk &            # redshift

# compton composition manager.
# Another option is 
xcompmgr -c &
# compton --backend glx &

# Set wallpaper
feh --bg-scale ~/Wallpapers/021\ -\ 7sHZDxH.jpg

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
