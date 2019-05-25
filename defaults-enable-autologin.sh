#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: edits the $login_window plist, enables autologin for $user
# note: TODO put a note here about how it needs a 'kpass' file

# --- set value(s) here --- #

user=""

if [ "$4" != "" ] && [ "$user" == "" ]; then
	user=$4
fi

# --- do not edit below --- #

defaults="/usr/bin/defaults write"
login_window="/Library/Preferences/com.apple.loginwindow.plist"
pbuddy="/usr/libexec/PlistBuddy -c"

# --- main! --- #

echo "main: writing '$login_window' autoLoginUser '$user'"
$defaults "$login_window" autoLoginUser "$user"

echo "main: checking :autoLoginUser '$login_window'"
check=$($pbuddy "print :autoLoginUser" "$login_window")

if [ "$check" == "$user" ]; then
  echo "main: wrote '$login_window' autoLoginUser '$user'"
else 
  echo "main => [exit1] '$check' != '$user'"; exit 1
fi
