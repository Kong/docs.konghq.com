#!/bin/bash -x
docker run -d --rm -p 3000:3000 -v $(pwd):/site --name docs ghcr.io/kong/docs:latest
