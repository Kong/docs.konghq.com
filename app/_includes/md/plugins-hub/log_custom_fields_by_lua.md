The `custom_fields_by_lua` configuration allows for the dynamic modification of
log fields using Lua code. Below is an example configuration that removes the
existing `route` field in the logs:

```
curl -i -X POST --url http://kong:8001/plugins ... --data config.custom_fields_by_lua.route="return nil"
```

Similarly, new fields can be added:

```
curl -i -X POST --url http://kong:8001/plugins ... --data config.custom_fields_by_lua.header="return kong.request.get_header('h1')"
```

### Limitations

Lua code runs in a restricted sandbox environment, whose behavior is governed
by the `untrusted_lua` [configuration properties][configuration] configuration
properties.

{% include /md/plugins-hub/sandbox.md %}

Further, as code runs in the context of the log phase, only [PDK][pdk] methods
that can run in said phase can be used.

---

[configuration]: /gateway-oss/latest/configuration
[pdk]: /gateway-oss/latest/pdk
