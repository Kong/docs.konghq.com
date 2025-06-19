---
nav_title: Mistral
title: Set up AI Proxy with Mistral
---

This guide walks you through setting up the AI Proxy plugin with [Mistral](https://mistral.ai/).

{:.important}
> Mistral is a self-hosted model. As such, it requires setting model option 
> [`upstream_url`](/hub/kong-inc/ai-proxy/configuration/#config-model-options-upstream_url) to point to the absolute
> HTTP(S) endpoint for this model implementation.

There are a number of hosting/format options for running this LLM. Mistral offers a cloud-hosted service for consuming
the LLM, available at [Mistral.ai](https://mistral.ai/)

Self-hosted options include:
* [OLLAMA](https://ollama.com/)
* [Hosting the GGUF model yourself, with an e.g. Python Web Server](https://huggingface.co/mistralai/Mixtral-8x7B-v0.1)

## Upstream Formats

The "upstream" request and response formats are different between various implementations of Mistral, and/or its accompanying web-server.

For this provider, the following should be used for the [`config.model.options.mistral_format`](/hub/kong-inc/ai-proxy/configuration/#config-model-options-mistral_format) parameter:

| Mistral Hosting  | `mistral_format` Config Value | Auth Header             |
|------------------|-------------------------------|-------------------------|
| Mistral.ai       | `openai`                      | `Authorization`         |
| OLLAMA           | `ollama`                      | Not required by default |
| Self-Hosted GGUF | `openai`                      | Not required by default |

### OpenAI Format

The `openai` format option follows the same upstream formats as the equivalent 
[OpenAI route type operation](https://github.com/kong/kong/blob/master/spec/fixtures/ai-proxy/oas.yaml) 
(that is, `llm/v1/chat` or `llm/v1/completions`).

This format should be used when configuring the cloud-based [https://mistral.ai/](https://mistral.ai/).

It will transform both `llm/v1/chat` and `llm/v1/completions` type route requests, into the same format.

### Ollama Format

The `ollama` format option adheres to the `chat` and `chat-completion` request formats,
as defined in its [API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md).

## Using the plugin with Mistral

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

### Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='service' %}

### Set up route and plugin

After installing and starting your Mistral instance, you can then create an
AI Proxy route and plugin configuration.

{% navtabs %}
{% navtab Kong Admin API %}

Create the route:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
  --data "name=mistral-chat" \
  --data "paths[]=~/mistral-chat$"
```

Enable and configure the AI Proxy plugin for Mistral (using `openai` format in this example):

```bash
curl -X POST http://localhost:8001/routes/mistral-chat/plugins \
  --data "name=ai-proxy" \
  --data "config.route_type=llm/v1/chat" \
  --data "config.auth.header_name=Authorization" \
  --data "config.auth.header_value=Bearer <MISTRAL_AI_KEY>" \
  --data "config.model.provider=mistral" \
  --data "config.model.name=mistral-tiny" \
  --data "config.model.options.mistral_format=openai" \
  --data "config.model.options.upstream_url=https://api.mistral.ai/v1/chat/completions" \ 
```
{% endnavtab %}
{% navtab YAML %}
```yaml
name: mistral-chat
paths:
  - "~/mistral-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <MISTRAL_AI_KEY>"
      model:
        provider: "mistral"
        name: "mistral-tiny"
        options:
          mistral_format: "openai"
          upstream_url: "https://api.mistral.ai/v1/chat/completions"
```
{% endnavtab %}
{% endnavtabs %}

### Test the configuration

Make an `llm/v1/chat` type request to test your new endpoint:

```bash
curl -X POST http://localhost:8000/mistral-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```
{% include_cached /md/plugins-hub/ai-custom-model.md %}