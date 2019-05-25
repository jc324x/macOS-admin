#!/bin/bash

# author: Jon Christensen, date: 2019-04-17, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: closes System Preferences, disables remote access

# --- do not edit below --- #

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"
systemsetup="/usr/sbin/systemsetup"

function verifyClosed() {

  if [ -z "$1" ]; then
    echo "verifyClosed => [return] no argument passed"; return
  fi

  local target; target="$1"
  check=$(/usr/bin/pgrep -f "$target")

  if [ "$check" == "" ]; then
    echo "verifyClosed => [return] '$target' is not running"; return
  fi

  echo "verifyClosed: closing '$target'"

  /usr/bin/killall "$target"

  check=$(/usr/bin/pgrep -f "$target")

  if [ "$check" == "" ]; then
    echo "verifyClosed: closed '$target'"
  else
    echo "verifyClosed => [exit 1] can't close $target'"; exit 1
  fi
}


# --- main! --- #

verifyClosed "System Preferences"
$systemsetup -f -setremotelogin off
$kickstart -deactivate -configure -access -off
$kickstart -restart -agent
