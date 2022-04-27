#!/bin/bash -x
docker buildx build --pull \
    --platform linux/amd64 \
    --tag ghcr.io/kong/docs:latest \
    --file ./container/Containerfile \
    --load ./container
