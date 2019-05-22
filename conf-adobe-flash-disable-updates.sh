#!/bin/bash

# author: Jon Christensen, date: 2019-05-01, macOS: 10.14.4, GitHub / Jamf Nation: jychri 

# summary: disables auto update for Flash, updates are managed by the JSS.

# --- do not edit below --- #

macromedia="/Library/Application Support/Macromedia"
mms="$macromedia/mms.cfg"

function rmFile() {

  if [ -z "$1" ]; then
    echo "rmFile => [return] no argument passed"; return
  fi

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


# --- main! --- #

if [ ! -d "$macromedia" ]; then
  echo "main: creating '$macromedia' directory"
  /bin/mkdir "$macromedia"
fi

echo "main: verifying permissions for '$macromedia'"
/bin/chmod 775 "$mms"
/usr/sbin/chown root:admin "$macromedia"

rmFile "$mms"

echo "main: writing to '$mms'"
/bin/cat <<EOF > "$mms"
AutoUpdateDisable=1
EOF

echo "main: setting permissions for '$mms'"
/bin/chmod 644 "$mms"
/usr/sbin/chown root:admin "$mms"
