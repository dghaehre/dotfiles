#!/usr/bin/env sh

# Add a blocing subtask
task "$@" stop
PROJECT=$(task _get "$@".project)
SCHEDULED=$(task _get "$@".scheduled)
DUE=$(task _get "$@".due)
TAGS=$(task _get "$@".tags | format-tags)

echo "Creating new blocking task for: $(task _get "$@".description)"
echo "New task:"
read DESCRIPTION

task add $DESCRIPTION pro:$PROJECT sch:$SCHEDULED due:$DUE $TAGS
LATEST=$(task +LATEST ids)

task "$@" modify dep:"$LATEST"
