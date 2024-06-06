## Changelog

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
