## Changelog

### {{site.base_gateway}} 3.10.0.0
* Added support for allowing multiple rate limits for the same providers. This means `window_size` and `limit` now require an array of numbers instead of a single number. If you configured the plugin before 3.10 and use `kong migrations` to upgrade to 3.10, it will be automatically migrated to use the array.

### {{site.base_gateway}} 3.9.0.0
* Added support for the Hugging Face provider to the AI Rate Limiting Advanced plugin.
  To import the decK configuration files that are exported from earlier versions, use the following script to transform it so that the configuration file can be compatible with the latest version:

  ```
  yq -i '(
  .plugins[] | select(.name == "ai-rate-limiting-advanced") | .config.llm_providers[] | select(.name == "huggingface") | .name
  ) |= "requestPrompt" |
  (
  .consumers[] | .plugins[] | select(.name == "ai-rate-limiting-advanced") | .config.llm_providers[] | select(.name == "huggingface") | .name
  ) |= "requestPrompt" |
  (
  .consumer_groups[] | .plugins[] | select(.name == "ai-rate-limiting-advanced") | .config.llm_providers[] | select(.name == "huggingface") | .name
  ) |= "requestPrompt"
  ' config.yaml
  ```

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