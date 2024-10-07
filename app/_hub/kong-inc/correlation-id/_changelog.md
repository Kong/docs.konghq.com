## Changelog

### {{site.base_gateway}} 2.2.x
* Fixed an issue where the plugin would not work if you explicitly set the `generator` to `null`.
   [#13439](https://github.com/Kong/kong/issues/13439)

### {{site.base_gateway}} 2.2.x
* The plugin now generates a `correlation-id` value by default if the correlation ID header arrives empty.
