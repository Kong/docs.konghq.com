## Changelog

### {{site.base_gateway}} 3.8.0.0
* Added the Redis `cluster_max_redirections` configuration option.
* Added stats for reaching the limit and exiting the AI Rate Limiting plugin.
* Add the cost strategy to the AI Rate Limiting plugin.
* Added the `bedrock` and `gemini` providers to the supported providers list.
* Edited the logic for the window adjustment and fixed missing passing window to shared memory.

### {{site.base_gateway}} 3.7.0.0

* Introduced the new **AI Rate Limiting Advanced** plugin.