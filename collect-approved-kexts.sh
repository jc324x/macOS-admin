#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

org="jychri"

if [ "$4" != "" ] && [ "$org" == "" ]; then
  org=$4
fi

# --- do not edit below --- #

sqlite3="/usr/bin/sqlite3"
policy_config="/var/db/SystemPolicyConfiguration/KextPolicy"
kext_policy_log="/usr/local/$org/logs/kext_policy"

function verifyOrgDirs() {

  if [ -z "$1" ]; then
    echo "verifyClosed => [return] no argument passed"; return
  fi

  local org; org="$1"

  org_scripts="/usr/local/$org/scripts"
  org_logs="/usr/local/$org/logs"
  org_private="/usr/local/$org/private"

  if [ ! -d "$org_scripts" ]; then
    echo "verifyOrgDirs: creating '$org_scripts'"; mkdir -p "$org_scripts"
  fi

  if [ ! -d "$org_logs" ]; then
    echo "verifyOrgDirs: creating '$org_logs'"; mkdir -p "$org_logs"
  fi

  if [ ! -d "$org_private" ]; then
    echo "verifyOrgDirs: creating '$org_private'"; mkdir -p "$org_private"
  fi

  echo "verifyOrgDirs: verifying permissions and ownership for '/usr/local/$org'"
  /usr/sbin/chown root:wheel "/usr/local/$org"
  /bin/chmod 0444 "/usr/local/$org"

  check_owner=$(stat -f "%Su" "/usr/local/$org/")

  if [ "$check_owner" != "root" ]; then
    echo "verifyOrgDirs [exit 1] '/usr/local/$org' owner == $check_owner"
  fi

  check_permission=$(stat -f "%A %a" "/usr/local/$org" | cut -d' ' -f1)

  if [ "$check_permission" != 444 ]; then
    echo "verifyOrgDirs [exit 1] '/usr/local/$org' permission == $check_permission"
  fi

  echo "verifyOrgDirs: verified permissions and ownership for '/usr/local/$org'"
}


function copyLog() {

  if [ -z "$1" ]; then
    echo "copyLog => [return] no argument passed"; return
  fi

  local log_file; log_file="$1"

  if [ -z "$log_file" ]; then
    echo "copyLog => [return] log_file = ''"; return
  fi

  if [ ! -e "$log_file" ]; then
    echo "copyLog => [return] no file at $log_file"; return
  fi

  local basename; basename=$(/usr/bin/basename "$log_file")

  if [ -z "$basename" ]; then
    echo "copyLog => [return] basename = ''"; return
  fi

  local current_user; current_user=$(stat -f "%Su" /dev/console)
  local desktop_file; desktop_file="/Users/$current_user/Desktop/$basename"

  echo "copyLog: copying '$log_file' to '$desktop_file'"
  /bin/cp "$log_file" "$desktop_file"

  if [ ! -e "$desktop_file" ]; then
    echo "copyLog => [exit 1] copy failed, no copy at '$desktop_file'"; exit 1
  fi

  /usr/sbin/chown "$current_user" "$desktop_file"
  chmod 644 "$desktop_file"

  if [ -e "$desktop_file" ]; then
    echo "copyLog: copied '$log_file' to '$desktop_file'"
  fi
}

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

verifyOrgDirs "$org"
echo "main: reading '$policy_config', writing to '$kext_policy_log'"
"$sqlite3" -csv "$policy_config" "select team_id,bundle_id from kext_policy" >> "$kext_policy_log"
copyLogToDesktop "$kext_policy_log"
