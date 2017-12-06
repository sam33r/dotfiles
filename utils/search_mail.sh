#!/bin/bash
# Ugly little script to search email in an emacs window
query=$(zenity --entry --text="Enter search string:")
emacsclient -c -e "(mu4e)" &
sleep 1
i3-msg fullscreen
sleep 0.3
xdotool type s
sleep 0.2
xdotool type "$query"
sleep 0.1
xdotool key Return
