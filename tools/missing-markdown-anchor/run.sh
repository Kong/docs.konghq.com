#!/usr/bin/env bash

FILES=$(grep -lrE " \[.*\]\[.*\] " dist | grep -v vite)
for i in $FILES; do 
  ANCHOR=$(perl -ne 'print "$1\n" if / \[.*\]\[(.*)\]/' $i)
  echo "$i: ${ANCHOR#dist/#}"
done

if [[ ! -z "$FILES" ]]; then
  echo ""
  echo "ERROR: Detected broken markdown references";
  echo ""
  exit 1
fi