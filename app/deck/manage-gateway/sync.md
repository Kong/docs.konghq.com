---
title: sync
---

The `deck gateway sync` command configures the target {{ site.base_gateway }} to match the values specified in your declarative configuration.

{:.important}
> Any configuration in {{ site.base_gateway }} that is not present in the provided declarative configuration file **will be deleted** using `deck gateway sync`.

The `deck gateway sync` command can accept one or more files as positional arguments:

```bash
# Sync a single file
deck gateway sync kong.yaml
```

In addition to positional arguments, `deck gateway sync` can read input from `stdin` for use in pipelines:

```bash
# Remove example-service from the file before syncing
cat kong.yaml | yq 'del(.services[] | select(.name == "example-service"))' | deck gateway sync
```

## Syncing multiple files

decK can construct a state by combining multiple JSON or YAML files inside a directory instead of a single file.

In most use cases, a single file will suffice, but you might want to use
multiple files if:

- You want to organize the files for each service. In this case, you
  can have one file per service, and keep the service, its associated routes, plugins, and other entities in that file.
- You have a large configuration file and want to break it down into smaller digestible chunks.


```bash
# Sync multiple files
deck gateway sync services.yaml consumers.yaml
```

```bash
# Sync a whole directory
deck gateway sync directory/*.yaml
```

Please note that having the state split across different files is not same
as [federated configuration](/deck/apiops/federated-configuration/).