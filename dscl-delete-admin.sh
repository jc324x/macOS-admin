#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: removes $current_user from the admin group

# --- do not edit below --- #

current_user=$(stat -f "%Su" /dev/console)
dscl_delete="/usr/bin/dscl . -delete /groups/admin GroupMembership"

# --- main! --- #

echo "main: deleting $current_user from /groups/admin"
$dscl_delete "$current_user"
