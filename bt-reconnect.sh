#!/bin/bash
# ---------------------------------------------------------
#  Bluetooth Auto-Reconnect Script
#  Author: Vaibhav Oza
#  GitHub: https://github.com/vaibhavoza
#  Created: 2025
#  Description:
#    - Monitors Bluetooth connection of Pebble Keys 2 K380
#    - Auto-reconnects if the keyboard disconnects
#    - Designed for RHEL 10 (but works on most Linux distros)
# ---------------------------------------------------------

KEYBOARD_MAC="XX:XX:XX:XX:XX:XX" #Update MAC as per your bluetooth device

/usr/bin/bluetoothctl info $KEYBOARD_MAC >/dev/null 2>&1

while true; do
    STATE=$(/usr/bin/bluetoothctl info $KEYBOARD_MAC | grep "Connected: yes")
    if [ -z "$STATE" ]; then
        echo "$(date): $KEYBOARD_MAC not connected, retrying..."
        echo -e "connect $KEYBOARD_MAC\n" | /usr/bin/bluetoothctl
    fi
    sleep 10
done
