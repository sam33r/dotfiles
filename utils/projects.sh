#!/bin/bash

selection=$(awk '/^function /{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%s\n",substr($2, 1, length($2) - 2))}' $0 ~/projects.local.sh | rofi -fuzzy -dmenu)

if [ -z "$selection" ]
then
  exit 0
fi

. ~/projects.local.sh



echo "selection is $selection"

function dotfiles() {
  emacsclient -c "~/dotfiles"
}

function browser() {
  notify-send "Starting chrome..."
  google-chrome &
}

function edit_projects() {
  emacsclient -c "~/dotfiles/utils/projects.sh"
}

function edit_local_projects() {
  emacsclient -c "~/projects.local.sh"
}

function mail() {
  emacsclient -c &
  sleep 1
  xdotool type " aM"
}

function gmail() {
  google-chrome "gmail.com" &
  sleep 5
  xdotool key F11
}

function timepass() {
  i3-msg workspace 8
  google-chrome https://instapaper.com &
  google-chrome https://read.amazon.com &
  google-chrome --app-id=bikioccmkafdpakkkcpdbppfkghcmihk
}

function reset() {
  killall -s TERM chrome &
  killall -s TERM gnome-terminal &
  killall -s TERM emacsclient &
  killall -s TERM nautilus &
  i3-msg workspace 1 &
  sleep 0.2
  i3-msg layout splith &
}

reset
sleep 0.5
"$selection"
