#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: adds the current user to the admin group

# --- do not edit below --- #

current_user=$(stat -f "%Su" /dev/console)
dscl_append="/usr/bin/dscl . append /groups/admin GroupMembership"

# --- main! --- #

echo "main: Appending $current_user to /groups/admin"
$dscl_append "$current_user"
