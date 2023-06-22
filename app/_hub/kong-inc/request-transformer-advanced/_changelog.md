## Changelog

**{{site.base_gateway}} 3.3.x**
- The plugin now honors the value configured for the global parameter: [untrusted_lua](/gateway/latest/reference/configuration/#untrusted_lua)
  when [Advanced templates](#advanced-templates) are configured.

**{{site.base_gateway}} 3.1.x**
- Added support for navigating nested JSON objects and arrays when transforming a JSON payload.

**{{site.base_gateway}} 3.0.x**
- Removed the deprecated `whitelist` parameter.
It is no longer supported.

**{{site.base_gateway}} 2.1.x**

- Use `allow` instead of `whitelist`.
