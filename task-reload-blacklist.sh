#!/bin/bash

# author: Jon Christensen, date: 2018-10-12, macOS: 10.14, GitHub / Jamf Nation: jychri 

# --- do not edit below --- #

jamf="/usr/local/bin/jamf"

# function rmFile() {
#   if [ ! -e "$1" ]; then
#     echo "rmFile => [return] No file at $1, nothing to remove"; return
#   fi

#   if [ -d "$1" ]; then
#     echo "rmFile => [return] Expected file, found directory"; return
#   fi

#   echo "rmFile: Removing '$1'"

# 	/bin/rm "$1"

#   if [ ! -e "$1" ]; then
#     echo "rmFile: Removed '$1'"
#   fi
# }


# --- main! --- #

rmFile "/Library/Application Support/JAMF/.blacklist.xml"
# TODO: confirm use of manage w/ Jamf Support
"$jamf" manage
