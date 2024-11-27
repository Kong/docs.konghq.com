---
nav_title: Overview
---

The AI Proxy plugin lets you transform and proxy requests to a number of AI providers and models.

The plugin accepts requests in one of a few defined and standardised formats, translates them to the configured target format, and then transforms the response back into a standard format.

{% if_version lte:3.6.x %}
The AI Proxy plugin supports `llm/v1/chat` and `llm/v1/completion` style requests for all of the following providers:
* OpenAI
* Cohere
* Azure
* Anthropic
* Mistral (raw and OLLAMA formats)
* Llama2 (raw, OLLAMA, and OpenAI formats)
{% endif_version %}
{% if_version gte:3.7.x %}
The following table describes which providers and requests the AI Proxy plugin supports:

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
{% endif_version %}
{% if_version gte:3.8.x %}
| Amazon Bedrock | ✅ | ✅ | ✅ |
| Gemini | ✅ | ✅ | ✅ |
{% endif_version %}

## How it works

The AI Proxy will mediate the following for you:

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

## Request and response formats

The plugin's [`config.route_type`](/hub/kong-inc/ai-proxy/configuration/#config-route_type) should be set based on the target upstream endpoint and model, based on this capability matrix:

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

{% if_version gte:3.8.x %}
| Amazon Bedrock     | Use the LLM `chat` upstream path                    | `llm/v1/chat`        | [Use the model name for the specific LLM provider](https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html)            |
| Amazon Bedrock     | Use the LLM `completions` upstream path             | `llm/v1/completions` | [Use the model name for the specific LLM provider](https://docs.aws.amazon.com/bedrock/latest/userguide/model-ids.html)             |
| Gemini     | `llm/v1/chat`                            | `llm/v1/chat`        | `gemini-1.5-flash` or `gemini-1.5-pro`           |
| Gemini     | `llm/v1/completions`                     | `llm/v1/completions` | `gemini-1.5-flash` or `gemini-1.5-pro`            |
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

{% if_version gte:3.8.x %}
| Amazon Bedrock   | `https://bedrock-runtime.{region}.amazonaws.com`                                                   |
| Gemini  | `https://generativelanguage.googleapis.com`                                                    |
{% endif_version %}

{:.important}
> While only the **Llama2** and **Mistral** models are classed as self-hosted, the target URL can be overridden for any of the supported providers.
> For example, a self-hosted or otherwise OpenAI-compatible endpoint can be called by setting the same [`config.model.options.upstream_url`](/hub/kong-inc/ai-proxy/configuration/#config-model-options-upstream_url) plugin option.

### Input formats

Kong will mediate the request and response format based on the selected [`config.provider`](/hub/kong-inc/ai-proxy/configuration/#config-provider) and [`config.route_type`](/hub/kong-inc/ai-proxy/configuration/#config-route_type), as outlined in the table above.

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

{:.note}
> Check out the [AI Gateway quickstart](/gateway/latest/get-started/ai-gateway/) to get an AI proxy up and running within minutes!

## Get started with the AI Proxy plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-proxy/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-proxy/how-to/basic-example/)
* Learn how to use the plugin with different providers:
  * [OpenAI](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/openai/)
  * [Cohere](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/cohere/)
  * [Azure](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/azure/)
  * [Anthropic](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/anthropic/)
  * [Mistral](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/mistral/)
  * [Llama2](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/llama2/)
  * [Gemini/Vertex](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/gemini/)
  * [Amazon Bedrock](/hub/kong-inc/ai-proxy/how-to/llm-provider-integration-guides/bedrock/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}

