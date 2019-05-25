#!/bin/bash

# author: Jon Christensen, date: 2018-07-17, macOS: 10.13.6, GitHub / Jamf Nation: jychri 

# summary: sets the firmware $password

# --- set value(s) here --- #

password=""

if [ "$4" != "" ] && [ "$password" == "" ]; then
	password=$4
fi

# --- do not edit below | main! --- #

check=$(firmwarepasswd -check)

if [[ "$check" == *"Enabled: Yes"* ]]; then

output=$(/usr/bin/expect<<EOF
  spawn firmwarepasswd -verify
  expect {
  "Enter password:" {
          send "$password\\r"
          exp_continue
      }
  }
EOF
)

elif [[ "$check" == *"Enabled: No"* ]]; then

output=$(/usr/bin/expect<<EOF
  spawn firmwarepasswd -setpasswd
  expect {
  "Enter new password:" {
          send "$password\\r"
          exp_continue
      }
  "Re-enter new password:" {
          send "$password\\r"
          exp_continue
      }
  }
EOF
)

fi

if [[ "$output" == *"Correct"* ]]; then
  exit 0
elif [[ "$output" == *"Password changed"* ]]; then
  exit 0
elif [[ "$output" == *"Incorrect"* ]]; then
  exit 1
else
  exit 1
fi
