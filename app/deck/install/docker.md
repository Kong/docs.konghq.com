---
title: decK in Docker
---

decK is provided as a Docker image for those that do not want to install decK locally.

To run decK using a Docker image, add the following alias to your shell:

```bash
alias deck='docker run --rm -v .:/files -w /files kong/deck'
```

As decK will run in a Docker container, you'll need to provide the `--kong-addr` parameter when running commands such as `deck sync`. To sync with a {{ site.base_gateway }} that is running on the host machine, use `host.docker.internal`:

```bash
deck gateway sync --kong-addr http://host.docker.internal:8001 my_deck_file.yaml
```

## Set a default kong-addr

If the `kong-addr` you use is fixed, you can set the `DECK_KONG_ADDR` variable in your alias and omit it from each command:

```bash
alias deck='docker run --rm -v .:/files -w /files -e DECK_KONG_ADDR=http://host.docker.internal:8001 kong/deck'
deck gateway sync  my_deck_file.yaml
```
