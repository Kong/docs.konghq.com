## Changelog

### {{site.base_gateway}} 3.9.0.0
* Added support for the Huggingface provider to the AI Rate Limiting Advanced plugin.
* Updated the error message for exceeding the rate limit to include AI-related information.
* Fixed an issue where the plugin yielded an error when incrementing the rate limit counters in non-yieldable phases.
* Fixed an issue where the plugin could fail to authenticate to Redis correctly with vault-referenced Redis configuration.

### {{site.base_gateway}} 3.8.0.0
* Added the Redis `cluster_max_redirections` configuration option.
* Added stats for reaching the limit and exiting the AI Rate Limiting plugin.
* Add the cost strategy to the AI Rate Limiting plugin.
* Added the `bedrock` and `gemini` providers to the supported providers list.
* Edited the logic for the window adjustment and fixed missing passing window to shared memory.

### {{site.base_gateway}} 3.7.0.0

* Introduced the new **AI Rate Limiting Advanced** plugin.