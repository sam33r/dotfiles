#!/bin/bash
# Ugly little script for quick-adding org tasks.
task=$(zenity --entry --text="Enter task title:")
emacsclient -c -e '(org-capture)' &
sleep 0.5
i3-msg floating enable
sleep 0.5
xdotool type t && xdotool key Return
sleep 0.5
xdotool type ' wm'
sleep 0.3
xdotool type "a$task"
