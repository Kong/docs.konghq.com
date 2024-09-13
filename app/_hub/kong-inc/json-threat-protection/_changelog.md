## Changelog

### {{site.base_gateway}} 3.8.0.0

* Introduced the new **JSON Threat Protection** plugin.

**Known issues**:
*  In the [JSON Threat Protection plugin](/hub/kong-inc/json-threat-protection/configuration/), the default value of `-1`
for any of the `max_*` parameters indicates unlimited.
In some environments (such as ARM64-based environments), the default value is interpreted incorrectly.
The plugin can erroneously block valid requests if any of the parameters continue with the default values.
To mitigate this issue, configure the JSON Threat Protection plugin with limits for all of the `max_*` parameters.
