---
title: Getting Started with Kong Manager
book: admin_gui
chapter: 2
---

## Start Kong

To start Kong:

```bash
$ kong start [-c /path/to/kong.conf]
```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/enterprise/{{page.kong_version}}/property-reference/#configuration-loading)

Once started, navigate to Kong Manager in the browser at `http://localhost:8002`

## Migration from 0.33

If upgrading Kong Enterprise from version 0.33, read the 
[0.34 Upgrade Guide](/enterprise/{{page.kong_version}}/deployment-guide/#upgrading-to-034), 
as well as the upgrade notes for a list of new features in the 
[Changelog](/gateway/changelog/#034). 

## Configuration for Kong Manager

Kong Manager is configurable through the `kong.conf` file. For specific configuration options, refer to the properties described in the [Kong Enterprise configuration reference](/enterprise/{{page.kong_version}}/property-reference).

⚠️**Important:**
Kong Manager does not support entity-level RBAC. Run Kong Manager on a node
where `enforce_rbac` is set to `on` or `off`, but not `entity` or `both`.

Next: [Authentication &rsaquo;]({{page.book.next}})
