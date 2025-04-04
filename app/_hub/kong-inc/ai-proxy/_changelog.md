## Changelog

### {{site.base_gateway}} 3.10.x
* Changed the serialized log key of AI metrics from `ai.ai-proxy` to `ai.proxy` to avoid conflicts with metrics generated from plugins other than AI Proxy and AI Proxy Advanced. If you are using logging plugins (for example, File Log, HTTP Log, etc.), you will have to update metrics pipeline configurations to reflect this change.
* Deprecated `config.model.options.upstream_path` in favor of `config.model.options.upstream_url`.
* Deprecated `preserve` mode in `config.route_type`. Use `config.llm_format` instead. The `preserve` mode setting will be removed in a future release.
* Fixed a bug in the Azure provider where `model.options.upstream_path` overrides would always return a 404 response.
* Fixed a bug where Azure streaming responses would be missing individual tokens.
* Fixed a bug where response streaming in Gemini and Bedrock providers was returning whole chat responses in one chunk.
* Fixed a bug with the Gemini provider, where multimodal requests (in OpenAI format) would not transform properly.
* Fixed an issue where Gemini streaming responses were getting truncated and/or missing tokens.
* Fixed an incorrect error thrown when trying to log streaming responses.
* Fixed `preserve` mode.

### {{site.base_gateway}} 3.9.x
* Disabled the HTTP/2 ALPN handshake for connections on routes configured with AI Proxy.
[#13735](https://github.com/Kong/kong/issues/13735)
* Fixed an issue where tools (function) calls to Anthropic would return empty results.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where tools (function) calls to Bedrock would return empty results.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where Bedrock Guardrail config was ignored.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where tools (function) calls to Cohere would return empty results.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where the Gemini provider would return an error if content safety failed in AI Proxy.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where tools (function) calls to Gemini (or via Vertex) would return empty results.
[#13760](https://github.com/Kong/kong/issues/13760)
* Fixed an issue where multi-modal requests were blocked on the Azure AI provider.
[#13702](https://github.com/Kong/kong/issues/13702)

### {{site.base_gateway}} 3.8.x

* Added the `allow_override` option to allow overriding the upstream model auth parameter or header from the caller's request.
[#13158](https://github.com/Kong/kong/issues/13158)
* Replaced the library and use `cycle_aware_deep_copy` for the `request_table` object.
[#13582](https://github.com/Kong/kong/issues/13582)
* The Mistral provider can now use mistral.ai-managed services by omitting the `upstream_url`.
[#13481](https://github.com/Kong/kong/issues/13481)
* Added the new response header `X-Kong-LLM-Model`, which displays the name of the language model used in the AI Proxy plugin.
[#13472](https://github.com/Kong/kong/issues/13472)
* Latency data is now pushed to logs and metrics.
[#13428](https://github.com/Kong/kong/issues/13428)
* Kong AI Gateway now supports all AWS Bedrock Converse API models.
[#12948](https://github.com/Kong/kong/issues/12948)
* Kong AI Gateway now supports the Google Gemini chat (`generateContent`) interface.
[#12948](https://github.com/Kong/kong/issues/12948)
* Fixed various issues [#13000](https://github.com/Kong/kong/issues/13000): 
    * Fixed an issue where certain Azure models would return partial tokens/words when in response-streaming mode.
    * Fixed an issue where Cohere and Anthropic providers didn't read the `model` parameter properly from the caller's request body.
    * Fixed an issue where using OpenAI Function inference requests would log a request error, and then hang until timeout.
    * Fixed an issue where AI Proxy would still allow callers to specify their own model, ignoring the plugin-configured model name.
    * Fixed an issue where AI Proxy would not take precedence of the plugin's configured model tuning options over those in the user's LLM request.
    * Fixed an issue where setting OpenAI SDK model parameter `null` caused analytics to not be written to the logging plugin(s).
* Fixed an issue when response was gzipped even if the client didn't accept the format.
[#13155](https://github.com/Kong/kong/issues/13155)
* Fixed an issue where the object constructor would set data on the class instead of the instance.
[#13028](https://github.com/Kong/kong/issues/13028)
* Added a configuration validation to prevent `log_statistics` from being enabled on providers that don't support statistics.
Accordingly, the default of `log_statistics` has changed from `true` to `false`, and a database migration has been added for 
disabling `log_statistics` if it has already been enabled upon unsupported providers.
[#12860](https://github.com/Kong/kong/issues/12860)
* Fixed an issue where the plugin couldn't be applied per consumer or per service.
  [#13209](https://github.com/Kong/kong/issues/13209)

### {{site.base_gateway}} 3.7.x

* To support the new messages API of Anthropic,
the upstream path of the `Anthropic` for `llm/v1/chat` route type has changed from `/v1/complete` to `/v1/messages`.
* Added support for [streaming event-by-event responses](/hub/kong-inc/ai-proxy/how-to/streaming/) back to the client on supported providers.
[#12792](https://github.com/Kong/kong/issues/12792)
* AI Proxy now reads most prompt tuning parameters from the client, 
while the plugin config parameters under [`model_options`](/hub/kong-inc/ai-proxy/configuration/#config-model_options) are now just defaults.
This fixes support for using the respective provider's native SDK.
[#12903](https://github.com/Kong/kong/issues/12903)
* You can now [use an existing OpenAI-compatible SDK](/hub/kong-inc/ai-proxy/how-to/sdk-usage) (for example, Python OpenAI) to call
different models, providers, and configurations with Kong AI Gateway.
AI Proxy now has a [`preserve` option for `route_type`](/hub/kong-inc/ai-proxy/configuration/#config-route_type), 
where the requests and responses are passed directly to the upstream LLM. This enables compatibility with any
models and SDKs that may be used when calling the AI services.
[#12903](https://github.com/Kong/kong/issues/12903)
* Added support for [streaming event-by-event responses](/hub/kong-inc/ai-proxy/how-to/streaming/) back to the client on supported providers.
[#12792](https://github.com/Kong/kong/issues/12792)
* **Enterprise feature:** You can now use Azure's native authentication mechanism to [secure your cloud-hosted models](/hub/kong-inc/ai-proxy/how-to/cloud-provider-authentication/).

### {{site.base_gateway}} 3.6.x

* Introduced the AI Proxy plugin, which can mediate request and response formats, as well as authentication between users. This plugin supports a variety of Large Language Model (LLM) AI services.
