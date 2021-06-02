#!/bin/sh
# Saves "article" to personal wiki.

set -e

url="$1"
title="$2"
description="$3"
feed_title="$4"

content="# ${title}\n${feed_title}\n\n${description}\n\n[link](${url})"
filename=$(echo "${title}" | awk '{gsub(/ /,"-")} {print $0}')
d=$(date +%s)

echo -e $content > ~/wikis/personal/Inbox/Bookmarks/${filename}.md
