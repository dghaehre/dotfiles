#!/bin/bash

from="$(echo 'NO
EN' | dmenu -i -b -nb '#2f343f' -sb '#2f343f' -p 'From')"

if [ ! -z "$from" ]; then
  title="$(echo | dmenu -i -b -nb '#2f343f' -sb '#2f343f' -p 'Translate')"

  if [ ! -z "$title" ]; then

    if [ "NO" == "$from" ]; then
      echo $(trans no:en "$title" -b) | dmenu -i -b -nb '#2f343f' -sb '#2f343f' -p "Copy" | xsel -b
    else
      echo $(trans en:no "$title" -b) | dmenu -i -b -nb '#2f343f' -sb '#2f343f' -p "Copy" | xsel -b
    fi
  fi
fi
