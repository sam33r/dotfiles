#!/bin/bash

selection=$(awk '/^function [0-9]_/{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%s\n",substr($2, 1, length($2) - 2))}' ~/projects.local.sh $0 | sort | rofi -i -sort -fuzzy -dmenu -p "PROJECT: ")

if [ -z "$selection" ]
then
  exit 0
fi

. ~/projects.local.sh

function agenda() {
  emacsclient -c -e "(sa/agenda)"
}

function journal() {
  emacsclient -c -e "(org-capture)" &
  sleep 1
  xdotool type "j"
  sleep 0.5
  xdotool key "Escape"
  xdotool type " wm"
  sleep 0.5
  xdotool type "a"
  sleep 0.1
  i3-msg fullscreen
}

function dotfiles() {
  emacsclient -c "~/dotfiles"
}

function browser() {
  notify-send "Starting chrome..."
  google-chrome &
  sleep 2
  i3-msg move scratchpad
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
  sleep 0.5
  xdotool type "U"
}

function gmail() {
  google-chrome "gmail.com" &
  sleep 5
  xdotool key F11
}

function timepass() {
  i3-msg workspace number 8
  google-chrome https://instapaper.com &
  google-chrome https://read.amazon.com &
  google-chrome --app-id=bikioccmkafdpakkkcpdbppfkghcmihk
}

function reset() {
  killall -s TERM chrome &
  sleep 0.2
  killall -s TERM chrome &
  killall -s TERM gnome-terminal &
  killall -s TERM emacsclient &
  killall -s TERM nautilus &
  i3-msg workspace number 0
  i3-msg workspace number 1
  (screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill) &
  sleep 0.2
  i3-msg layout splith
}

reset
sleep 0.2
"$selection"
