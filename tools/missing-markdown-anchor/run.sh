#!/usr/bin/env bash

set -euxo pipefail

FILES=$(grep -lrE " \[.*\]\[.*\] " dist | grep -v vite) || true

if [[ ! -z "$FILES" ]]; then
  for i in $FILES; do
    ANCHOR=$(perl -ne 'print "$1\n" if / \[.*\]\[(.*)\]/' $i)
    echo "$i: ${ANCHOR#dist/#}"
  done

  echo ""
  echo "ERROR: Detected broken markdown references";
  echo ""
  exit 1
fi