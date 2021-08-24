#!/usr/bin/env bash

BINARY="grep"
if [ "$(uname)" == "Darwin" ]; then
  which ggrep > /dev/null
  if [[ $? == 1 ]]; then
    echo "This tool requires ggrep on MacOS. Run 'brew install grep'"
    exit 1
  fi
  BINARY="ggrep"
fi

OUTPUT=$($BINARY -Plr "(\s|{)(?!include\.)page\.\w+" app/_includes);

if [[ $? == 0 ]]; then
  echo "Page variables must not be used in includes."
  echo "Pass them in via include_cached instead"
  echo ""
  echo "Files that currently use page.*:"

  for f in $OUTPUT; do
    FILENAME=$(basename $f)
    CALLERS=$(fgrep -Elr "{% include.*$FILENAME" app);
    echo "File: $f"
    echo "via:"
    echo "$CALLERS"
    echo "=========="
  done

  exit 1
fi
