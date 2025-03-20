## Changelog

### {{site.base_gateway}} 3.10.x
* Changed the serialized log key of AI metrics from `ai.ai-proxy` to `ai.proxy` to avoid conflicts with metrics generated from plugins other than AI Proxy and AI Proxy Advanced. If you are using logging plugins (for example, File Log, HTTP Log, etc.), you will have to update metrics pipeline configurations to reflect this change.
* Deprecated `config.model.options.upstream_path` in favor of `config.model.options.upstream_url`.
* Deprecated `preserve` mode in `config.route_type`. Use `config.llm_format` instead. The `preserve` mode setting will be removed in a future release.
* Added the new `priority` balancer algorithm, which allows setting a priority group for each upstream model.
* Added the `failover_criteria` configuration option, which allows retrying requests to the next upstream server in case of failure.
* Added cost to `tokens_count_strategy` when using the lowest-usage load balancing strategy.
* Added the ability to set a catch-all target in semantic routing.
* Added support for the `pgvector` database.
* Added support for the new Ollama streaming content type in the AI driver.
* Added support for boto3 SDKs for Bedrock provider, and for Google GenAI SDKs for Gemini provider.
* Allow authentication to Bedrock services with assume roles in AWS.
* Added the `huggingface`, `azure`, `vertex`, and `bedrock` providers to embeddings.
* Fixed an issue where the plugin failed to fail over between providers of different formats.
* Fixed an issue where the plugin's identity running failed in retry scenarios.

### {{site.base_gateway}} 3.9.x
* Added support for streaming responses to the AI Proxy Advanced plugin.
* Made the `embeddings.model.name` config field a free text entry, enabling use of a self-hosted (or otherwise compatible) model.
* Fixed an issue where lowest-usage and lowest-latency strategies did not update data points correctly.
* Fixed an issue where stale plugin config was not updated in DB-less and hybrid modes.

### {{site.base_gateway}} 3.8.x

* Introduced the AI Proxy Advanced plugin, which mediates request and response formats, as well as authentication between users and multiple AI providers. This plugin supports load balancing, semantic routing, and multi-provider transformations and provides enhanced request mediation, usage tracking, and self-hosted model support over the regular AI Proxy plugin
