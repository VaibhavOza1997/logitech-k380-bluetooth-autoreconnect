# 🔄 Logitech K380 / Pebble Keys 2 Bluetooth Auto-Reconnect

[![Shell Script](https://img.shields.io/badge/language-Bash-blue.svg)](https://www.gnu.org/software/bash/)
[![Systemd](https://img.shields.io/badge/init-systemd-green.svg)](https://systemd.io/)
[![Linux](https://img.shields.io/badge/platform-Linux-orange.svg)](https://kernel.org)
[![RHEL](https://img.shields.io/badge/OS-RHEL%2010-red.svg)](https://www.redhat.com/)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

A lightweight **systemd service + Bash script** that automatically reconnects a  
**Logitech Pebble Keys 2 K380** Bluetooth keyboard on Linux.  

✅ Tested on **RHEL 10**  
✅ Works on Fedora, Ubuntu, Arch, and other distros with systemd + BlueZ  
✅ Fixes the issue where the **K380 keeps disconnecting or going inactive**  

---

## ✨ Features
- Monitors Bluetooth connection every 10 seconds  
- Automatically reconnects if the keyboard disconnects  
- Runs in the background via `systemd`  
- Starts automatically on boot  
- Minimal resource usage  

---

## 📂 Files & Locations
To avoid permission or SELinux issues, use these paths:
- `bt-reconnect.sh` → `/usr/bin/bt-reconnect.sh`  
- `bt-reconnect.service` → `/etc/systemd/system/bt-reconnect.service`  

---

## 🛠️ Prerequisites
1. Linux with **systemd**  
2. Install **BlueZ** (Bluetooth stack):  
   ```bash
   # RHEL/Fedora
   sudo dnf install bluez bluez-tools

   # Debian/Ubuntu
   sudo apt install bluez


3. Find your keyboard’s MAC address:

       Command:
         bluetoothctl devices Paired
       Output Example
         Device XX:XX:XX:XX:XX:XX Pebble K380s

5. ⚡ Setup Instructions

a. Clone the repo:

    Command:
      git clone https://github.com/vaibhavoza/logitech-k380-bluetooth-autoreconnect.git
      cd logitech-k380-bluetooth-autoreconnect


b. Edit the script and set your MAC:
   
    Command:
      nano bt-reconnect.sh

c. Update this line:

    KEYBOARD_MAC="XX:XX:XX:XX:XX:XX"

d. Copy the script to /usr/bin:

    sudo cp bt-reconnect.sh /usr/bin/
    sudo chmod 755 /usr/bin/bt-reconnect.sh

e. Copy the service file to systemd:

    sudo cp bt-reconnect.service /etc/systemd/system/

f. Reload systemd and enable the service:

    sudo systemctl daemon-reload
    sudo systemctl enable --now bt-reconnect.service

g. Verify status:

    systemctl status bt-reconnect.service

6. 🔍 Testing & Logs

   Watch logs live:

       journalctl -u bt-reconnect.service -f

   Force a disconnect:

       bluetoothctl disconnect XX:XX:XX:XX:XX:XX


   Confirm it reconnects automatically:

       bluetoothctl info XX:XX:XX:XX:XX:XX | grep Connected

   Expected output:

       Connected: yes

7. 🛠️ Customization

   Change reconnect interval in bt-reconnect.sh:

       sleep 10   # check every 10 seconds


Extra:
Works with any Bluetooth device — just replace the MAC.

Supports multiple devices by extending the script:

DEVICES=("XX:XX:XX:XX:XX:XX" "YY:YY:YY:YY:YY:YY")
for DEV in "${DEVICES[@]}"; do
    STATE=$(/usr/bin/bluetoothctl info $DEV | grep "Connected: yes")
    if [ -z "$STATE" ]; then
        echo "$(date): $DEV not connected, retrying..."
        echo -e "connect $DEV\n" | /usr/bin/bluetoothctl
    fi
done
