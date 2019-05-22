#!/bin/bash

# author: Jon Christensen, date: 2018-10-18, macOS: 10.14, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

apps=(
  Keynote
  Numbers
  Pages
)

# --- do not edit below --- #

# exit early if application is open
# function exitIfOpen() {
#   local check; check=$(pgrep -f "$1")
#   if [ "$check" != "" ]; then
#     echo "exitIfOpen [exit1] $1 is open."; exit 1
#   fi
# }

# function rmApp() {
#   local path_to_application; path_to_application="/Applications/$1.app"

#   if [ ! -d "$path_to_application" ]; then
#     echo "rmApplication => [return] No app at $path_to_application, nothing to remove"
#     return
#   fi

#   echo "rmApplication: Removing '$1' at '$path_to_application'"

#   /bin/rm -rf "$path_to_application"

#   if [ ! -d "$path_to_application" ]; then
#     echo "rmApplication: Removed '$1' from '$path_to_application'"
#   fi
# }

# --- main! --- #

# comment or uncomment as needed

# quit if any target applications are running 
for app in "${apps[@]}"; do
  exitIfOpen "$app"
done

# close if any of the target applications are running


# remove target application
for app in "${apps[@]}"; do
  rmApp "$app"
done
