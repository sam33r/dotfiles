#!/bin/bash

# Utility script to select a URL from Chrome history (via rofi), and then open
# a new Chrome window with that URL.

mkdir -p ~/tmp

localdb="$HOME/tmp/History"

if [ ! -e "$localdb" ] || [ ! -z "`find $localdb -mtime +30s`" ] ; then
  cp -f  ~/.config/google-chrome/Default/History ~/tmp/
fi

title_url=`( cat ~/.bookmarks ; sqlite3 ~/tmp/History "select title,url from urls order by last_visit_time desc limit 5000") | rofi -dmenu -i`

if [ -z "$title_url" ] ; then
  exit 0
fi

url=`echo $title_url | cut -f2 -d'|'`
google-chrome $url
