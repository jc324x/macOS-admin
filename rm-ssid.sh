#!/bin/bash

# author: Jon Christensen, date: 2019-05-02, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

ssid=""

if [ "$4" != "" ] && [ "$ssid" == "" ]; then
  ssid=$4
fi

# --- do not edit below --- #

networksetup="/usr/sbin/networksetup"
list_all="networksetup -listallhardwareports"
wireless_device=$($list_all | /usr/bin/grep -E -A2 'Airport|Wi-Fi' | /usr/bin/awk '/Device/ { print $2 }')

# function verifyClosed() {
#   if pgrep -f "$1"; then
#     echo "verifyClosed: Closing $1"; killall "$1"
#   fi
# }

# --- main! --- #

if [ "$ssid" == "" ]; then
  echo "main [exit]; ssid=''"; exit
fi

verifyClosed "System Preferences"
$networksetup -removepreferredwirelessnetwork "$wireless_device" "$ssid"
