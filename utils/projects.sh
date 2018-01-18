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
  (ps -A | grep gnome-terminal | cut -d" " -f2 | awk '{print $1}' | xargs kill) &
  killall -s TERM emacsclient &
  killall -s TERM nautilus &
  killall -s TERM nemo &
  i3-msg workspace number 0
  i3-msg workspace number 1
  sleep 0.2
  gnome-terminal -e 'tmux new -A -s "persistent"' &
  sleep 0.3
  i3-msg move scratchpad
  google-chrome &
  sleep 2
  i3-msg move scratchpad
  sleep 0.2
  i3-msg layout splith
  sleep 1
}

function 0_clean() {
  notify-send "All clear." -t 1000
}

function 1_agenda() {
  emacsclient -c -e "(sa/agenda)" &
  sleep 1
  xdotool type "r"
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
  emacsclient -c &
  sleep 1
  xdotool type " pp"
  xdotool key Return
  sleep 1
  xdotool type "dotfiles/"
  sleep 0.5
  xdotool key Return
}

function 8_browser() {
  notify-send "Starting chrome..." -t 1000
  google-chrome &
}

function 8_edit_projects() {
  emacsclient -c "~/dotfiles/utils/projects.sh"
}

function 8_edit_local_projects() {
  emacsclient -c "~/projects.local.sh"
}

function 7_mail() {
  i3-msg layout tabbed
  emacsclient -c &
  sleep 1
  xdotool type " aM"
  sleep 0.5
  xdotool type "U"
}

function 8_travel() {
  start=$(zenity --entry --text="Starting Location: " --entry-text="SFO"  | sed "s/ /+/g")
  dest=$(zenity --entry --text="Destination: " | sed "s/ /+/g")
  duration=$(zenity --entry --text="Dates: " | sed "s/ /+/g")
  i3-msg layout tabbed
  google-chrome https://www.kayak.com/sherlock/opensearch/search/?q=rental+cars+in+$dest+$duration &
  google-chrome https://www.google.com/search?q=hotels+in+$dest+$duration &
  google-chrome https://www.google.com/flights?q=flights+from+$start+to+$dest+$duration &
  google-chrome https://www.google.com/search?q=airbnb+$dest+$duration &
  google-chrome https://www.google.com/search?q=things+to+do+in+$dest &
  google-chrome https://www.google.com/search?q=monthly+weather+forecast+$dest &
  google-chrome https://www.google.com/search?q=$dest+neighborhoods &
  google-chrome https://www.google.com/maps/search/$dest &
}

function 8_gmail() {
  google-chrome "gmail.com" &
  sleep 5
  xdotool key F11
}

function 9_content_triage() {
  google-chrome &
  sleep 2
  xdotool type "chrome://extensions/?id=njkbjdmigienhoeccpigopgjmlgmdine"
  xdotool key Return
  sleep 2
  xdotool key space
  sleep 1
  google-chrome https://www.amazon.com/mn/dcw/myx.html/ref=kinw_myk_surl_1#/home/content/pdocs/dateDsc/ &
  google-chrome https://instapaper.com &
  google-chrome https://hckrnews.com &
  google-chrome https://lobste.rs &
  google-chrome https://www.reddit.com/me/m/tech_obsessions/top/?sort=top&t=week &
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
