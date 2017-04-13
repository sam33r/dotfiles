#!/bin/bash
# Script to lock the screen and turn off the display.
# This is called on idle timeout from i3config.

scrot /tmp/screen_locked.png
convert /tmp/screen_locked.png -scale 10% -scale 1000% /tmp/screen_locked2.png
rm -f /tmp/screen_locked.png
i3lock -i /tmp/screen_locked2.png

sleep 30; pgrep i3lock && xset dpms force off
