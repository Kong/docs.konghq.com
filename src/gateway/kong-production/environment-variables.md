---
title: Kong Gateway Environment Variables
content-type: how-to
---

## Environment variables

{{site.base_gateway}} can be fully configured with environment variables. When loading properties from `kong.conf`, {{site.base_gateway}} will check existing
environment variables. 

To override a setting using an environment variable, declare an environment
variable with the name of the setting, prefixed with `KONG_`.

To override the `log_level` parameter:

```
log_level = debug # in kong.conf
```

set `KONG_LOG_LEVEL` as an environment variable:

```bash
export KONG_LOG_LEVEL=error
```


## More Information

* [Embedding Kong in OpenResty](/gateway/latest/kong-production/kong-openresty)
* [How to use `kong.conf`](/gateway/latest/kong-production/kong-conf)
* [How to serve an API and a website with Kong](/gateway/latest/kong-production/website-api-serving)