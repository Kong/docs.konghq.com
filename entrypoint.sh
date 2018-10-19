#!/bin/bash

cd /srv/jekyll \
`$@`

function cleanup {
	echo "removing directories owned by root"
	make clean
}
trap cleanup EXIT