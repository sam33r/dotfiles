#!/bin/bash

# Utility script that uses rofi, surfraw and google chrome to issue search
# queries.
surfraw -browser=google-chrome $(sr -elvi | awk -F'-' '{print $1}' | \
  sed '/:/d' | awk '{$1=$1};1' | rofi \
  -kb-row-select "Tab" \
  -kb-row-down "Down,Control+j" \
  -kb-row-tab "Control+space" \
  -dmenu -i -p "Search: ")
