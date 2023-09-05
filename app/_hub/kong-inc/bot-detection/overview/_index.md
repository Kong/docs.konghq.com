---
nav_title: Overview
---

Use the Bot Detection plugin to protect a service or a route from the most common bots, 
and set up allow and deny lists for custom clients.

## Default rules

{% if_plugin_version lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.
{% endif_plugin_version %}

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object
