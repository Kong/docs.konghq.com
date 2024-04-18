---
title: Kong Gateway Environment Variables
content-type: how-to
---

## Environment variables

{{site.base_gateway}} can be fully configured with environment variables. 

[All parameters defined in `kong.conf`](/gateway/{{page.release}}/reference/configuration/) 
can be managed via environment variables.
When loading properties from `kong.conf`, {{site.base_gateway}} checks existing
environment variables first.

To override a setting using an environment variable, declare an environment
variable with the name of the setting, prefixed with `KONG_`.

For example, to override the `log_level` parameter:

```
log_level = debug # in kong.conf
```

set `KONG_LOG_LEVEL` as an environment variable:

```bash
export KONG_LOG_LEVEL=error
```

## More information

* [How to use `kong.conf`](/gateway/{{page.release}}/production/kong-conf/)
* [How to serve an API and a website with Kong](/gateway/{{page.release}}/production/website-api-serving/)
* [Configuration parameter reference](/gateway/{{page.release}}/reference/configuration/)
