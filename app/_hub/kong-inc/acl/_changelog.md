## Changelog

### {{site.base_gateway}} 3.6.x
* This plugin now includes the configuration parameter `include_consumer_groups`, which lets you specify whether
  Kong consumer groups can be added to allow and deny lists.

### {{site.base_gateway}} 3.0.x
- Removed the deprecated `whitelist` and `blacklist` parameters.
They are no longer supported.

### {{site.base_gateway}} 2.1.x
- Use `allow` and `deny` instead of `whitelist` and `blacklist`
