#!/bin/env bash

set -e

print_info() {
  echo "{\"icon\":\"headphones\", \"text\": \"$@\", \"state\": \"Info\"}"
}

print_depends() {
  echo "{\"icon\":\"ping\", \"text\": \"$@\", \"state\": \"Critical\"}"
}

MISSINGDUE=()

DEPENDS="$(task ids -COMPLETED -DELETED depends.any: due.any:)"
IFS=' ' read -ra depends <<< "$DEPENDS"

# Loop over all tasks that have one or more dependencies
for value in "${depends[@]}"; do
  DEPEND=$(task _get $value.depends)
  DUE=$(task _get $value.due)
  IFS=',' read -ra blocking <<< "$DEPEND"

  for block in "${blocking[@]}"; do
    # blocking_task="$(task $block information)"
    block_id="$(task _get $block.id)"

    # If id is 0 it is most likely completed or deleted.
    if [[ "$block_id" != "0" ]]; then

      block_due="$(task _get $block.due)"
      if [[ -z "$block_due" || $(date -d $DUE +%s) -lt $(date -d $block_due +%s) ]]; then
        MISSINGDUE+=("$block_id")
      fi
    fi
  done
done

if [[ ! -z $MISSINGDUE ]]; then
  print_depends "Fix due dates: ${MISSINGDUE[*]}"
else
  ACTIVE="$(task +ACTIVE ids)"
  if [[ ! -z $ACTIVE ]]; then
    print_info $(task _get $ACTIVE.description)
  else
    print_info
  fi
fi
