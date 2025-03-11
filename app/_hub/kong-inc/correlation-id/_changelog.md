## Changelog

### {{site.base_gateway}} 3.9.x
* Increased the priority order of the plugin to from 1 to 100001 so that the plugin can be used with other plugins, especially custom auth plugins. 
[#13581](https://github.com/Kong/kong/issues/13581)

### {{site.base_gateway}} 2.2.x
* Fixed an issue where the plugin would not work if you explicitly set the `generator` to `null`.
   [#13439](https://github.com/Kong/kong/issues/13439)

### {{site.base_gateway}} 2.2.x
* The plugin now generates a `correlation-id` value by default if the correlation ID header arrives empty.
