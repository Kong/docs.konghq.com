---
title: Show differences in configuration (`deck gateway diff`)
---

The `deck gateway diff` command shows the differences between your live {{ site.base_gateway }} configuration and the state file provided.

`deck gateway diff` is typically used to preview upcoming changes, or to detect unexpected changes in the live system.

## Dry run

`deck gateway diff` should always be run before running [sync](/deck/gateway/sync/) to preview upcoming changes. decK resolves all changes as though it's performing a sync, and outputs the changes that would have been made at the end:

```bash
$ deck gateway sync /path/to/kong.yaml
updating service example-service  {
   "connect_timeout": 60000,
   "enabled": true,
-  "host": "httpbin.konghq.com",
+  "host": "httpbin.org",
   "id": "c828da95-d684-42d3-8047-43d90552f6e2",
   "name": "example-service",
   "port": 80,
   "protocol": "http",
   "read_timeout": 60000,
   "retries": 5,
   "write_timeout": 60000
 }

Summary:
  Created: 0
  Updated: 1
  Deleted: 0
```

If you see changes in the diff that you didn't expect, edit your state file until it matches your expectations and run `deck gateway diff` again before running `deck gateway sync`.

## Drift detection

You can run `deck gateway diff` periodically with a known state file to detect any unexpected changes in the live system.

If your running {{ site.base_gateway }} matches your expected state, you will see the following output:

```bash
Summary:
  Created: 0
  Updated: 0
  Deleted: 0
```

If the live system has changed without a corresponding change to the state file, `deck gateway diff` will highlight the change and it can be reverted by running `deck gateway sync`.