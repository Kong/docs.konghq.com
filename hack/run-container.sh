#!/bin/bash -x
docker rm --force docs 2>&1 1>/dev/null
docker run -d --rm --pull=never -p 3000:3000 -v $(pwd):/site --name docs ghcr.io/kong/docs:latest
docker exec -it docs bash