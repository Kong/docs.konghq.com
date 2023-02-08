## Default rules

{% if_plugin_version gte:2.1.x and lte:2.8.x %}

{:.note}
> **Note**: We have deprecated the usage of `whitelist` and `blacklist` in favor of `allow` and `deny`. This change may require Admin API requests to be updated.

{% endif_plugin_version %}

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Kong/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object

---
