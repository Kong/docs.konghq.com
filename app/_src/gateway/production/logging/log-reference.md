---
title: Logging Reference
content_type: reference
---

## Log Levels

Log levels are set in [Kong's configuration](/gateway/{{page.release}}/reference/configuration/#log_level). Following are the log levels in increasing order of their severity: `debug`, `info`,
`notice`, `warn`, `error` and `crit`.

- *`debug`:* It provides debug information about the plugin's run loop and each individual plugin or other components. This should only be used during debugging, the `debug` option, if left on for extended periods of time, can result in excess disk space consumption.
- *`info`/`notice`:* Kong does not make a big difference between both these levels. Provides information about normal behavior most of which can be ignored.
- *`warn`:* To log any abnormal behavior that doesn't result in dropped transactions but requires further investigation, `warn` level should be used.
- *`error`:* Used for logging errors that result in a request being dropped (for example getting  an HTTP 500 error). The rate of such logs need to be monitored.
- *`crit`:* This level is used when Kong is working under critical conditions and not working properly thereby affecting several clients. Nginx also provides `alert` and `emerg` levels but currently Kong doesn't make use of these levels making `crit` the highest severity log level.

`notice` is the default and recommended log level. However if the logs turn out to be too chatty, they can be bumped up to a higher level like `warn`.


## More Information

* [Remove elements from {{site.base_gateway}} logs](/gateway/{{page.release}}/production/logging/customize-gateway-logs/)
{% if_version gte:3.1.x -%}
* [Dynamic log level updates](/gateway/{{page.release}}/production/logging/update-log-level-dynamically/)
{% endif_version %}
