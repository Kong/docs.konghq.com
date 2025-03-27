## Changelog

### {{site.base_gateway}} 3.10.0.0
* Deprecated `config.model.options.upstream_path` in favor of `config.model.options.upstream_url`.
* Deprecated `preserve` mode in `config.route_type`. Use `config.llm_format` instead. The `preserve` mode setting will be removed in a future release.

### {{site.base_gateway}} 3.9.0.0
* Fixed an issue where Azure Managed Identity did not work for the AI Transformer plugins.
* Fixed an issue where AI Transformer plugins always returned a 404 error when using Google One Gemini subscriptions.
  [#13703](https://github.com/Kong/kong/issues/13703)
* Fixed an issue where the correct LLM error message was not propagated to the caller.
  [#13703](https://github.com/Kong/kong/issues/13703)

### {{site.base_gateway}} 3.8.0.0
* Fixed an issue where Cloud Identity authentication was not used in `ai-request-transformer` and `ai-response-transformer` plugins.

### {{site.base_gateway}} 3.6.0.0

* Introduced the new **AI Request Transformer** plugin.