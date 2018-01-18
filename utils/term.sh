#!/bin/bash
killall gnome-terminal
gnome-terminal -e "tmux new -A -s 'persistent'"
