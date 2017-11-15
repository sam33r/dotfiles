#!/bin/bash

selection=$(awk '/^function [0-9]_/{s = ""; for (i = 4; i <= NF; i++) s = s $i " "; printf("%s\n",substr($2, 1, length($2) - 2))}' ~/projects.local.sh $0 | sort | rofi -i -sort -fuzzy -dmenu -p "PROJECT: ")

if [ -z "$selection" ]
then
  exit 0
fi

. ~/projects.local.sh

function reset() {
  killall -s TERM chrome &
  sleep 0.2
  killall -s TERM chrome &
  killall -s TERM gnome-terminal &
  killall -s TERM emacsclient &
  killall -s TERM nautilus &
  killall -s TERM nemo &
  i3-msg workspace number 0
  i3-msg workspace number 1
  (screen -ls | grep Detached | cut -d. -f1 | awk '{print $1}' | xargs kill) &
  sleep 0.2
  i3-msg layout splith
}

function 0_clean() {
  notify-send "All clear." -t 1000
}

function 1_agenda() {
  emacsclient -c -e "(sa/agenda)"
}

function 1_journal() {
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

function 8_dotfiles() {
  emacsclient -c "~/dotfiles"
}

function 8_browser() {
  notify-send "Starting chrome..." -t 1000
  google-chrome &
  sleep 2
  i3-msg move scratchpad
  google-chrome &
}

function 8_edit_projects() {
  emacsclient -c "~/dotfiles/utils/projects.sh"
}

function 8_edit_local_projects() {
  emacsclient -c "~/projects.local.sh"
}

function 8_mail() {
  emacsclient -c &
  sleep 1
  xdotool type " aM"
  sleep 0.5
  xdotool type "U"
}

function 8_gmail() {
  google-chrome "gmail.com" &
  sleep 5
  xdotool key F11
}

function 9_timepass() {
  i3-msg workspace number 8
  google-chrome https://instapaper.com &
  google-chrome https://read.amazon.com &
  google-chrome --app-id=bikioccmkafdpakkkcpdbppfkghcmihk
}

reset
reset_local
sleep 0.2
"$selection"
