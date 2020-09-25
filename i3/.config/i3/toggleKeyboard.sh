#!/bin/bash

# Toggle between us and no keyboard layout.

L="$(setxkbmap -query | awk '/layout/{print $2}')"
no="no"

if [ $L = $no ]; then
  setxkbmap -layout us; pkill -x --signal=SIGUSR1 i3status
else
  setxkbmap -layout no; pkill -x --signal=SIGUSR1 i3status
fi
