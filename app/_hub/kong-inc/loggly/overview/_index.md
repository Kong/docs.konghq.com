---
nav_title: Overview
---

Log request and response data over UDP to [Loggly](https://www.loggly.com).

## Log format

Every request is logged to the System log in [SYSLOG](https://en.wikipedia.org/wiki/Syslog) standard, with the
with `message` component formatted as described below.

**Note:** Make sure the Syslog daemon is running on the instance and it's configured with the
logging level severity the same as or lower than the set `config.log_level` for this plugin.

{% include /md/plugins-hub/log-format.md %}

### Log format definitions 

{% include /md/plugins-hub/json-object-log.md %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
