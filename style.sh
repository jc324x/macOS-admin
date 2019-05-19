#!/bin/bash

# --- jss variables --- #

# indexed from 4

value=""

if [ "$4" != "" ] && [ "$value" == "" ]; then
	value=$4
fi

# --- function(s) --- #

function copyLog() {
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

# exit early if application is open
function exitIfOpen() {
  local target; target="$1"
  local check; check=$(pgrep -f "$target")

  if [ "$check" != "" ]; then
    echo "exitIfOpen => [exit 1] $target is open."; exit 1
  fi
}

# remove an application from /Applications
function rmApplication() {
  local application; application="$1"
  local path_to_application; path_to_application="/Applications/$application.app"

  if [ ! -d "$path_to_application" ]; then
    echo "rmApplication => [return] nothing at $path_to_application"; return
  fi

  echo "rmApplication: removing '$application' at '$path_to_application'"

  /bin/rm -rf "$path_to_application"

  if [ ! -d "$path_to_application" ]; then
    echo "rmApplication: removed '$1' from '$path_to_application'"
  else
    echo "rmApplication => [exit 1] '$path_to_application' shouldn't exist"; exit 1
  fi
}

# remove a file
function rmFile() {
  local path_to_file; path_to_file="$1"

  if [ ! -e "$path_to_file" ]; then
    echo "rmFile => [return] nothing at $path_to_file"; return
  fi

  if [ -d "$path_to_file" ]; then
    echo "rmFile => [return] expected file, found directory"; return
  fi

  echo "rmFile: removing '$path_to_file'"

	/bin/rm "$path_to_file"

  if [ ! -e "$path_to_file" ]; then
    echo "rmFile: removed '$path_to_file'"
  else
    echo "rmFile => [exit 1] '$path_to_file' shouldn't exist"; exit 1
  fi
}

# remove a directory
function rmDir() {
  local path_to_dir; path_to_dir="$1"

  if [ ! -d "$path_to_dir" ]; then
    echo "rmDir => [return] nothing at '$path_to_dir'"; return
  fi

  echo "rmDir: removing '$path_to_dir'"
	/bin/rm -rf "$path_to_dir"

  if [ ! -d "$path_to_dir" ]; then
    echo "rmDir: removed '$path_to_dir'"
  else
    echo "rmDir => [exit 1] '$path_to_dir' shouldn't exist"
  fi
}

# toggle load/unload with launchctl
function toggleLaunchctl() {
  local target; target="$1"

  check=$(/bin/launchctl list | grep "$target")
  if [ "$check" != "" ]; then
    /bin/launchctl unload "$target"
  fi
    /bin/launchctl load "$target" 
}

# verify that an application is closed
function verifyClosed() {
  # rewrite to exit early
  local target; target="$1"

  if /usr/bin/pgrep -f "$target"; then
    echo "verifyClosed: closing '$target'"
    killall "$target"
  else
    echo "verifyClosed => [return] '$target' is not running"
  fi

  # confirm closed here
}

# verify org directories and their ownership/permissions
function verifyOrgDirs() {
  local org; org=$1

  org_scripts="/usr/local/$org/scripts"
  org_logs="/usr/local/$org/logs"
  org_private="/usr/local/$org/private"

  if [ ! -d "$org_scripts" ]; then
    echo "verifyOrgDirs: Creating '$org_scripts'"; mkdir -p "$org_scripts"
  fi

  if [ ! -d "$org_logs" ]; then
    echo "verifyOrgDirs: Creating '$org_logs'"; mkdir -p "$org_logs"
  fi

  if [ ! -d "$org_private" ]; then
    echo "verifyOrgDirs: Creating '$org_private'"; mkdir -p "$org_private"
  fi

  echo "verifyOrgDirs: Verifying permissions and ownership"
  /usr/sbin/chown root:wheel "/usr/local/$org"
  /bin/chmod 0444 "/usr/local/$org"
}

# --- command variables --- #

computer_name=$(scutil --get ComputerName)

current_user=$(stat -f "%Su" /dev/console)

scutil_dns=$(scutil --dns)

external_ip=$(dig +short myip.opendns.com @resolver1.opendns.com)

internal_ip=$(ipconfig getifaddr en0)

now=$(date +"%D %T")

serial_number=$(system_profiler SPHardwareDataType | grep 'Serial Number (system)' | awk '{print $NF}')

wifi_mac=$(ifconfig en0 | awk '/ether/{print $2}')

wireless_device=$(/usr/sbin/networksetup -listallhardwareports | /usr/bin/grep -E -A2 'Airport|Wi-Fi' | /usr/bin/awk '/Device/ { print $2 }')

# --- testing functions --- #

function echo_out_variables() {
  echo "computer name: $computer_name"
  echo "current user: $current_user"
  echo "scutil dns: $scutil_dns" 
  echo "external IP: $external_ip" 
  echo "internal IP: $internal_ip" 
  echo "now: $now" 
  echo "serial number: $serial_number" 
  echo "wifi MAC: $wifi_mac" 
  echo "wireless device: $wireless_device" 
}

# --- tests --- #

echo -e "testing options (run with sudo)"
echo -e "enter 1 to echo variables"

read -r user_input
case "$user_input" in

1)
  echo_out_variables
;;

esac
