---
nav_title: Overview
---

The AI Proxy Advanced plugin lets you transform and proxy requests to multiple AI providers and models at the same time. 
This lets you set up load balancing between targets.

The plugin accepts requests in one of a few defined and standardized formats, translates them to the configured target format, and then transforms the response back into a standard format.

The following table describes which providers and requests the AI Proxy Advanced plugin supports:

| Provider | Chat | Completion | Streaming |
| -------- | ---- | ---------- | --------- |
| OpenAI (GPT-4, GPT-3.5) | ✅ | ✅ | ✅ |
| OpenAI (GPT-4o and Multi-Modal) | ✅ | ✅ | ✅ |
| Cohere | ✅ | ✅ | ✅ |
| Azure | ✅ | ✅ | ✅ |
| Anthropic | ✅ | ❌ | Only chat type |
| Mistral (mistral.ai, OpenAI, raw, and OLLAMA formats) | ✅ | ✅ | ✅ |
| Llama2 (raw, OLLAMA, and OpenAI formats) | ✅ | ✅ | ✅ |
| Llama3 (OLLAMA and OpenAI formats) | ✅ | ✅ | ✅ |
| Amazon Bedrock | ✅ | ✅ | ✅ |
| Gemini | ✅ | ✅ | ✅ |
{% if_version gte:3.9.x %}
| Hugging Face | ✅ | ✅ | ✅ |
{% endif_version %}

## How it works

The AI Proxy Advanced plugin will mediate the following for you:

* Request and response formats appropriate for the configured `provider` and `route_type`
* The following service request coordinates (unless the model is self-hosted):
  * Protocol
  * Host name
  * Port
  * Path
  * HTTP method
* Authentication on behalf of the Kong API consumer
* Decorating the request with parameters from the `config.options` block, appropriate for the chosen provider
* Recording of usage statistics of the configured LLM provider and model into your selected [Kong log](/hub/?category=logging) plugin output
* Optionally, additionally recording all post-transformation request and response messages from users, to and from the configured LLM
* Fulfillment of requests to self-hosted models, based on select supported format transformations

Flattening all of the provider formats allows you to standardize the manipulation of the data before and after transmission. It also allows your to provide a choice of LLMs to the Kong consumers, using consistent request and response formats, regardless of the backend provider or model.

This plugin currently only supports REST-based full text responses.

## Load balancing

This plugin supports several load-balancing algorithms, similar to those used for Kong upstreams, allowing efficient distribution of requests across different AI models. The supported algorithms include:
* [Lowest-usage](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#lowest-usage): The lowest-usage algorithm in AI Proxy Advanced is based on the volume of usage for each model. It balances the load by distributing requests to models with the lowest usage, measured by factors such as prompt token counts, response token counts, {% if_version gte:3.10.x %} cost, {% endif_version %} or other resource metrics.
* [Lowest-latency](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#lowest-latency): The lowest-latency algorithm is based on the response time for each model. It distributes requests to models with the lowest response time.
* [Semantic](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#semantic-routing): The semantic algorithm distributes requests to different models based on the similarity between the prompt in the request and the description provided in the model configuration. This allows Kong to automatically select the model that is best suited for the given domain or use case. This feature enhances the flexibility and efficiency of model selection, especially when dealing with a diverse range of AI providers and models.
* [Round-robin (weighted)](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#weighted-round-robin)
* [Consistent-hashing (sticky-session on given header value)](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#consistent-hashing)
{% if_version gte:3.10.x -%}
* [Priority Group](/hub/kong-inc/ai-proxy-advanced/how-to/load-balancing/#priority)
{% endif_version %}


## Retry and fallback

The load balancer has customizable retries and timeouts for requests, and can redirect a request to a different model in case of failure. This allows you to have a fallback in case one of your targets is unavailable.

{% if_version gte:3.10.x %}
This plugin supports fallback over targets with any supported formats.
{% else %}
This plugin does not support fallback over targets with different formats. You can use different providers as long as the formats are compatible. For example, load balancers with these combinations of targets are supported:
* Different OpenAI models
* OpenAI models and Mistral models with the OpenAI format
* Mistral models with the OLLAMA format and Llama models with the OLLAMA format
{% endif_version %}


{:.note}
{% if_version gte:3.10.x %}
> To configure failover in addition to network errors, set [`config.balancer.failover_criteria`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-balancer-failover_criteria) to include:
* Additional HTTP error codes, like `http_429` or `http_502`
* The `non_idempotent` setting, as most AI services accept POST requests
{% else %}
> Some errors, such as client errors, result in a failure and don't failover to another target.
{% endif_version %}

## Request and response formats

The plugin's [`config.route_type`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-route_type) should be set based on the target upstream endpoint and model, based on this capability matrix:

| Provider Name | Provider Upstream Path                                   | Kong `route_type`    | Example Model Name     |
|---------------|----------------------------------------------------------|----------------------|------------------------|
| OpenAI        | `/v1/chat/completions`                                   | `llm/v1/chat`        | gpt-4                  |
| OpenAI        | `/v1/completions`                                        | `llm/v1/completions` | gpt-3.5-turbo-instruct |
| Cohere        | `/v1/chat`                                               | `llm/v1/chat`        | command                |
| Cohere        | `/v1/generate`                                           | `llm/v1/completions` | command                |
| Azure         | `/openai/deployments/{deployment_name}/chat/completions` | `llm/v1/chat`        | gpt-4                  |
| Azure         | `/openai/deployments/{deployment_name}/completions`      | `llm/v1/completions` | gpt-3.5-turbo-instruct |

{% if_version gte:3.7.x %}
| Anthropic     | `/v1/messages`                                           | `llm/v1/chat`        | claude-2.1             |
{% endif_version %}
{% if_version lte:3.6.x %}
| Anthropic     | `/v1/complete`                                           | `llm/v1/chat`        | claude-2.1             |
{% endif_version %}

| Anthropic     | `/v1/complete`                                           | `llm/v1/completions` | claude-2.1             |
| Llama2        | User-defined                                             | `llm/v1/chat`        | User-defined           |
| Llama2        | User-defined                                             | `llm/v1/completions` | User-defined           |
| Mistral       | User-defined                                             | `llm/v1/chat`        | User-defined           |
| Mistral       | User-defined                                             | `llm/v1/completions` | User-defined           |
| Amazon Bedrock     | Use the LLM `chat` upstream path                    | `llm/v1/chat`        | [Use the model name for the specific LLM provider](https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html)            |
| Amazon Bedrock     | Use the LLM `completions` upstream path             | `llm/v1/completions` | [Use the model name for the specific LLM provider](https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html)             |
| Gemini     | `llm/v1/chat`                            | `llm/v1/chat`        | `gemini-1.5-flash` or `gemini-1.5-pro`           |
| Gemini     | `llm/v1/completions`                     | `llm/v1/completions` | `gemini-1.5-flash` or `gemini-1.5-pro`            |
{% if_version gte:3.9.x %}
| Hugging Face | `/models/{model_provider}/{model_name}` | `llm/v1/chat` | [Use the model name for the specific LLM provider](https://huggingface.co/models?inference=warm&pipeline_tag=text-generation&sort=trending) |
| Hugging Face | `/models/{model_provider}/{model_name}` | `llm/v1/completions` | [Use the model name for the specific LLM provider](https://huggingface.co/models?inference=warm&pipeline_tag=text-generation&sort=trending) |
{% endif_version %}


The following upstream URL patterns are used:

| Provider  | URL                                                                                                    |
|-----------|--------------------------------------------------------------------------------------------------------|
| OpenAI    | `https://api.openai.com:443/{route_type_path}`                                                         |
| Cohere    | `https://api.cohere.com:443/{route_type_path}`                                                         |
| Azure     | `https://{azure_instance}.openai.azure.com:443/openai/deployments/{deployment_name}/{route_type_path}` |
| Anthropic | `https://api.anthropic.com:443/{route_type_path}`                                                      |
| Llama2    | As defined in `config.model.options.upstream_url`                                                      |
| Mistral   | As defined in  `config.model.options.upstream_url`                                                     |
| Amazon Bedrock   | `https://bedrock-runtime.{region}.amazonaws.com`                                                   |
| Gemini  | `https://generativelanguage.googleapis.com`                                                     |
{% if_version gte:3.9.x %}
| Hugging Face | `https://api-inference.huggingface.co` |
{% endif_version %}

{:.important}
> While only the **Llama2** and **Mistral** models are classed as self-hosted, the target URL can be overridden for any of the supported providers.
> For example, a self-hosted or otherwise OpenAI-compatible endpoint can be called by setting the same [`config.model.options.upstream_url`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-embeddings-model-options-upstream_url) plugin option.

{% if_version gte:3.10.x %}
If you are using each provider's native SDK, {{site.base_gateway}} allows you to transparently proxy the
request without any transformation and return the response unmodified. This can be done by setting
[`config.llm_format`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-llm_format) to a value other than `openai`, such as `gemini` or `bedrock`.

In this mode, {{site.base_gateway}} will still provide useful analytics, logging, and cost calculation.
{% endif_version %}

### Input formats

{% if_version lte:3.9.x %}
Kong will mediate the request and response format based on the selected [`config.provider`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-embeddings-model-provider) and [`config.route_type`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-route_type), as outlined in the table above.
{% endif_version %}

{% if_version gte:3.10.x %}
Kong will mediate the request and response format based on the selected [`config.targets[].provider`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-embeddings-model-provider) and [`config.targets[].route_type`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-route_type), as outlined in the table above.

By default, Kong uses OpenAI format and can be changed using [`config.targets[].llm_format`](/hub/kong-inc/ai-proxy-advanced/configuration/#config-targets-llm_format). When `llm_format` is not set to `openai`, this plugin will not transform the request when sending to upstream and will keep it as-is.
{% endif_version %}
The Kong AI Proxy accepts the following inputs formats, standardized across all providers; the `config.route_type` must be configured respective to the required request and response format examples:

{% navtabs %}
{% navtab llm/v1/chat %}
```json
{
    "messages": [
        {
            "role": "system",
            "content": "You are a scientist."
        },
        {
            "role": "user",
            "content": "What is the theory of relativity?"
        }
    ]
}
```
{% if_version gte:3.9.x %}
With Amazon Bedrock, you can include your [guardrail](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html) configuration in the request:
```json
{
    "messages": [
        {
            "role": "system",
            "content": "You are a scientist."
        },
        {
            "role": "user",
            "content": "What is the theory of relativity?"
        }
    ],
    "extra_body":
        {
            "guardrailConfig":
                {
                    "guardrailIdentifier":"<guardrail_identifier>",
                    "guardrailVersion":"1",
                    "trace":"enabled"
                }
        }
}
```
{% endif_version %}
{% endnavtab %}

{% navtab llm/v1/completions %}
```json
{
    "prompt": "You are a scientist. What is the theory of relativity?"
}
```
{% endnavtab %}
{% endnavtabs %}

### Response formats

Conversely, the response formats are also transformed to a standard format across all providers:

{% navtabs %}
{% navtab llm/v1/chat %}
```json
{
    "choices": [
        {
            "finish_reason": "stop",
            "index": 0,
            "message": {
                "content": "The theory of relativity is a...",
                "role": "assistant"
            }
        }
    ],
    "created": 1707769597,
    "id": "chatcmpl-ID",
    "model": "gpt-4-0613",
    "object": "chat.completion",
    "usage": {
        "completion_tokens": 5,
        "prompt_tokens": 26,
        "total_tokens": 31
    }
}
```
{% endnavtab %}

{% navtab llm/v1/completions %}

```json
{
    "choices": [
        {
            "finish_reason": "stop",
            "index": 0,
            "text": "The theory of relativity is a..."
        }
    ],
    "created": 1707769597,
    "id": "cmpl-ID",
    "model": "gpt-3.5-turbo-instruct",
    "object": "text_completion",
    "usage": {
        "completion_tokens": 10,
        "prompt_tokens": 7,
        "total_tokens": 17
    }
}
```
{% endnavtab %}
{% endnavtabs %}

The request and response formats are loosely based on OpenAI.
See the [sample OpenAPI specification](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) for more detail on the supported formats.

## Get started with the AI Proxy plugin

* [Configuration reference](/hub/kong-inc/ai-proxy-advanced/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-proxy-advanced/how-to/basic-example/)
* Learn how to use the plugin with different providers:
  * [OpenAI](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/openai/)
  * [Cohere](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/cohere/)
  * [Azure](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/azure/)
  * [Anthropic](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/anthropic/)
  * [Mistral](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/mistral/)
  * [Llama2](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/llama2/)
  * [Gemini/Vertex](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/gemini/)
  * [Amazon Bedrock](/hub/kong-inc/ai-proxy-advanced/how-to/llm-provider-integration-guides/bedrock/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}

