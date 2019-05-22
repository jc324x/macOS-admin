#!/bin/bash

# author: Jon Christensen, date: 2018-07-18, macOS: 10.13.6, GitHub / Jamf Nation: jychri 

# --- set value(s) here --- #

# TODO: write a function that separates line is bash to array from comma sep

user=""

if [ "$4" != "" ] && [ "$user" == "" ]; then
	user=$4
fi

# --- do not edit below --- #

kickstart="/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart"

# --- main! --- #

$kickstart -restart -agent
$kickstart -activate -configure -allowAccessFor -specifiedUsers
$kickstart -configure -access -on -privs -all -users "$user"
