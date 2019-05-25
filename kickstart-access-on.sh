#!/bin/bash

# author: Jon Christensen, date: 2018-07-18, macOS: 10.13.6, GitHub / Jamf Nation: jychri 

# summary: closes System Preferences, enables remote access for $users

# --- set value(s) here --- #

users=""

if [ "$4" != "" ] && [ "$users" == "" ]; then
	users=$4
fi

# --- do not edit below --- #

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"

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
$kickstart -restart -agent
$kickstart -activate -configure -allowAccessFor -specifiedUsers
$kickstart -configure -access -on -privs -all -users "$user"
