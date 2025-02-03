---
title: Namespace
---

When practicing [federated configuration management](/deck/apiops/federated-configuration/), there is a high chance of endpoint collision where two teams unexpectedly use the same API path.

To avoid this, you can namespace each API using a path prefix or have each API listen on a specific host.

By default the `deck file namespace` command operates on all routes in a file. To target specific routes, pass the `--selector` flag.

## Path prefix

The simplest way to prevent colissions is to prefix each API's routes with a static path. In this case, all routes in `/path/to/config` will be exposed under a `/billing` path:

```bash
deck file namespace --path-prefix=/billing -s /path/to/config.yaml
```

To remain transparent to the backend services, the added path prefix must be removed from the path before the request is routed to the service. To remove the prefix, the following approaches are used (in order):

1. If the route has `strip_path=true`, then the added prefix will already be stripped.
1. If the related service has a `path` property that matches the prefix, then the `service.path` property is updated to remove the prefix.
1. A `pre-function` plugin will be added to remove the prefix from the path.

## Custom host

An alternate way to namespace APIs is to have each API listen on a different hostname e.g. `http://service1.api.example.com/somepath`, `http://service2.api.example.com/somepath`.

The following command updates all route definitions in a file to listen only when a request is made to `service1.api.example.com`. If the route already has a `hosts` entry, the new domain is appended to the list.

```bash
deck file namespace --host service1.api.example.com
```

If you need to ensure that the API only listens on the hostname provided, you can pass the `--clear-hosts` flag:

```bash
deck file namespace --host service1.api.example.com --clear-hosts
```