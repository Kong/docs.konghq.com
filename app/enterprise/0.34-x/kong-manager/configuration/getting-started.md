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
allowing you to point to [your own configuration](https://docs.konghq.com/0.13.x/configuration/#configuration-loading)

Once started, navigate to Kong Manager in the browser at `http://localhost:8002`

## Migration from 0.33

If upgrading Kong Enterprise from version 0.33, read the 
[0.34 Upgrade Guide](/enterprise/{{page.kong_version}}/deployment-guide/#upgrading-to-034), 
as well as the upgrade notes for a list of new features in the 
[Changelog](/enterprise/changelog). 

## Configuration for Kong Manager

Kong Manager is configurable through the `kong.conf` file. For specific configuration options, refer to the properties described in the [Kong configuration reference](/0.13.x/configuration) and [Kong Enterprise configuration reference](/enterprise/{{page.kong_version}}/property-reference).

Next: [Authentication &rsaquo;]({{page.book.next}})
