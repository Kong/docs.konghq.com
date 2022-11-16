---
title: Run decK with Docker
content_type: how-to
---

If you used the `kong/deck` Docker image to install decK, you can use the Docker image to manage decK. 

## Prerequisites
decK must be installed using a [Docker image](/deck/latest/installation/#docker-image).

## Export the configuration
Run this command to export the `kong.yaml` file:

```bash
docker run -i \
-v $(pwd):/deck \
kong/deck --kong-addr http://KONG_ADMIN_HOST:KONG_ADMIN_PORT --headers kong-admin-token:KONG_ADMIN_TOKEN -o /deck/kong.yaml dump
```
Where `$(pwd)/kong.yaml` is the path to a `kong.yaml` file.

## Export objects from all workspaces
Run this command to export objects from all the workspaces:

```bash
docker run -i \
-v $(pwd):/deck \
--workdir /deck \
kong/deck --kong-addr http://KONG_ADMIN_HOST:KONG_ADMIN_PORT:8001 --headers kong-admin-token:KONG_ADMIN_TOKEN dump --all-workspaces
```

## Reset the configuration
Run this command to initialize Kong objects:

```bash
docker run -i \
-v $(pwd):/deck \
kong/deck --kong-addr http://KONG_ADMIN_HOST:KONG_ADMIN_PORT:8001 --headers kong-admin-token:KONG_ADMIN_TOKEN reset
```

## Import the configuration
Run this command to import `kong.yaml`:

```bash
docker run -i \
-v $(pwd):/deck \
kong/deck --kong-addr http://KONG_ADMIN_HOST:KONG_ADMIN_PORT:8001 --headers kong-admin-token:KONG_ADMIN_TOKEN -s /deck/kong.yaml sync
```
In this example, `kong.yaml` is in `$(pwd)/kong.yaml`.

## View help manual pages
Run this command to view all available commands:

```bash
docker run kong/deck --help
```

Run the following to check available command flags:

```bash
docker run kong/deck dump --help
docker run kong/deck sync --help
docker run kong/deck reset --help
```