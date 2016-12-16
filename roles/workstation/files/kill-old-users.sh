#!/bin/sh

# Seconds before we kill the user.  2700 seconds = 45 minutes
KILLSECONDS=2700

export DISPLAY=":0.0"
PERSON=$(who | grep ":0" | cut -d" " -f 1)
LOCKEDTIME=0

if pgrep -u "$PERSON" cinnamon-screen ; then #we check for the shotened name as that's what pgrep returns
    echo "Using Cinnamon-Screensaver"
    LOCKEDTIME=$(sudo -u "$PERSON" cinnamon-screensaver-command --time | grep -Eo '[0-9]{1,4}')
elif pgrep -u "$PERSON" xscreensaver ; then
    echo "Using XScreenSaver"
    XSCREENTIME=$(sudo -u "$PERSON" xscreensaver-command --time | grep locked | sed "s/^.*since //; s/(.*$//")
    if [ -z "$XSCREENTIME" ] ; then
        echo "XScreenSaver is not currently locked!"
        exit
    fi
    NOW="$(date '+%s')"
    XSCREENDATE="$(date -d "$XSCREENTIME" +%s)"
    LOCKEDTIME="$((NOW - XSCREENDATE))"
    echo "XScreenTime: $XSCREENTIME"
    echo "Now: $NOW"
    echo "XScreenDate: $XSCREENDATE"
fi
echo "LockedTime: $LOCKEDTIME"

if [ "$LOCKEDTIME" -ge "$KILLSECONDS" ]; then
    pkill -KILL -u "$PERSON"
fi
