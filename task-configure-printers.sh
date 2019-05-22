#!/bin/bash

# author: Jon Christensen, date: 2018-09-12, macOS: 10.13.6, GitHub / Jamf Nation: jychri 

# --- do not edit below --- #

# TODO: capture response? check for '', set $1 to local n?

printers=($(lpstat -v | awk '{print $3}' | sed 's/://'))

function disable_sharing() {
  /usr/sbin/lpadmin -p "$1" -o printer-is-shared=false
}

function set_error_policy() {
  /usr/sbin/lpadmin -p "$1" -o printer-error-policy=abort-job
}

function enable_printer() {
  /usr/sbin/cupsenable "$1"
}

for printer in "${printers[@]}"; do
  disable_sharing "$printer"
  set_error_policy "$printer"
  enable_printer "$printer"
done
