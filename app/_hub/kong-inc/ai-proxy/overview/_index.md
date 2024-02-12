---
nav_title: Overview
---

The AI Proxy plugin lets you transform and proxy requests to a number of AI providers and models.

The plugin accepts requests in one of a few defined and standardised formats, translates them to the configured target format, and then transforms the response back into a standard format.

The AI Proxy plugin supports `llm/v1/chat` and `llm/v1/completion` style requests for all of the following providers:
* OpenAI
* Cohere
* Azure
* Anthropic
* Mistral (raw and OLLAMA formats)
* Llama2 (raw, OLLAMA, and OpenAI formats)

## How it works

The AI Proxy will mediate for you:

* Request and response formats appropriate for the configured `provider` and `route_type`
* The following service request coordinates (unless model is self-hosted):
  * Protocol
  * Host name
  * Port
  * Path
* Authentication on behalf of the Kong API consumer
* Decorating the request with parameters from the `config.options` block, appropriate for the chosen provider
* Recording of usage statistics of the configured LLM provider and model ([see detail below](hyperlink)) into your selected [Kong Log](hyperlink-to-log-plugins-category) plugin output
* Optionally, additionally recording all post-transformation request and response messages from users, to and from the configured LLM
* Fulfilment of requests to self-hosted models, based on select supported format transformations

Flattening all of the provider formats allows you to standardize the manipulation of the data before and after transmission. It also allows your to provide a choice of LLMs to the Kong consumers, using consistent request/response formats, regardless of the backend provider (or model).

This plugin currently only supports REST-based full text responses.

## Request and Response Formats

The plugin's `config.route_type` should be set based on the target upstream endpoint and model, based on this capability matrix:

| Provider Name | Provider Upstream Path                                 | Kong `route_type`    | Example Model Name     |
|---------------|--------------------------------------------------------|----------------------|------------------------|
| OpenAI        | /v1/chat/completions                                   | `llm/v1/chat`        | gpt-4                  |
| OpenAI        | /v1/completions                                        | `llm/v1/completions` | gpt-3.5-turbo-instruct |
| Cohere        | /v1/chat                                               | `llm/v1/chat`        | command                |
| Cohere        | /v1/generate                                           | `llm/v1/completions` | command                |
| Azure         | /openai/deployments/{deployment_name}/chat/completions | `llm/v1/chat`        | gpt-4                  |
| Azure         | /openai/deployments/{deployment_name}/completions      | `llm/v1/completions` | gpt-3.5-turbo-instruct |
| Anthropic     | /v1/complete                                           | `llm/v1/chat`        | claude-2.1             |
| Anthropic     | /v1/complete                                           | `llm/v1/completions` | claude-2.1             |
| Llama2        | User-defined                                           | `llm/v1/chat`        | User-defined           |
| Llama2        | User-defined                                           | `llm/v1/completions` | User-defined           |
| Mistral       | User-defined                                           | `llm/v1/chat`        | User-defined           |
| Mistral       | User-defined                                           | `llm/v1/completions` | User-defined           |

The following upstream URL patterns are used:

| Provider  | URL                                                                                                    |
|-----------|--------------------------------------------------------------------------------------------------------|
| OpenAI    | `https://api.openai.com:443/{route_type_path}`                                                         |
| Cohere    | `https://api.cohere.com:443/{route_type_path}`                                                         |
| Azure     | `https://{azure_instance}.openai.azure.com:443/openai/deployments/{deployment_name}/{route_type_path}` |
| Anthropic | `https://api.anthropic.com:443/{route_type_path}`                                                      |
| Llama2    | As defined in `config.model.options.upstream_url`                                                      |
| Mistral   | As defined in  `config.model.options.upstream_url`                                                     |


{:.important}
> While only the **Llama2** and **Mistral** models are classed as "self-hosted", the target URL can be overridden for any of the supported providers.
> For example, a self-hosted or otherwise "OpenAI-compatible" endpoint can be called by setting the same `config.model.options.upstream_url` plugin option.

### Input Formats

Kong will mediate the request and response format based on the selected `config.provider` and `config.route_type`, as outlined in the table above.

The Kong AI Proxy accepts the following inputs formats, standardised across all providers; the `config.route_type` must be configured respective to the required request/response format examples:

#### llm/v1/chat

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

#### llm/v1/completions

```json
{
    "prompt": "You are a scientist. What is the theory of relativity?"
}
```

### Response Formats

Conversely, the response formats are also transformed to a standard format across all providers:

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

#### llm/v1/completions

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

The request and response formats are loosely based on OpenAI.
See the [sample OpenAPI specification](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) for more detail on the supported formats.

{:.note}
> Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## Get started with the AI Proxy plugin

* [AI Gateway quickstart: Set up AI Proxy](/gateway/latest/get-started/ai-gateway/)
* [Configuration reference](/hub/kong-inc/ai-proxy/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-proxy/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-proxy/how-to/)

### Other AI plugins

The AI Proxy plugin enables using all of the following AI plugins:
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Template](/hub/kong-inc/ai-prompt-template/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)
