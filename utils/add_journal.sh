#!/bin/bash
# Ugly little script for quick-adding org journal entry.
title=$(zenity --entry --text="Enter journal title:")
emacsclient -c -e '(org-capture)' &
sleep 0.5
i3-msg floating enable
sleep 0.2
i3-msg resize set 1000 1900
sleep 0.1
i3-msg move position center
sleep 0.1
xdotool type j && xdotool key Return
sleep 0.5
xdotool type ' wm'
sleep 0.3
xdotool type "a$title"
sleep 0.2
xdotool key Return
xdotool key Return
