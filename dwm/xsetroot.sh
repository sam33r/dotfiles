DATETIME=`date +'%a %F %R'`
UPTIME=`uptime | sed 's/.*up\s*//' | sed 's/,\s*[0-9]* user.*//' | sed 's/ / /g'`
VOLUME=`$HOME/dotfiles/i3blocks/volume`
BATTERYSTATE=$( acpi -b | awk '{ split($5,a,":"); print substr($3,0,2), $4, "["a[1]":"a[2]"]" }' | tr -d ',' )
MEMORY=`$HOME/dotfiles/i3blocks/memory | head -2 | tail -1`
CPU=`$HOME/dotfiles/i3blocks/cpu_usage | head -2 | tail -1`
TMP=`$HOME/dotfiles/i3blocks/temperature | head -2 | tail -1`

ORGCLOCK=""
if [ -f /tmp/org-clock-flag ]; then
  ORGCLOCK=`emacsclient -e "(sa/task-clocked-time)"`
fi

# If we are currently clocking an org item, print that item instead of system stats.
if [ ! -z "$ORGCLOCK" ]; then
  xsetroot -name " ${ORGCLOCK} | ${DATETIME}"
else
  xsetroot -name " ${BATTERYSTATE} | CPU $CPU | MEM $MEMORY | VOL ${VOLUME} | TEMP ${TMP} | Up ${UPTIME}h | ${DATETIME}"
fi
