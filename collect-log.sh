#!/bin/bash

# author: Jon Christensen, date: 2019-05-20, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

log_file="/usr/local/jychri/hello_world"

if [ "$4" != "" ] && [ "$log_file" == "" ]; then
	log_file=$4
fi

# --- do not edit below --- #

function copyLogToDesktop() {

  if [ -z "$1" ]; then
    echo "copyLogToDesktop => [exit 1] no argument passed"; exit 1
  fi

  local log_file; log_file="$1"

  if [ ! -e "$log_file" ]; then
    echo "copyLogToDesktop => [exit 1] no file at $log_file"; exit 1
  fi

  local basename; basename=$(/usr/bin/basename "$log_file")

  if [ -z "$basename" ]; then
    echo "copyLogToDesktop => [exit 1] no valid basename"; exit 1
  fi

  local current_user; current_user=$(stat -f "%Su" /dev/console)
  local desktop_file; desktop_file="/Users/$current_user/Desktop/$basename"

  echo "copyLogToDesktop: copying '$log_file' to '$desktop_file'"
  /bin/cp "$log_file" "$desktop_file"

  if [ ! -e "$desktop_file" ]; then
    echo "copyLogToDesktop => [exit 1] copy failed, no copy at '$desktop_file'"; exit 1
  fi

  /usr/sbin/chown "$current_user" "$desktop_file"
  chmod 644 "$desktop_file"

  check_owner=$(stat -f "%Su" "$desktop_file")

  if [ "$check_owner" != "$current_user" ]; then
    echo "copyLogToDesktop [exit 1] '$desktop_file' owner == $check_owner"
  fi

  check_permission=$(stat -f "%A %a" "$desktop_file" | cut -d' ' -f1)

  if [ "$check_permission" != 644 ]; then
    echo "copyLogToDesktop [exit 1] '$desktop_file' permission == $check_permission"
  fi

  if [ -e "$desktop_file" ]; then
    echo "copyLogToDesktop: copied '$log_file' to '$desktop_file'"
  fi
}

# --- main! --- #

copyLogToDesktop "$log_file"
