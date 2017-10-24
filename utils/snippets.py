#!/usr/bin/env python
# A hacky script to do dynamic snippets.

import sys
import os
import datetime

snippet_map = {
    'date' : datetime.datetime.now().strftime('%b %d %G %I:%M%p '),
    'time' : datetime.datetime.now().strftime('%I:%M%p '),
}

keys = '\n'.join(snippet_map.keys())
result = os.popen('printf "%s" | rofi -dmenu ' % keys)

selected_key = result.read().strip()
os.system('xdotool type --clearmodifiers -- "%s"' % str(snippet_map[selected_key]))
