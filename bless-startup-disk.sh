#!/bin/bash

# author: Jon Christensen, date: 2018-02-05, macOS: 10.13.3 

# summary: blesses and confirms the boot disk

# --- set value(s) here --- #

drive_name="Macintosh HD"

if [ "$4" != "" ] && [ "$drive_name" == "" ]; then
	drive_name=$4
fi

# --- do not edit below --- #

bless="/usr/sbin/bless -mount"

# --- main! --- #

echo "main: blessing $drive_name"
"$bless" "$drive_name" -setBoot 
# TODO: confirm?
