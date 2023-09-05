---
nav_title: Overview
---

HTTP Log plugin lets you send request and response logs to an HTTP server.

{% if_version gte:3.3.x %}
## Queueing

The HTTP Log plugin uses internal queues to decouple the production of
log entries from their transmission to the upstream log server.  In
contrast to other plugins that use queues, it shares one queue
between all plugin instances that use the same log server parameter.
The equivalence of the log server is determined by the parameters
`http_endpoint`, `method`, `content_type`, `timeout`, and `keepalive`.
All plugin instances that have the same values for these parameters
share one queue.
{% endif_version %}


## Log format

{% if_version lte:3.2.x %}
{:.note}
> **Note:** If the `queue_size` argument > 1, a request is logged as an array of JSON objects.
{% endif_version %}
{% if_version gte:3.3.x %}
{:.note}
> **Note:** If the `max_batch_size` argument > 1, a request is logged as an array of JSON objects.
{% endif_version %}

{% include /md/plugins-hub/log-format.md %}

### JSON object considerations

{% include /md/plugins-hub/json-object-log.md %}


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
