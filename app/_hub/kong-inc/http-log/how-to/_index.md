## Log format

{:.note}
> **Note:** If the `queue_size` argument > 1, a request is logged as an array of JSON objects.

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

---

