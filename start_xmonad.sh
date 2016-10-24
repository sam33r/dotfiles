#!/bin/bash

# Point "Exec=" line in /usr/share/xsessions/xmonad.desktop
# to this file.
stalonetray &             # System tray
volti &                   # Volume control

# Key mappings.
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Escape = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Escape"
xmodmap -e "add Lock = Caps_Lock"

exec xmonad
