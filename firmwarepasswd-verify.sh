#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: verifies the firmware password

# --- set value(s) here --- #

password=""

if [ "$4" != "" ] && [ "$password" == "" ]; then
	password=$4
fi

# --- do not edit below | main! --- #

check=$(/usr/sbin/firmwarepasswd -check)

if [ -z "$password" ]; then
  echo "main => [exit1] password cannot be ''"; exit 1
fi

if [[ "$check" != *"Enabled: Yes"* ]]; then
  echo "main => [exit1] no firmware password set"; exit 1
fi

if [[ "$check" == *"Enabled: Yes"* ]]; then
  echo "main: verifying firmware password"

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

fi

if [[ "$output" == *"Correct"* ]]; then
  echo "main: verified firmware password"
else
  echo "main => [exit 1] incorrect firmware password"; exit 1
fi
