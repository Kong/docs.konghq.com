---
nav_title: Getting started with AI Proxy
title: Getting started with AI Proxy
---

## Initial Step

For all providers, the Kong AI Proxy plugin attaches to **route** entities.

It can be installed into one route per operation, for example:

* OpenAI "Chat" Route
* Cohere "Chat" Route
* Cohere "Completions" Route

Each of these AI-enabled routes must point to a "null" service. This service does not need to map to any real upstream URL,
it can point somewhere empty (for example on `http://localhost:32000`).

**This requirement will be removed in a later Kong revision.**

You should create this service **first** like in this example:

```bash
curl -X POST http://localhost:8001/services \
    --data "name=ai-proxy" \
    --data "url=http://localhost:32000"
```

## Provider Configuration

Now you can create a **route** and accompanying **AI-Proxy plugin** for your AI implementation.

{% navtabs %}

{% navtab OpenAI %}

## Setup

After creating an OpenAI account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: openai-chat
paths:
  - "~/openai-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <openai_key>"  # add your own OpenAI API key
      model:
        provider: "openai"
        name: "gpt-4"
        options:
          max_tokens: 512
          temperature: 1.0
```

## Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=openai-chat" \
    --data "paths[]=~/openai-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/openai-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=Authorization" \
    --data "config.auth.header_value=Bearer <openai_key>" \
    --data "config.model.provider=openai" \
    --data "config.model.name=gpt-4" \
    --data "config.model.options.max_tokens=512" \
    --data "config.model.options.temperature=1.0"
```

## Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/openai-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% navtab Azure %}
{:.important}
> The Azure provider specifically supports the "Azure OpenAI Service".

## Setup

### Create / Locate OpenAI Instance

Log in to your Azure Subscription, and (if necessary) create your OpenAI instance. Record its name as your **"azure_instance"**.
Also record one of the access keys as its **"header_value"**:

![Azure setup 1](/assets/images/products/plugins/ai-proxy/ai-proxy-azure-1.png)

### Create / Locate Model Deployment

Once it has instantiated, create (if necessary) a model deployment in this instance. Record its name as your **"azure_deployment_id"**:

![Azure setup 2](/assets/images/products/plugins/ai-proxy/ai-proxy-azure-2.png)

Now you can create an AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: azure-chat
paths:
  - "~/azure-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "api-key"
        header_value: "<azure_ai_access_key>"  # add your own 'Azure OpenAI' access key
      model:
        provider: "azure"
        name: "gpt-35-turbo"
        options:
          azure_instance: "ai-proxy-regression"
          azure_deployment_id: "kong-gpt-3-5"
```

### Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=azure-chat" \
    --data "paths[]=~/azure-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/azure-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=api-key" \
    --data "config.auth.header_value=<azure_ai_access_key>" \
    --data "config.model.provider=azure" \
    --data "config.model.name=gpt-35-turbo" \
    --data "config.model.options.azure_instance=ai-proxy-regression" \
    --data "config.model.options.azure_deployment_id=kong-gpt-3-5"
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/azure-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% navtab Cohere %}

## Setup

After creating a Cohere account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: cohere-chat
paths:
  - "~/cohere-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "Authorization"
        header_value: "Bearer <cohere_key>"  # add your own Cohere API key
      model:
        provider: "cohere"
        name: "command"
        options:
          max_tokens: 512
          temperature: 1.0
```

## Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=cohere-chat" \
    --data "paths[]=~/cohere-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/cohere-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=Authorization" \
    --data "config.auth.header_value=Bearer <cohere_key>" \
    --data "config.model.provider=cohere" \
    --data "config.model.name=command" \
    --data "config.model.options.max_tokens=512" \
    --data "config.model.options.temperature=1.0"
```

## Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/cohere-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% navtab Anthropic %}

## Setup

After creating an Anthropic account, and purchasing a subscription, you can then create an
AI Proxy route and plugin configuration (based off this configuration YAML):

```yaml
name: anthropic-chat
paths:
  - "~/anthropic-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      auth:
        header_name: "apikey"
        header_value: "<anthropic_key>"  # add your own Anthropic API key
      model:
        provider: "anthropic"
        name: "claude-2.1"
        options:
          max_tokens: 512
          temperature: 1.0
          top_p: 256
          top_k: 0.5
```

## Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=anthropic-chat" \
    --data "paths[]=~/anthropic-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/anthropic-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.auth.header_name=apikey" \
    --data "config.auth.header_value=<anthropic_key>" \
    --data "config.model.provider=anthropic" \
    --data "config.model.name=claude-2.1" \
    --data "config.model.options.max_tokens=512" \
    --data "config.model.options.temperature=1.0" \
    --data "config.model.options.top_p=256" \
    --data "config.model.options.top_k=0.5"
```

## Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/anthropic-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% navtab Llama2 %}

{:.important}
> Llama2 is a "self-hosted" model - as such, it requires the model option `upstream_url` to be set, pointing to the absolute
> HTTP(S) endpoint for this model implementation.

There are a number of hosting/format options for running this LLM. Popular options include:

* [HuggingFace](https://huggingface.co/docs/transformers/model_doc/llama2)
* [OLLAMA](https://ollama.com/)
* [llama.cpp](https://github.com/ggerganov/llama.cpp)
* [Hosting the GGUF model yourself, with an e.g. Python Web Server](https://huggingface.co/meta-llama/Llama-2-7b-chat-hf)

## Upstream Formats

The "upstream" request and response formats are different between various implementations of Llama2, and/or its accompanying web-server.

For this provider, the following should be used for the `config.model.options.llama2_format` parameter:

| Llama2 Hosting   | llama2_format Config Value | Auth Header?            |
|------------------|----------------------------|-------------------------|
| HuggingFace      | `raw`                      | `Authorization`         |
| OLLAMA           | `ollama`                   | Not required by default |
| llama.cpp        | `raw`                      | Not required by default |
| Self-Hosted GGUF | `openai`                   | Not required by default |

### Raw Format

The `raw` format option emits the full Llama2 prompt format, under the JSON field `inputs`:

```json
{
  "inputs": "<s>[INST] <<SYS>>You are a mathematician. \n <</SYS>> \n\n What is 1 + 1? [/INST]"
}
```

It expects the response to be in the `responses` JSON field. If using `llama.cpp`, it should
also be set to `RAW`mode.

### Ollama Format

The `ollama` format option adheres to the "chat" and "chat-completion" request formats,
[as defined in its API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md).

### OpenAI Format

The `openai` format option follows the same upstream formats as the equivalent OpenAI route_type operation.

## Setup

After installing and starting your Llama2 instance

```yaml
name: llama2-chat
paths:
  - "~/llama2-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      model:
        provider: "llama2"
        name: "llama2"
        llama2_format: "ollama"
        upstream_url: "http://llama2-server.local:11434/v1/chat"
```

## Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=llama2-chat" \
    --data "paths[]=~/llama2-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/llama2-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.model.provider=llama2" \
    --data "config.model.name=llama2" \
    --data "config.model.options.llama2_format=ollama" \
    --data "config.model.options.upstream_url=http://ollama-server.local:11434/v1/chat" \ 
```

## Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/llama2-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% navtab Mistral %}

{:.important}
> Mistral is a "self-hosted" model - as such, it requires the model option `upstream_url` to be set, pointing to the absolute
> HTTP(S) endpoint for this model implementation.

There are a number of hosting/format options for running this LLM. Popular options include:

* [OLLAMA](https://ollama.com/)
* [Hosting the GGUF model yourself, with an e.g. Python Web Server](https://huggingface.co/mistralai/Mixtral-8x7B-v0.1)

## Upstream Formats

The "upstream" request and response formats are different between various implementations of Mistral, and/or its accompanying web-server.

For this provider, the following should be used for the `config.model.options.mistral_format` parameter:

| Mistral Hosting  | mistral_format Config Value | Auth Header?            |
|------------------|-----------------------------|-------------------------|
| OLLAMA           | `ollama`                    | Not required by default |
| Self-Hosted GGUF | `openai`                    | Not required by default |

### Ollama Format

The `ollama` format option adheres to the "chat" and "chat-completion" request formats,
[as defined in its API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md).

### OpenAI Format

The `openai` format option follows the same upstream formats as the equivalent OpenAI route_type operation.

## Setup

After installing and starting your Mistral instance

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
      model:
        provider: "mistral"
        name: "mistral"
        mistral_format: "ollama"
        upstream_url: "http://ollama-server.local:11434/v1/chat"
```

## Plugin Installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=mistral-chat" \
    --data "paths[]=~/mistral-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/mistral-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.model.provider=mistral" \
    --data "config.model.name=mistral" \
    --data "config.model.options.mistral_format=ollama" \
    --data "config.model.options.upstream_url=http://ollama-server.local:11434/v1/chat" \ 
```

## Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/mistral-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```

{% endnavtab %}

{% endnavtabs %}


Placeholder.
