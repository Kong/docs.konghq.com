---
nav_title: Overview
---

HTTP Log plugin lets you send request and response logs to an HTTP server.

{% if_plugin_version gte:3.3.x %}
## Queueing

The HTTP Log plugin uses internal queues to decouple the production of
log entries from their transmission to the upstream log server.  In
contrast to other plugins that use queues, it shares one queue
between all plugin instances that use the same log server parameter.
The equivalence of the log server is determined by the parameters
`http_endpoint`, `method`, `content_type`, `timeout`, and `keepalive`.
All plugin instances that have the same values for these parameters
share one queue.
{% endif_plugin_version %}

## Custom Headers

The log server that receives these messages might require extra headers, such as for authorization purposes.

```yaml
...
  - name: http-log
    config:
      headers:
        Authorization: "Bearer <token>"
...
```

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}
