#!/bin/bash

# author: Jon Christensen, date: 2019-04-17, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# --- do not edit below --- #

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
systemsetup="/usr/sbin/systemsetup"

# function verifyClosed() {
#   if pgrep -f "$1"; then
#     echo "verifyClosed: Closing $1"; killall "$1"
#   fi
# }

# --- main! --- #

verifyClosed "System Preferences"
$systemsetup -f -setremotelogin off
$kickstart -deactivate -configure -access -off
$kickstart -restart -agent
