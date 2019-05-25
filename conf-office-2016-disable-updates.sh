#!/bin/bash

# author: Jon Christensen, date: 2018-01-17, macOS: 10.13.2 

# summary: deletes the $MAU2 directory, stops automatic updates for Microsoft Office

# --- do not edit below --- #

function rmDir() {
  if [ ! -d "$1" ]; then
    echo "rmDir => [return] No directory at '$1', nothing to remove"; return
  fi

  echo "rmDir: Removing '$1'"
	
	/bin/rm -rf "$1"

  if [ ! -d "$1" ]; then
    echo "rmDir: Removed '$1'"
  fi
}

MAU2="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"

# --- main! --- #

rmDir "$MAU2"
