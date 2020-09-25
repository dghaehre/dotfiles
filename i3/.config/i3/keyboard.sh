#!/bin/bash

# Script to show current keyboard layout in i3status bar

i3status | while :
do
  read line

  IFS=', ' read -r -a LAYOUT <<< $(setxkbmap -query | awk '/layout/{print $2}')
  lastidx=$( expr ${#LAYOUT[@]} - 1 )
  res="[{ \"full_text\": \"\", \"separator\":false, \"separator_block_width\": 6 }"
  for index in "${!LAYOUT[@]}"
  do
    i="${LAYOUT[index]}"
    c=", \"color\":\"#7FFFD4\""

    if [[ $index -eq $lastidx ]]; then
      e=""
    else
      e=", \"separator\":false, \"separator_block_width\": 6 "
    fi
    res="$res,{ \"full_text\": \"$i\"$c$e}"
  done
  echo "${line/[/$res,}" || exit 1
done
