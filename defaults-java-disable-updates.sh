#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: disables auto update for Java, updates are managed by the JSS.

# --- do not edit below --- #

defaults="/usr/bin/defaults write"
pbuddy="/usr/libexec/PlistBuddy -c"
java_updater_plist="/Library/Preferences/com.oracle.java.Java-Updater.plist"

# --- main! --- #

echo "main: Writing '$java_updater_plist' JavaAutoUpdateEnabled -bool false"
$defaults "$java_updater_plist" JavaAutoUpdateEnabled -bool false

echo "main: Checking :JavaAutoUpdateEnabled '$java_updater_plist'"
check=$($pbuddy "Print :JavaAutoUpdateEnabled" "$java_updater_plist")

if [ "$check" == "false" ]; then
  echo "main: Write confirmed '$check' == 'false'"
else 
  echo "main => [exit1] '$check' != 'false'"; exit 1
fi
