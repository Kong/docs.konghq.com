## Changelog

### {{site.base_gateway}} 3.10.0.0
* Fixed an issue where the SSE body could have extra trailing characters.

### {{site.base_gateway}} 3.9.0.0
* Added the `ignore_tool` configuration option to discard tool role prompts from the input text.
* This plugin can now be enabled on consumer groups.
* Made the `embeddings.model.name` config field a free text entry, enabling use of a self-hosted (or otherwise compatible) model.
* Fixed an issue where the plugin couldn't use the request-provided models.
* Fixed the exact matching to catch everything, including embeddings.
* Fixed an issue where the AI Semantic Cache plugin would abort in stream mode when another plugin enabled the buffering proxy mode.
* Fixed an issue where the AI Semantic Cache plugin put the wrong type value in the metrics when using the Prometheus plugin.
* Fixed an issue where the plugin failed when handling requests with multiple models.


### {{site.base_gateway}} 3.8.0.0

* Introduced the new **AI Semantic Caching** plugin.