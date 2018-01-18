#!/bin/bash
killall gnome-terminal
gnome-terminal -e "tmux new -A -s 'persistent'" &
sleep 0.2
i3-msg '[class="Gnome-terminal"] scratchpad show'
