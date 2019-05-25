#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: deletes the firmware $password

# --- set value(s) here --- #

password=""

if [ "$4" != "" ] && [ "$password" == "" ]; then
	password=$4
fi

# --- do not edit below | main! --- #

check=$(/usr/sbin/firmwarepasswd -check)

if [[ "$check" != *"Enabled: Yes"* ]]; then
  echo "main => [exit 0] no firmware password set"; exit 0
fi

if [[ "$check" == *"Enabled: Yes"* ]]; then
  echo "main: deleting firmware password"

output=$(/usr/bin/expect<<EOF
  spawn firmwarepasswd -delete
  expect {
  "Enter password:" {
          send "$password\\r"
          exp_continue
      }
  }
EOF
)

fi

if [[ "$output" == *"password removed"* ]]; then
  echo "main: deleted firmware password"
fi

if [[ "$output" == *"password incorrect"* ]]; then
  echo "main => [exit1] password incorrect, firmware password unchanged"
fi
