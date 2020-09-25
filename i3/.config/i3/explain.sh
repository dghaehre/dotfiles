#!/bin/bash

title="$(echo | dmenu -i -b -nb '#2f343f' -sb '#2f343f' -p 'Explain')"

if [ ! -z "$title" ]; then
  xfce4-terminal -T "explanation" -e "trans $title -v --no-ansi"
  i3-msg "move scratchpad"
  i3-msg "[class=\"^Xfce4\\-terminal$\" title=\"explanation\" ] scratchpad show"
fi
