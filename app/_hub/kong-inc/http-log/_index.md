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


{% if_plugin_version gte:2.3.x %}

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

{% endif_plugin_version %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}


{% if_plugin_version gte:2.4.x %}

## Custom Fields by Lua

{% include /md/plugins-hub/log_custom_fields_by_lua.md %}

{% endif_plugin_version %}

{% if_plugin_version gte:2.8.x %}

## Logged headers allow list

Some usecases may require that only a set of allowed request and response headers are included in the logs. 
This can be to reduce overall log enty size, avoid garbage header values from the end user from being logged, or to avoid non-standard sensitive header values from being logged unredacted.

The HTTP Log plugin can be configured to enforce an allow list of header names, such that only request or response headers who's name matches an allowed value will be included in the logs.

To enable this functionality, configure the plugin with: 

```yaml
...
  - name: http-log
    config:
      enable_logged_header_allow_list: true
...
```

To set the header names in the allow list, configure the logged_header_allow_list array. By default, the allow list contains a number of standard request and response headers. For more info, view the configuration reference.

{% endif_plugin_version %}
