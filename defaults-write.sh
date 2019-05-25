#!/bin/bash

# author: Jon Christensen, date: 2019-05-25, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

plist=""

if [ "$4" != "" ] && [ "$plist" == "" ]; then
	plist=$4
fi

key=""

if [ "$5" != "" ] && [ "$key" == "" ]; then
	key=$5
fi

value=""

if [ "$6" != "" ] && [ "$value" == "" ]; then
	value=$6
fi

# --- do not edit below --- #

function defaultsWrite() {
  if [ -z "$1" ]; then
    echo "plistWrite => [exit 1] no plist argument passed"; exit 1
  fi

  if [ -z "$2" ]; then
    echo "plistWrite => [exit 1] no key argument passed"; exit 1
  fi

  if [ -z "$3" ]; then
    echo "plistWrite => [exit 1] no value argument passed"; exit 1
  fi

  local plist; plist="$1"
  local key; key="$2"
  local value; value="$3"

  echo "plistWrite: checking the initial value for '$key' in '$plist'"

  local defaults; defaults="/usr/bin/defaults"
  local pbuddy; pbuddy="/usr/libexec/PlistBuddy"

  local init_value; init_value=$($pbuddy -c print ":$key" "$plist")
  echo "plistWrite: initial value is '$init_value' for '$key' in '$plist'"; 

  echo "plistWrite: writing value '$value' for '$key' in '$plist'"; 
  $defaults write "$plist" "$key" "$value"

  local final_value; final_value=$($pbuddy -c print ":$key" "$plist")

  if [ "$value" == "$final_value" ]; then
    echo "plistWrite: confirmed '$value' for '$key' in '$plist'"; exit 1
  else
    echo "plistWrite => [exit 1] '$value' != '$final_value'"; exit 1
  fi
}

# --- main! --- #

defaultsWrite "$plist" "$key" "$value"
