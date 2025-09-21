#!/bin/bash

KEYBOARD_MAC="DF:17:DC:EB:01:16"

/usr/bin/bluetoothctl info $KEYBOARD_MAC >/dev/null 2>&1

while true; do
    STATE=$(/usr/bin/bluetoothctl info $KEYBOARD_MAC | grep "Connected: yes")
    if [ -z "$STATE" ]; then
        echo "$(date): $KEYBOARD_MAC not connected, retrying..."
        echo -e "connect $KEYBOARD_MAC\n" | /usr/bin/bluetoothctl
    fi
    sleep 10
done
