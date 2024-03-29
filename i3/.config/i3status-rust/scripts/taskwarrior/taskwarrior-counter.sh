#!/bin/bash
todos=$(task status:pending or status:waiting count)
today=$(task status:completed end.after:today count)
ready=$(task +READY count)
done=$(task status:completed count)
context=$(task context show | awk -F "'" '{print $2}' | head -n 1)
echo "@$context    ☐ $ready ■ $today   ☐ $todos ■ $done"
