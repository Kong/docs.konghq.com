## Changelog

### {{site.base_gateway}} 3.9.0.0
* Fixed an issue where Azure Managed Identity did not work for the AI Transformer plugins.

### {{site.base_gateway}} 3.8.0.0
* Fixed an issue where Cloud Identity authentication was not used in `ai-request-transformer` and `ai-response-transformer` plugins.
* Fixed an issue where the plugin couldn't be applied per consumer or per service.
  [#13209](https://github.com/Kong/kong/issues/13209)
  
### {{site.base_gateway}} 3.6.0.0

* Introduced the new **AI Response Transformer** plugin.