---
title: Kong Configuration Environment Variables
content-type: how-to
---

## Environment variables

Kong can be fully configured with environment variables. When loading properties from `kong.conf`, Kong will check existing
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